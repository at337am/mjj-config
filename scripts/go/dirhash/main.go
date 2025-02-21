package main

import (
	"crypto/sha256"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"

	"github.com/fatih/color"
)

// ComparisonResult stores the results of directory comparison
type ComparisonResult struct {
	MatchingFiles      []string
	DifferentFiles     []string
	OnlyInFirstDir     []string
	OnlyInSecondDir    []string
	MatchingSubdirs    []string
	DifferentSubdirs   []string
	OnlyInFirstSubdir  []string
	OnlyInSecondSubdir []string
}

// calculateFileHash 计算文件的哈希值，使用指定的算法
func calculateFileHash(filePath string) (string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return "", fmt.Errorf("打开文件出错: %v", err)
	}
	defer file.Close()

	hashFunc := sha256.New()
	if _, err := io.Copy(hashFunc, file); err != nil {
		return "", fmt.Errorf("计算哈希值出错: %v", err)
	}

	return fmt.Sprintf("%x", hashFunc.Sum(nil)), nil
}

func compareFiles(file1Path, file2Path string) (areSame bool, hash1 string, hash2 string, err error) {
    hash1, err = calculateFileHash(file1Path)
    if err != nil {
        return false, "", "", err
    }

    hash2, err = calculateFileHash(file2Path)
    if err != nil {
        return false, "", "", err
    }

    areSame = (hash1 == hash2)
    return areSame, hash1, hash2, nil
}

// recursiveCompareDirectories 递归比较两个目录
func recursiveCompareDirectories(dir1Path, dir2Path string) (*ComparisonResult, error) {
	result := &ComparisonResult{}

	// 读取目录内容
	items1, err := os.ReadDir(dir1Path)
	if err != nil {
		return nil, fmt.Errorf("读取目录 %s 出错: %v", dir1Path, err)
	}
	items2, err := os.ReadDir(dir2Path)
	if err != nil {
		return nil, fmt.Errorf("读取目录 %s 出错: %v", dir2Path, err)
	}

	// 创建映射以便快速查找
	map1 := make(map[string]os.DirEntry)
	map2 := make(map[string]os.DirEntry)
	for _, item := range items1 {
		map1[item.Name()] = item
	}
	for _, item := range items2 {
		map2[item.Name()] = item
	}

	// 查找每个目录独有的项目
	findUniqueItems(map1, map2, &result.OnlyInFirstDir, &result.OnlyInFirstSubdir)
	findUniqueItems(map2, map1, &result.OnlyInSecondDir, &result.OnlyInSecondSubdir)

	// 比较共同项目
	for name, item1 := range map1 {
		if item2, exists := map2[name]; exists {
			path1 := filepath.Join(dir1Path, name)
			path2 := filepath.Join(dir2Path, name)

			if item1.IsDir() && item2.IsDir() {
				// 递归比较子目录
				subResult, err := recursiveCompareDirectories(path1, path2)
				if err != nil {
					return nil, err
				}
				mergeSubdirectoryResults(result, name, subResult)
			} else if !item1.IsDir() && !item2.IsDir() {
				// 只关心文件是否相同
				same, _, _, err := compareFiles(path1, path2)
				if err != nil {
					return nil, err
				}
				if same {
					result.MatchingFiles = append(result.MatchingFiles, name)
				} else {
					result.DifferentFiles = append(result.DifferentFiles, name)
				}
			}
		}
	}

	return result, nil
}

// findUniqueItems 查找一个映射中相对于另一个映射的独有项目
func findUniqueItems(source, target map[string]os.DirEntry, uniqueFiles, uniqueSubdirs *[]string) {
	for name, item := range source {
		if _, exists := target[name]; !exists {
			if item.IsDir() {
				*uniqueSubdirs = append(*uniqueSubdirs, name)
			} else {
				*uniqueFiles = append(*uniqueFiles, name)
			}
		}
	}
}

// mergeSubdirectoryResults 将子目录的比较结果合并到父结果中
func mergeSubdirectoryResults(result *ComparisonResult, subdirName string, subResult *ComparisonResult) {
	// 检查子目录是否完全相同
	if isSubdirectoryIdentical(subResult) {
		result.MatchingSubdirs = append(result.MatchingSubdirs, subdirName)
	} else {
		result.DifferentSubdirs = append(result.DifferentSubdirs, subdirName)
	}

	// 合并文件并添加适当的相对路径
	mergeFileList(&result.MatchingFiles, subdirName, subResult.MatchingFiles)
	mergeFileList(&result.DifferentFiles, subdirName, subResult.DifferentFiles)
	mergeFileList(&result.OnlyInFirstDir, subdirName, subResult.OnlyInFirstDir)
	mergeFileList(&result.OnlyInSecondDir, subdirName, subResult.OnlyInSecondDir)
}

