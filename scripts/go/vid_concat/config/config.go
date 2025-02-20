package config

import (
	"log"

	"github.com/spf13/viper"
)

// Config 结构体映射 YAML 配置
type Config struct {
	Input struct {
		Video1FilePath string `mapstructure:"video1FilePath"`
		Video2FilePath string `mapstructure:"video2FilePath"`
		AudioDirPath string `mapstructure:"audioDirPath"`
	} `mapstructure:"input"`

	Result struct {
		OutputVideoFilePath string `mapstructure:"outputVideoFilePath"`
	} `mapstructure:"result"`
}

var AppConfig Config

// InitConfig 读取并解析 YAML 配置
func InitConfig() {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("config")

	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("❌ 读取配置文件失败: %v", err)
	}

	if err := viper.Unmarshal(&AppConfig); err != nil {
		log.Fatalf("❌ 解析配置失败: %v", err)
	}
}

// GetVideo1FilePath 获取视频1文件路径
func GetVideo1FilePath() string {
	return AppConfig.Input.Video1FilePath
}

// GetVideo2FilePath 获取视频2文件路径
func GetVideo2FilePath() string {
	return AppConfig.Input.Video2FilePath
}

// GetAudioDirPath 获取音频文件夹路径
func GetAudioDirPath() string {
	return AppConfig.Input.AudioDirPath
}

// GetOutputVideoFilePath 获取输出视频文件路径
func GetOutputVideoFilePath() string {
	return AppConfig.Result.OutputVideoFilePath
}
