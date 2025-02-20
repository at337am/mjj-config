import os
import argparse
import re

def rename_mp4_extension(directory):
    """将目录及子目录下所有 .MP4 文件扩展名改为 .mp4"""
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".MP4"):  # 仅匹配大写 .MP4
                old_path = os.path.join(root, file)
                new_path = os.path.join(root, file[:-4] + ".mp4")  # 扩展名改为 .mp4
                os.rename(old_path, new_path)
                print(f"✅ 扩展名转换: {old_path} → {new_path}")

def delete_mov_files(directory):
    """删除目录及子目录下所有 .mov 或 .MOV 文件"""
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(".mov"):  # 统一匹配 .mov/.MOV
                file_path = os.path.join(root, file)
                os.remove(file_path)
                print(f"🆑 删除: {file_path}")

def rename_single_digit_mp4_files(directory):
    """将单个数字的 mp4 文件名前加 0，例如 1.mp4 → 01.mp4"""
    for root, _, files in os.walk(directory):
        for file in files:
            if re.fullmatch(r"\d\.mp4", file):  # 匹配 1.mp4 - 9.mp4
                old_path = os.path.join(root, file)
                new_path = os.path.join(root, f"0{file}")  # 在数字前补 0
                os.rename(old_path, new_path)
                print(f"🔄 数字重命名: {old_path} → {new_path}")

def process_directory(directory):
    """执行所有处理步骤"""
    if not os.path.isdir(directory):
        print(f"❌ 错误: 目录 '{directory}' 不存在。")
        return
    
    rename_mp4_extension(directory)  # 扩展名转换
    delete_mov_files(directory)  # 删除 MOV 文件
    rename_single_digit_mp4_files(directory)  # 处理单个数字文件名
    print("✅ 处理完成！")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="MP4 扩展名转换 & MOV 文件删除工具")
    parser.add_argument("directory", help="需要处理的目录路径")
    args = parser.parse_args()

    process_directory(args.directory)

# 使用示例：
# python format_mp4.py ./
