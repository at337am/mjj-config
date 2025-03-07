import os
import magic  # 需要安装 python-magic 库，可以使用 pip install python-magic-bin (Windows) 或 pip install python-magic (Linux/macOS)
import argparse

def verify_media_file_type_carefully(filepath):
    """
    仔细验证文件是否为 MP4 或 MOV 视频文件。

    此方法使用多种方式进行验证，以确保准确性：
    1. 检查文件扩展名（快速初步判断）。
    2. 使用 magic number (文件幻数) 检测文件类型（更可靠）。
    3. （可选）可以加入更深度的文件格式分析，但此处为了简洁和常用场景，只做到 magic number 检测。

    Args:
        filepath (str): 文件路径。

    Returns:
        str: 如果是 MP4 文件，返回 "mp4"。
             如果是 MOV 文件，返回 "mov"。
             如果既不是 MP4 也不是 MOV，返回 "unknown"。
             如果发生错误（例如文件不存在），返回 "error"。
    """

    if not os.path.exists(filepath):
        return "error: 文件不存在"

    # 1. 快速检查文件扩展名 (作为初步判断，但不可靠)
    filename, file_extension = os.path.splitext(filepath)
    file_extension = file_extension.lower()
    if file_extension in ['.mp4', '.mov']:
        print(f"初步判断：文件扩展名是 {file_extension}，可能为 {file_extension[1:].upper()} 文件。")
    else:
        print(f"初步判断：文件扩展名是 {file_extension}，不是 .mp4 或 .mov，可能不是视频文件。")


    # 2. 使用 magic number 进行更可靠的类型检测
    try:
        mime = magic.from_file(filepath, mime=True)  # 获取 MIME 类型
        print(f"Magic number 检测到的 MIME 类型: {mime}")

        if mime == 'video/mp4':
            return "mp4"
        elif mime == 'video/quicktime': # QuickTime 是 MOV 文件的 MIME 类型
            return "mov"
        else:
            return "unknown"

    except Exception as e:
        print(f"Magic number 检测出错: {e}")
        return "error: magic number 检测失败"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="验证文件是否为 MP4 或 MOV 文件.")
    parser.add_argument("filepath", help="要验证的文件路径")
    args = parser.parse_args()

    filepath = args.filepath

    result = verify_media_file_type_carefully(filepath)

    if result == "mp4":
        print(f"文件 '{filepath}' 经验证是 MP4 文件。")
    elif result == "mov":
        print(f"文件 '{filepath}' 经验证是 MOV 文件。")
    elif result == "unknown":
        print(f"文件 '{filepath}' 不是 MP4 或 MOV 文件，或者无法确定类型。")
    elif result.startswith("error"):
        print(f"验证过程中出现错误: {result[7:]}") # 去掉 "error: " 前缀