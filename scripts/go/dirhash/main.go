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

// ComparisonResult 存储目录比较的结果
type ComparisonResult struct {
	MatchingFiles      []string // 相同的文件列表
	DifferentFiles     []string // 不同的文件列表
	OnlyInFirstDir     []string // 仅在第一个目录中存在的文件列表
	OnlyInSecondDir    []string // 仅在第二个目录中存在的文件列表
	MatchingSubdirs    []string // 相同的子目录列表
	DifferentSubdirs   []string // 不同的子目录列表
	OnlyInFirstSubdir  []string // 仅在第一个目录中存在的子目录列表
	OnlyInSecondSubdir []string // 仅在第二个目录中存在的子目录列表
	Dir1FileCount      int      // 第一个目录的文件总数
	Dir2FileCount      int      // 第二个目录的文件总数
}

// calculateFileHash 计算文件的哈希值
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

// compareFiles 比较两个文件的内容是否相同
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

// countFilesInDirectory 递归统计目录中的文件数量
func countFilesInDirectory(dirPath string) (int, error) {
	count := 0
	err := filepath.Walk(dirPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			count++
		}
		return nil
	})
	if err != nil {
		return 0, fmt.Errorf("统计目录 %s 文件数量出错: %v", dirPath, err)
	}
	return count, nil
}

// recursiveCompareDirectories 递归比较两个目录
func recursiveCompareDirectories(dir1Path, dir2Path string) (*ComparisonResult, error) {
	result := &ComparisonResult{}

	items1, err := os.ReadDir(dir1Path)
	if err != nil {
		return nil, fmt.Errorf("读取目录 %s 出错: %v", dir1Path, err)
	}
	items2, err := os.ReadDir(dir2Path)
	if err != nil {
		return nil, fmt.Errorf("读取目录 %s 出错: %v", dir2Path, err)
	}

	// 统计两个目录中的文件数量
	fileCount1, err := countFilesInDirectory(dir1Path)
	if err != nil {
		return nil, err
	}
	fileCount2, err := countFilesInDirectory(dir2Path)
	if err != nil {
		return nil, err
	}
	result.Dir1FileCount = fileCount1
	result.Dir2FileCount = fileCount2

	map1 := make(map[string]os.DirEntry)
	map2 := make(map[string]os.DirEntry)
	for _, item := range items1 {
		map1[item.Name()] = item
	}
	for _, item := range items2 {
		map2[item.Name()] = item
	}

	findUniqueItems(map1, map2, &result.OnlyInFirstDir, &result.OnlyInFirstSubdir)
	findUniqueItems(map2, map1, &result.OnlyInSecondDir, &result.OnlyInSecondSubdir)

	for name, item1 := range map1 {
		if item2, exists := map2[name]; exists {
			path1 := filepath.Join(dir1Path, name)
			path2 := filepath.Join(dir2Path, name)

			if item1.IsDir() && item2.IsDir() {
				subResult, err := recursiveCompareDirectories(path1, path2)
				if err != nil {
					return nil, err
				}
				mergeSubdirectoryResults(result, name, subResult)
			} else if !item1.IsDir() && !item2.IsDir() {
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

	// 处理仅在第一个目录中存在的子目录中的文件
	for _, subdirName := range result.OnlyInFirstSubdir {
		subdirPath := filepath.Join(dir1Path, subdirName)
		filesInSubdir, err := collectFilesInSubdir(subdirPath)
		if err != nil {
			return nil, err
		}
		mergeFileList(&result.OnlyInFirstDir, subdirName, filesInSubdir)
	}

	// 处理仅在第二个目录中存在的子目录中的文件 (虽然需求只提了第一个目录，但为了完整性，也处理第二个)
	for _, subdirName := range result.OnlyInSecondSubdir {
		subdirPath := filepath.Join(dir2Path, subdirName)
		filesInSubdir, err := collectFilesInSubdir(subdirPath)
		if err != nil {
			return nil, err
		}
		mergeFileList(&result.OnlyInSecondDir, subdirName, filesInSubdir)
	}


	return result, nil
}

// collectFilesInSubdir 递归收集子目录中的所有文件
func collectFilesInSubdir(dirPath string) ([]string, error) {
	var files []string
	err := filepath.Walk(dirPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			relPath, err := filepath.Rel(dirPath, path)
			if err != nil {
				return err
			}
			files = append(files, relPath)
		}
		return nil
	})
	if err != nil {
		return nil, fmt.Errorf("遍历目录 %s 出错: %v", dirPath, err)
	}
	return files, nil
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
	if isSubdirectoryIdentical(subResult) {
		result.MatchingSubdirs = append(result.MatchingSubdirs, subdirName)
	} else {
		result.DifferentSubdirs = append(result.DifferentSubdirs, subdirName)
	}

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

// formatFileComparisonResult 格式化输出文件比较结果
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

// formatComparisonResult 格式化输出目录比较的总体结果
func formatComparisonResult(result *ComparisonResult) {
	green := color.New(color.FgGreen).PrintfFunc()

	if areDirectoriesIdentical(result) {
		green("🎉 两个目录内容完全一致 🎉\n")
		return
	}

	blue := color.New(color.FgBlue).PrintfFunc()
	red := color.New(color.FgRed).PrintfFunc()

	blue("📁 目录 '%s' 文件总数: %d\n", flag.Args()[0], result.Dir1FileCount)
	blue("📁 目录 '%s' 文件总数: %d\n", flag.Args()[1], result.Dir2FileCount)

	fmt.Println()

	green("总计相同文件: ")
	fmt.Println(len(result.MatchingFiles))

	totalDifferentFiles := len(result.DifferentFiles) + len(result.OnlyInFirstDir) + len(result.OnlyInSecondDir)
	red("总计差异文件: ")
	fmt.Println(totalDifferentFiles)

	fmt.Println()

	blue("📄 有差异的文件 ↓ \n")

	printComparisonList("❌ 不同文件", result.DifferentFiles, color.FgRed)

	printComparisonList(fmt.Sprintf("🔹 仅在目录 '%s' 中的文件", flag.Args()[0]), result.OnlyInFirstDir, color.FgYellow)
	printComparisonList(fmt.Sprintf("🔹 仅在目录 '%s' 中的文件", flag.Args()[1]), result.OnlyInSecondDir, color.FgYellow)
}

// areDirectoriesIdentical 检查目录比较结果是否表示目录完全相同
func areDirectoriesIdentical(result *ComparisonResult) bool {
	return len(result.DifferentFiles) == 0 &&
		len(result.OnlyInFirstDir) == 0 &&
		len(result.OnlyInSecondDir) == 0 &&
		len(result.DifferentSubdirs) == 0 &&
		len(result.OnlyInFirstSubdir) == 0 &&
		len(result.OnlyInSecondSubdir) == 0
}

// printComparisonList 统一格式化打印比较结果列表
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

// validatePaths 检查提供的路径是否存在，并判断是否为相同类型
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

	flag.Parse()
	args := flag.Args()

	if len(args) != 2 {
		fmt.Println("使用方法: ")
		fmt.Println("  dirhash <路径1> <路径2>")
		os.Exit(1)
	}

	path1, path2 := args[0], args[1]

	// 验证路径为目录还是文件
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