// isSubdirectoryIdentical 检查子目录结果是否表示内容完全相同
func isSubdirectoryIdentical(subResult *ComparisonResult) bool {
	return len(subResult.DifferentFiles) == 0 &&
		len(subResult.OnlyInFirstDir) == 0 &&
		len(subResult.OnlyInSecondDir) == 0
}

// mergeFileList 将文件列表追加到目标切片并添加前缀路径
func mergeFileList(target *[]string, prefix string, files []string) {
	for _, f := range files {
		*target = append(*target, filepath.Join(prefix, f))
	}
}

func formatFileComparisonResult(same bool, hash1, hash2 string) {
	green := color.New(color.FgGreen)
	red := color.New(color.FgRed)

	if same {
		green.Println("✅ 文件相同:")
	} else {
		red.Println("❌ 文件不同: ")
	}

	fmt.Printf("    ● 文件1 哈希值: %s\n", hash1)
	fmt.Printf("    ● 文件2 哈希值: %s\n", hash2)
}

func formatComparisonResult(result *ComparisonResult) {
	blue := color.New(color.FgBlue).PrintfFunc()
	green := color.New(color.FgGreen).PrintfFunc()
	red := color.New(color.FgRed).PrintfFunc()
	yellow := color.New(color.FgYellow).PrintfFunc()

	blue("📊 目录比较概览 ↓ \n\n")
	green("总计相同文件: ")
	fmt.Println(len(result.MatchingFiles))
	red("总计不同文件: ")
	fmt.Println(len(result.DifferentFiles))
	yellow("仅在第一个目录的文件: ")
	fmt.Println(len(result.OnlyInFirstDir))
	yellow("仅在第二个目录的文件: ")
	fmt.Println(len(result.OnlyInSecondDir))

	fmt.Println()

	blue("📄 文件比较结果 ↓ \n")
	printComparisonList("✅ 相同文件", result.MatchingFiles, color.FgGreen)
	printComparisonList("❌ 不同文件", result.DifferentFiles, color.FgRed)
	printComparisonList("🔹 仅在第一个目录中的文件", result.OnlyInFirstDir, color.FgYellow)
	printComparisonList("🔹 仅在第二个目录中的文件", result.OnlyInSecondDir, color.FgYellow)

	fmt.Println()

	blue("📂 子目录比较结果 ↓ \n")
	printComparisonList("✅ 相同子目录", result.MatchingSubdirs, color.FgGreen)
	printComparisonList("❌ 不同子目录", result.DifferentSubdirs, color.FgRed)
}

// printComparisonList 统一格式化打印比较结果
func printComparisonList(title string, items []string, colorAttribute color.Attribute) {
	if len(items) == 0 {
		return
	}
	sort.Strings(items)
	c := color.New(colorAttribute)
	fmt.Println()
	c.Printf("%s (%d):\n", title, len(items))
	for _, item := range items {
		fmt.Printf("    ● %s\n", item)
	}
}

// validatePaths 检查提供的路径是否存在，并判断是否为相同类型（文件或目录）
func validatePaths(path1, path2 string) (isDir, isFile bool, err error) {
	info1, err := getFileInfo(path1)
	if err != nil {
		return false, false, fmt.Errorf("无法访问路径 %q: %v", path1, err)
	}

	info2, err := getFileInfo(path2)
	if err != nil {
		return false, false, fmt.Errorf("无法访问路径 %q: %v", path2, err)
	}

	isDir1, isDir2 := info1.IsDir(), info2.IsDir()
	if isDir1 != isDir2 {
		return false, false, fmt.Errorf("路径类型不匹配: %q 和 %q 必须都是文件或目录", path1, path2)
	}

	return isDir1, !isDir1, nil
}

// getFileInfo 获取文件信息
func getFileInfo(path string) (os.FileInfo, error) {
	info, err := os.Stat(path)
	if err != nil {
		return nil, err
	}
	return info, nil
}

func main() {
	// Parse command line arguments
	flag.Parse()
	args := flag.Args()

	if len(args) != 2 {
		fmt.Println("Usage: program <path1> <path2>")
		os.Exit(1)
	}

	path1, path2 := args[0], args[1]

	// Validate paths
	isDir, isFile, err := validatePaths(path1, path2)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}

	if isFile {
		fmt.Print("\n⌛ 正在比较文件...\n\n")
		same, hash1, hash2, err := compareFiles(path1, path2)
		if err != nil {
			fmt.Printf("Error comparing files: %v\n", err)
			os.Exit(1)
		}

		formatFileComparisonResult(same, hash1, hash2)
	} else if isDir {
		fmt.Print("\n⌛ 正在递归比较目录...\n\n")
		result, err := recursiveCompareDirectories(path1, path2)
		if err != nil {
			fmt.Printf("Error comparing directories: %v\n", err)
			os.Exit(1)
		}

		formatComparisonResult(result)
	}
}