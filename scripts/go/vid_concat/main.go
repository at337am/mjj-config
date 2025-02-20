package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"vid_concat/config"
)

// 常见音频格式
var audioExtensions = map[string]bool{
	".mp3":  true,
	".wav":  true,
	".aac":  true,
	".flac": true,
	".ogg":  true,
	".m4a":  true,
	".wma":  true,
	".opus": true,
	".aiff": true,
	".alac": true,
}

// findFirstAudioFile 遍历目录，寻找第一个匹配的音频文件
func findFirstAudioFile(dir string) (string, error) {
	files, err := os.ReadDir(dir)
	if err != nil {
		return "", err
	}
	for _, file := range files {
		if file.IsDir() {
			continue
		}
		ext := strings.ToLower(filepath.Ext(file.Name()))
		if audioExtensions[ext] {
			return filepath.Join(dir, file.Name()), nil
		}
	}
	return "", fmt.Errorf("未找到音频文件")
}

// removeAudio 去除视频音轨，调用命令：ffmpeg -y -i inputVideo -c copy -an outputVideo
func removeAudio(inputVideo, outputVideo string) error {
	args := []string{"-y", "-i", inputVideo, "-c", "copy", "-an", outputVideo}
	fmt.Printf("执行命令: ffmpeg %s\n", strings.Join(args, " "))
	cmd := exec.Command("ffmpeg", args...)
	// 将标准输出和错误输出定向到控制台
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

// getVideoDuration 获取视频或音频时长（秒），调用命令：ffprobe -i videoPath -show_entries format=duration -v quiet -of csv=p=0
func getVideoDuration(videoPath string) (float64, error) {
	args := []string{"-i", videoPath, "-show_entries", "format=duration", "-v", "quiet", "-of", "csv=p=0"}
	cmd := exec.Command("ffprobe", args...)
	output, err := cmd.Output()
	if err != nil {
		return 0, err
	}
	durationStr := strings.TrimSpace(string(output))
	duration, err := strconv.ParseFloat(durationStr, 64)
	if err != nil {
		return 0, err
	}
	return duration, nil
}

// loopVideo 循环视频直到达到指定时长，调用命令：ffmpeg -y -stream_loop -1 -i inputVideo -t duration -c copy outputVideo
func loopVideo(inputVideo, outputVideo string, duration float64) error {
	args := []string{"-y", "-stream_loop", "-1", "-i", inputVideo, "-t", fmt.Sprintf("%.2f", duration), "-c", "copy", outputVideo}
	fmt.Printf("执行命令: ffmpeg %s\n", strings.Join(args, " "))
	cmd := exec.Command("ffmpeg", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

// concatVideos 横向拼接两个视频并统一高度为1080，调用命令：
// ffmpeg -y -i video1 -i video2 -filter_complex "[0:v]scale=-2:1080[v0];[1:v]scale=-2:1080[v1];[v0][v1]hstack=inputs=2[out]" -map "[out]" -c:v libx264 -crf 23 -preset fast outputVideo
func concatVideos(video1, video2, outputVideo string) error {
	filter := "[0:v]scale=-2:1080[v0];[1:v]scale=-2:1080[v1];[v0][v1]hstack=inputs=2[out]"
	args := []string{"-y", "-i", video1, "-i", video2, "-filter_complex", filter, "-map", "[out]", "-c:v", "libx264", "-crf", "23", "-preset", "fast", outputVideo}
	fmt.Printf("执行命令: ffmpeg %s\n", strings.Join(args, " "))
	cmd := exec.Command("ffmpeg", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

// addAudio 给视频添加背景音轨，调用命令：ffmpeg -y -i video -i audio -c:v copy -c:a aac -strict experimental outputVideo
func addAudio(video, audio, outputVideo string) error {
	args := []string{"-y", "-i", video, "-i", audio, "-c:v", "copy", "-c:a", "aac", "-strict", "experimental", outputVideo}
	fmt.Printf("执行命令: ffmpeg %s\n", strings.Join(args, " "))
	cmd := exec.Command("ffmpeg", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func main() {

	config.InitConfig()

	video1 := config.GetVideo1FilePath()
	video2 := config.GetVideo2FilePath()
	outputVideo := config.GetOutputVideoFilePath()

	// 获取音频文件夹路径
	audioPath := config.GetAudioDirPath()

	// 寻找第一个音频文件
	foundAudio, err := findFirstAudioFile(audioPath)
	if err != nil {
		fmt.Println("未找到音频文件，将输出无声视频。")
		audioPath = ""
	} else {
		fmt.Printf("找到音频文件: %s\n", foundAudio)
		audioPath = foundAudio
	}

	// 确保 tmp 目录存在
	tmpDir := "tmp"
	if err := os.MkdirAll(tmpDir, 0755); err != nil {
		log.Fatalf("创建临时目录失败：%v", err)
	}

	video1NoAudio := filepath.Join(tmpDir, "video1_no_audio.mp4")
	video2NoAudio := filepath.Join(tmpDir, "video2_no_audio.mp4")

	// 去除视频音轨
	fmt.Println("正在去除视频音轨...")
	if err := removeAudio(video1, video1NoAudio); err != nil {
		log.Fatalf("去除视频1音轨失败：%v", err)
	}
	if err := removeAudio(video2, video2NoAudio); err != nil {
		log.Fatalf("去除视频2音轨失败：%v", err)
	}

	// 获取视频和音频时长
	fmt.Println("正在获取视频和音频时长...")
	duration1, err := getVideoDuration(video1NoAudio)
	if err != nil {
		log.Fatalf("获取视频1时长失败：%v", err)
	}
	duration2, err := getVideoDuration(video2NoAudio)
	if err != nil {
		log.Fatalf("获取视频2时长失败：%v", err)
	}
	audioDuration, err := getVideoDuration(audioPath)
	// 当音频文件不存在时，忽略获取时长错误
	if err != nil {
		fmt.Println("音频文件不存在，将输出无声视频")
		audioDuration = 0
	}
	fmt.Printf("视频1时长：%.2f秒，视频2时长：%.2f秒，音频时长：%.2f秒\n", duration1, duration2, audioDuration)

	// 计算目标时长：取视频时长最大值和音频时长中的较大者
	maxVideoDuration := duration1
	if duration2 > maxVideoDuration {
		maxVideoDuration = duration2
	}
	targetDuration := maxVideoDuration
	if audioDuration > targetDuration {
		targetDuration = audioDuration
	}
	fmt.Printf("目标时长：%.2f秒\n", targetDuration)

	// 循环视频直至达到目标时长
	video1Looped := filepath.Join(tmpDir, "video1_loop.mp4")
	video2Looped := filepath.Join(tmpDir, "video2_loop.mp4")

	if duration1 < targetDuration {
		fmt.Println("正在循环处理视频1...")
		if err := loopVideo(video1NoAudio, video1Looped, targetDuration); err != nil {
			log.Fatalf("循环处理视频1失败：%v", err)
		}
	} else {
		video1Looped = video1NoAudio
	}

	if duration2 < targetDuration {
		fmt.Println("正在循环处理视频2...")
		if err := loopVideo(video2NoAudio, video2Looped, targetDuration); err != nil {
			log.Fatalf("循环处理视频2失败：%v", err)
		}
	} else {
		video2Looped = video2NoAudio
	}

	// 横向拼接视频
	concatOutput := filepath.Join(tmpDir, "concat.mp4")

	fmt.Println("正在横向拼接视频...")
	if err := concatVideos(video1Looped, video2Looped, concatOutput); err != nil {
		log.Fatalf("视频拼接失败：%v", err)
	}

	// 添加背景音乐或输出无声视频
	if _, err := os.Stat(audioPath); os.IsNotExist(err) {
		fmt.Println("音频文件不存在，输出无声视频...")
		// 无音频时直接将拼接后的视频作为最终输出
		if err := os.Rename(concatOutput, outputVideo); err != nil {
			log.Fatalf("重命名文件失败：%v", err)
		}
	} else {
		fmt.Println("正在添加背景音乐...")
		if err := addAudio(concatOutput, audioPath, outputVideo); err != nil {
			log.Fatalf("添加背景音乐失败：%v", err)
		}
	}

	// 清理临时文件
	fmt.Println("正在清理临时文件...")
	os.RemoveAll(tmpDir)

	fmt.Printf("处理完成，输出文件：%s\n", outputVideo)
}
