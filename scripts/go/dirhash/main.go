package main

import (
	"crypto/sha256"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
)

// ANSI color constants
const (
	colorGreen  = "\033[92m"
	colorRed    = "\033[91m"
	colorYellow = "\033[93m"
	colorBlue   = "\033[94m"
	colorReset  = "\033[0m"
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

// calculateFileHash computes the hash of a file using the specified algorithm
func calculateFileHash(filePath string) (string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return "", fmt.Errorf("error opening file: %v", err)
	}
	defer file.Close()

	hashFunc := sha256.New()
	if _, err := io.Copy(hashFunc, file); err != nil {
		return "", fmt.Errorf("error calculating hash: %v", err)
	}

	return fmt.Sprintf("%x", hashFunc.Sum(nil)), nil
}

// compareFiles compares two files using their hash values
func compareFiles(file1Path, file2Path string) (map[string]interface{}, error) {
	hash1, err := calculateFileHash(file1Path)
	if err != nil {
		return nil, err
	}

	hash2, err := calculateFileHash(file2Path)
	if err != nil {
		return nil, err
	}

	return map[string]interface{}{
		"are_same":   hash1 == hash2,
		"file1_hash": hash1,
		"file2_hash": hash2,
	}, nil
}

// recursiveCompareDirectories recursively compares two directories
func recursiveCompareDirectories(dir1Path, dir2Path string) (*ComparisonResult, error) {
	result := &ComparisonResult{}

	// Read directory contents
	items1, err := os.ReadDir(dir1Path)
	if err != nil {
		return nil, fmt.Errorf("error reading directory %s: %v", dir1Path, err)
	}

	items2, err := os.ReadDir(dir2Path)
	if err != nil {
		return nil, fmt.Errorf("error reading directory %s: %v", dir2Path, err)
	}

	// Create maps for quick lookup
	map1 := make(map[string]os.DirEntry)
	map2 := make(map[string]os.DirEntry)

	for _, item := range items1 {
		map1[item.Name()] = item
	}
	for _, item := range items2 {
		map2[item.Name()] = item
	}

	// Find items unique to each directory
	for name, item1 := range map1 {
		if _, exists := map2[name]; !exists {
			if item1.IsDir() {
				result.OnlyInFirstSubdir = append(result.OnlyInFirstSubdir, name)
			} else {
				result.OnlyInFirstDir = append(result.OnlyInFirstDir, name)
			}
		}
	}

	for name, item2 := range map2 {
		if _, exists := map1[name]; !exists {
			if item2.IsDir() {
				result.OnlyInSecondSubdir = append(result.OnlyInSecondSubdir, name)
			} else {
				result.OnlyInSecondDir = append(result.OnlyInSecondDir, name)
			}
		}
	}

	// Compare common items
	for name, item1 := range map1 {
		if item2, exists := map2[name]; exists {
			path1 := filepath.Join(dir1Path, name)
			path2 := filepath.Join(dir2Path, name)

			if item1.IsDir() && item2.IsDir() {
				// Recursively compare subdirectories
				subResult, err := recursiveCompareDirectories(path1, path2)
				if err != nil {
					return nil, err
				}

				if len(subResult.DifferentFiles) == 0 &&
					len(subResult.OnlyInFirstDir) == 0 &&
					len(subResult.OnlyInSecondDir) == 0 {
					result.MatchingSubdirs = append(result.MatchingSubdirs, name)
				} else {
					result.DifferentSubdirs = append(result.DifferentSubdirs, name)
				}

				// Merge subresults with current results
				for _, f := range subResult.MatchingFiles {
					result.MatchingFiles = append(result.MatchingFiles, filepath.Join(name, f))
				}
				for _, f := range subResult.DifferentFiles {
					result.DifferentFiles = append(result.DifferentFiles, filepath.Join(name, f))
				}
				for _, f := range subResult.OnlyInFirstDir {
					result.OnlyInFirstDir = append(result.OnlyInFirstDir, filepath.Join(name, f))
				}
				for _, f := range subResult.OnlyInSecondDir {
					result.OnlyInSecondDir = append(result.OnlyInSecondDir, filepath.Join(name, f))
				}
			} else if !item1.IsDir() && !item2.IsDir() {
				// Compare files
				comparison, err := compareFiles(path1, path2)
				if err != nil {
					return nil, err
				}

				if comparison["are_same"].(bool) {
					result.MatchingFiles = append(result.MatchingFiles, name)
				} else {
					result.DifferentFiles = append(result.DifferentFiles, name)
				}
			}
		}
	}

	return result, nil
}

