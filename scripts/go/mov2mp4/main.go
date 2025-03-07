package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// convertMovToMP4 converts a .mov file to .mp4
func convertMovToMP4(inputFile string) {
	// Check if the input file exists
	if _, err := os.Stat(inputFile); os.IsNotExist(err) {
		fmt.Printf("错误: 文件 '%s' 不存在。\n", inputFile)
		return
	}

	// Get the base name and create the output file name
	baseName := strings.TrimSuffix(inputFile, filepath.Ext(inputFile))
	outputFile := fmt.Sprintf("%s.mp4", baseName)

	// Define the ffmpeg command
	cmd := exec.Command(
		"ffmpeg",
		"-i", inputFile,
		"-c", "copy",
		"-movflags", "+faststart",
		outputFile,
	)

	// Execute the command
	if err := cmd.Run(); err != nil {
		fmt.Printf("❌ 转换失败: %s, 错误: %v\n", inputFile, err)
		return
	}

	fmt.Printf("✅ 转换成功: %s\n", outputFile)
}

// processDirectory traverses the directory and its subdirectories to convert all .mov files
func processDirectory(directory string) {
	// Check if the directory exists
	if info, err := os.Stat(directory); os.IsNotExist(err) || !info.IsDir() {
		fmt.Printf("错误: 目录 '%s' 不存在。\n", directory)
		return
	}

	// Walk through the directory and its subdirectories
	err := filepath.Walk(directory, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
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
	// Parse command line arguments
	flag.Parse()
	
	// Check if path was provided
	if flag.NArg() == 0 {
		fmt.Println("请提供 MOV 文件或包含 MOV 文件的目录路径")
		return
	}
	
	path := flag.Arg(0)

	// Get file info
	info, err := os.Stat(path)
	if os.IsNotExist(err) {
		fmt.Printf("错误: 路径 '%s' 无效，请输入正确的文件或目录路径。\n", path)
		return
	}

	// Process based on whether path is a file or directory
	if info.IsDir() {
		processDirectory(path)
	} else {
		convertMovToMP4(path)
	}
}
