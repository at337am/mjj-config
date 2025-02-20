import argparse
import subprocess
import os

def convert_mov_to_mp4(input_file):
    """将 .mov 文件转换为 .mp4"""
    if not os.path.isfile(input_file):
        print(f"错误: 文件 '{input_file}' 不存在。")
        return

    base_name, _ = os.path.splitext(input_file)
    output_file = f"{base_name}.mp4"

    command = [
        "ffmpeg",
        "-i", input_file,
        "-c", "copy",
        "-movflags", "+faststart",
        output_file
    ]

    try:
        subprocess.run(command, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"✅ 转换成功: {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"❌ 转换失败: {input_file}, 错误: {e}")

def process_directory(directory):
    """遍历目录及其子目录，转换所有 .mov 文件"""
    if not os.path.isdir(directory):
        print(f"错误: 目录 '{directory}' 不存在。")
        return

    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(".mov"):
                convert_mov_to_mp4(os.path.join(root, file))

def main():
    parser = argparse.ArgumentParser(description="MOV 转 MP4 转换工具")
    parser.add_argument("path", help="MOV 文件或包含 MOV 文件的目录路径")
    args = parser.parse_args()

    if os.path.isdir(args.path):
        process_directory(args.path)
    elif os.path.isfile(args.path):
        convert_mov_to_mp4(args.path)
    else:
        print(f"错误: 路径 '{args.path}' 无效，请输入正确的文件或目录路径。")

if __name__ == "__main__":
    main()

# 使用示例：
# python mov2mp4.py ./