// formatComparisonResult formats and prints the comparison results
func formatComparisonResult(result *ComparisonResult) {
	// Print overview
	fmt.Printf("%s📊 目录比较概览 %s\n", colorBlue, colorReset)
	fmt.Printf("总计相同文件: %s%d%s\n", colorGreen, len(result.MatchingFiles), colorReset)
	fmt.Printf("总计不同文件: %s%d%s\n", colorRed, len(result.DifferentFiles), colorReset)
	fmt.Printf("仅在第一个目录的文件: %s%d%s\n", colorYellow, len(result.OnlyInFirstDir), colorReset)
	fmt.Printf("仅在第二个目录的文件: %s%d%s\n", colorYellow, len(result.OnlyInSecondDir), colorReset)

	// Print file comparison
	fmt.Printf("\n%s📁 文件比较结果 %s\n", colorBlue, colorReset)

	if len(result.MatchingFiles) > 0 {
		sort.Strings(result.MatchingFiles)
		fmt.Printf("%s✅ 相同文件 (%d): %s\n", colorGreen, len(result.MatchingFiles), colorReset)
		for _, file := range result.MatchingFiles {
			fmt.Printf("   %s●%s %s\n", colorGreen, colorReset, file)
		}
	}

	if len(result.DifferentFiles) > 0 {
		sort.Strings(result.DifferentFiles)
		fmt.Printf("\n%s❌ 不同文件 (%d): %s\n", colorRed, len(result.DifferentFiles), colorReset)
		for _, file := range result.DifferentFiles {
			fmt.Printf("   %s●%s %s\n", colorRed, colorReset, file)
		}
	}

	if len(result.OnlyInFirstDir) > 0 {
		sort.Strings(result.OnlyInFirstDir)
		fmt.Printf("\n%s🔹 仅在第一个目录中的文件 (%d): %s\n", colorYellow, len(result.OnlyInFirstDir), colorReset)
		for _, file := range result.OnlyInFirstDir {
			fmt.Printf("   %s●%s %s\n", colorYellow, colorReset, file)
		}
	}

	if len(result.OnlyInSecondDir) > 0 {
		sort.Strings(result.OnlyInSecondDir)
		fmt.Printf("\n%s🔹 仅在第二个目录中的文件 (%d): %s\n", colorYellow, len(result.OnlyInSecondDir), colorReset)
		for _, file := range result.OnlyInSecondDir {
			fmt.Printf("   %s●%s %s\n", colorYellow, colorReset, file)
		}
	}

	// Print subdirectory comparison
	fmt.Printf("\n%s📂 子目录比较结果 %s\n", colorBlue, colorReset)

	if len(result.MatchingSubdirs) > 0 {
		sort.Strings(result.MatchingSubdirs)
		fmt.Printf("%s✅ 相同子目录 (%d): %s\n", colorGreen, len(result.MatchingSubdirs), colorReset)
		for _, dir := range result.MatchingSubdirs {
			fmt.Printf("   %s●%s %s\n", colorGreen, colorReset, dir)
		}
	}

	if len(result.DifferentSubdirs) > 0 {
		sort.Strings(result.DifferentSubdirs)
		fmt.Printf("\n%s❌ 不同子目录 (%d): %s\n", colorRed, len(result.DifferentSubdirs), colorReset)
		for _, dir := range result.DifferentSubdirs {
			fmt.Printf("   %s●%s %s\n", colorRed, colorReset, dir)
		}
	}
}

// validatePaths checks if the provided paths exist and are of the same type
func validatePaths(path1, path2 string) (bool, bool, error) {
	info1, err := os.Stat(path1)
	if err != nil {
		return false, false, fmt.Errorf("error accessing path1: %v", err)
	}

	info2, err := os.Stat(path2)
	if err != nil {
		return false, false, fmt.Errorf("error accessing path2: %v", err)
	}

	isDir1 := info1.IsDir()
	isDir2 := info2.IsDir()

	if isDir1 != isDir2 {
		return false, false, fmt.Errorf("paths must be of the same type (both files or both directories)")
	}

	return isDir1, !isDir1, nil
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
		fmt.Println("正在比较文件...")
		result, err := compareFiles(path1, path2)
		if err != nil {
			fmt.Printf("Error comparing files: %v\n", err)
			os.Exit(1)
		}

		fmt.Printf("文件是否相同: %v\n", result["are_same"])
		fmt.Printf("文件1哈希值: %s\n", result["file1_hash"])
		fmt.Printf("文件2哈希值: %s\n", result["file2_hash"])
	} else if isDir {
		fmt.Println("正在递归比较目录...")
		result, err := recursiveCompareDirectories(path1, path2)
		if err != nil {
			fmt.Printf("Error comparing directories: %v\n", err)
			os.Exit(1)
		}

		formatComparisonResult(result)
	}
}
