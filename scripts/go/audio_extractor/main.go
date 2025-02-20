package main

import (
	"flag"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// 常见视频格式
var videoExtensions = map[string]bool{
	".mp4":  true,
	".mkv":  true,
	".avi":  true,
	".mov":  true,
	".flv":  true,
	".wmv":  true,
	".webm": true,
	".mpeg": true,
}

// isVideoByExt 通过扩展名判断是否为视频文件
func isVideoByExt(filePath string) bool {
	ext := strings.ToLower(filepath.Ext(filePath)) // 统一转小写避免匹配失败
	return videoExtensions[ext]
}

// getAudioFormat 使用 ffmpeg 获取音频格式
func getAudioFormat(videoPath string) (string, error) {
	cmd := exec.Command("ffprobe", "-v", "error", "-select_streams", "a:0", "-show_entries", "stream=codec_name",
		"-of", "default=nokey=1:noprint_wrappers=1", videoPath)

	output, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("无法获取音频格式: %w", err)
	}

	audioFormat := strings.TrimSpace(string(output))
	if audioFormat == "" {
		return "", fmt.Errorf("未能检测到音频流")
	}
	return audioFormat, nil
}

// extractAudio 提取原始音频（无损）
func extractAudio(videoPath, audioPath string) error {
	cmd := exec.Command("ffmpeg", "-y", "-i", videoPath, "-vn", "-acodec", "copy", audioPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("提取音频失败: %w", err)
	}

	fmt.Printf("音频已成功提取到 %s\n", audioPath)
	return nil
}

// extractAudioWithFormat 提取音频并转换为指定格式
func extractAudioWithFormat(videoPath, audioPath string) error {
	cmd := exec.Command("ffmpeg", "-y", "-i", videoPath, "-q:a", "0", "-map", "a", audioPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("提取音频失败: %w", err)
	}

	fmt.Printf("音频已成功提取到 %s\n", audioPath)
	return nil
}

func main() {
	// 解析命令行参数
	format := flag.String("f", "", "指定音频格式 (如 mp3, aac, flac)")
	flag.Parse()

	if flag.NArg() < 1 {
		fmt.Println("请提供需要处理的目录路径")
		return
	}
	rootDir := flag.Arg(0)

	var processedFiles []string
	var failedFiles []string

	err := filepath.WalkDir(rootDir, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if d.IsDir() {
			return nil
		}

		if isVideoByExt(path) {
			var targetFormat string
			if *format != "" {
				targetFormat = *format
			} else {
				// 获取原始音频格式
				var err error
				targetFormat, err = getAudioFormat(path)
				if err != nil {
					fmt.Printf("无法处理文件 %s: %v\n", path, err)
					failedFiles = append(failedFiles, path)
					return nil
				}
			}

			audioPath := path[:len(path)-len(filepath.Ext(path))] + "." + targetFormat
			if *format != "" {
				if err := extractAudioWithFormat(path, audioPath); err != nil {
					fmt.Printf("处理文件 %s 时出错: %v\n", path, err)
					failedFiles = append(failedFiles, path)
				} else {
					processedFiles = append(processedFiles, audioPath)
				}
			} else {
				if err := extractAudio(path, audioPath); err != nil {
					fmt.Printf("处理文件 %s 时出错: %v\n", path, err)
					failedFiles = append(failedFiles, path)
				} else {
					processedFiles = append(processedFiles, audioPath)
				}
			}
		}
		return nil
	})

	if err != nil {
		fmt.Printf("遍历目录时出错: %v\n", err)
	}

	// 打印最终结果
	fmt.Println("\n========= 处理完成 =========")
	fmt.Printf("成功提取 %d 个音频文件:\n", len(processedFiles))
	for _, file := range processedFiles {
		fmt.Println("  -", file)
	}

	if len(failedFiles) > 0 {
		fmt.Printf("\n%d 个文件处理失败:\n", len(failedFiles))
		for _, file := range failedFiles {
			fmt.Println("  -", file)
		}
	} else {
		fmt.Println("\n所有文件处理成功！")
	}
}
