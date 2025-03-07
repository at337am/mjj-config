package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// convertMovToMP4 将 .mov 文件转换为 .mp4，并处理可能存在的重名文件
func convertMovToMP4(inputFile string) {
	// 检查输入文件是否存在
	if _, err := os.Stat(inputFile); os.IsNotExist(err) {
		fmt.Printf("错误: 文件 '%s' 不存在。\n", inputFile)
		return
	}

	// 获取文件的基础名称（去掉扩展名）
	baseName := strings.TrimSuffix(inputFile, filepath.Ext(inputFile))

	// 生成输出文件名，避免重名冲突
	outputFile := fmt.Sprintf("%s.mp4", baseName)
	counter := 1
	for {
		if _, err := os.Stat(outputFile); os.IsNotExist(err) {
			break // 如果文件不存在，则使用当前文件名
		}
		// 如果文件已存在，则在文件名后添加编号
		outputFile = fmt.Sprintf("%s_%d.mp4", baseName, counter)
		counter++
	}

	// 定义 ffmpeg 命令，用于无损转换 MOV 为 MP4
	cmd := exec.Command(
		"ffmpeg",
		"-i", inputFile,     // 输入文件
		"-c", "copy",        // 直接复制流，不重新编码
		"-movflags", "+faststart", // 优化 MP4 文件的启动速度
		outputFile,          // 输出文件
	)

	if err := cmd.Run(); err != nil {
		fmt.Printf("❌ 转换失败: %s, 错误: %v\n", inputFile, err)
		return
	}

	fmt.Printf("✅ 转换成功: %s (输出文件: %s)\n", inputFile, outputFile)
}

// processDirectory 遍历指定目录及其子目录，自动转换所有 .mov 文件
func processDirectory(directory string) {
	if info, err := os.Stat(directory); os.IsNotExist(err) || !info.IsDir() {
		fmt.Printf("错误: 目录 '%s' 不存在。\n", directory)
		return
	}

	err := filepath.Walk(directory, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		// 检查文件是否为 .mov 格式（忽略大小写）
		if !info.IsDir() && strings.ToLower(filepath.Ext(path)) == ".mov" {
			convertMovToMP4(path)
		}
		return nil
	})

	if err != nil {
		fmt.Printf("遍历目录错误: %v\n", err)
	}

	fmt.Printf("\n--- mov2mp4 执行完成 ---\n")
}

func main() {
	flag.Parse()

	if flag.NArg() == 0 {
		fmt.Println("请提供 MOV 文件或包含 MOV 文件的目录路径")
		return
	}

	path := flag.Arg(0)

	// 获取路径信息，判断是文件还是目录
	info, err := os.Stat(path)
	if os.IsNotExist(err) {
		fmt.Printf("错误: 路径 '%s' 无效，请输入正确的文件或目录路径。\n", path)
		return
	}

	// 根据路径类型选择处理方式
	if info.IsDir() {
		processDirectory(path)
	} else {
		convertMovToMP4(path)
	}
}
