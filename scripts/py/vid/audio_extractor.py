import subprocess

def extract_audio(video_path, audio_path):
    command = [
        "ffmpeg",
        "-i", video_path,  # 输入视频文件
        "-q:a", "0",  # 保持最高音质
        "-map", "a",  # 只提取音频
        audio_path  # 输出音频文件
    ]
    
    try:
        subprocess.run(command, check=True)
        print(f"音频已成功提取到 {audio_path}")
    except subprocess.CalledProcessError as e:
        print(f"提取音频失败: {e}")

# 示例调用
extract_audio("02.mp4", "output.mp3")
