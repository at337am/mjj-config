package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"
)

type FileInfo struct {
	Path    string
	ModTime time.Time
	Name    string
	Ext     string
}

func main() {
	// 定义命令行参数
	dirPath := flag.String("d", "", "要处理的目录路径")
	fileExt := flag.String("e", "", "要处理的文件格式 (例如: .jpg, .txt)")

	// 解析命令行参数
	flag.Parse()

	// 检查必要参数
	if *dirPath == "" {
		fmt.Println("错误: 必须指定目录路径，使用 -d 参数")
		fmt.Println("使用方法: tmrn -d <目录路径> [-e <文件格式>]")
		return
	}

	// 确保文件格式以点号开头
	if *fileExt != "" && !strings.HasPrefix(*fileExt, ".") {
		*fileExt = "." + *fileExt
	}

	// 获取目录信息 - 使用现代 API
	entries, err := os.ReadDir(*dirPath)
	if err != nil {
		fmt.Printf("读取目录失败: %v\n", err)
		return
	}

	// 准备文件信息列表，只包含常规文件且符合指定格式
	var files []FileInfo
	for _, entry := range entries {
		// 只处理文件，跳过目录
		if entry.IsDir() {
			continue
		}

		name := entry.Name()
		ext := filepath.Ext(name)

		// 如果指定了文件格式，则只处理匹配的文件
		if *fileExt != "" && !strings.EqualFold(ext, *fileExt) {
			continue
		}

		// 获取文件信息以访问修改时间
		filePath := filepath.Join(*dirPath, name)
		info, err := entry.Info()
		if err != nil {
			fmt.Printf("获取文件信息失败 %s: %v\n", filePath, err)
			continue
		}

		baseName := strings.TrimSuffix(name, ext)

		files = append(files, FileInfo{
			Path:    filePath,
			ModTime: info.ModTime(),
			Name:    baseName,
			Ext:     ext,
		})
	}

	// 检查是否有匹配的文件
	if len(files) == 0 {
		fmt.Println("没有找到匹配的文件")
		return
	}

	// 按照修改时间从早到晚排序
	sort.Slice(files, func(i, j int) bool {
		return files[i].ModTime.Before(files[j].ModTime)
	})

	// 批量重命名文件
	for i, file := range files {
		// 生成新文件名: 序号_YYMMDD_HHMMSS.原扩展名
		newName := fmt.Sprintf("%02d_%s%s",
			i+1,
			file.ModTime.Format("060102_150405"),
			file.Ext)

		newPath := filepath.Join(*dirPath, newName)

		// 执行重命名
		err := os.Rename(file.Path, newPath)
		if err != nil {
			fmt.Printf("重命名文件 %s 失败: %v\n", file.Path, err)
		} else {
			fmt.Printf("重命名: %s -> %s\n", file.Path, newPath)
		}
	}

	fmt.Printf("完成！共重命名 %d 个文件\n", len(files))
}
