import cv2
import os
import sys
from tqdm import tqdm

def validate_video(video_path):
    """
    验证视频文件是否存在且可以被正确读取
    返回视频的基本信息（帧率、总帧数、分辨率）
    """
    if not os.path.exists(video_path):
        raise FileNotFoundError(f"错误：视频文件 '{video_path}' 不存在")
    
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise ValueError(f"错误：无法打开视频文件 '{video_path}'")
    
    # 获取视频信息
    fps = int(cap.get(cv2.CAP_PROP_FPS))
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    
    cap.release()
    return fps, total_frames, (width, height)

def extract_frames(video_path, output_dir):
    """
    将视频按帧提取为图片
    """
    # 创建输出目录
    os.makedirs(output_dir, exist_ok=True)
    
    try:
        # 验证视频并获取信息
        fps, total_frames, (width, height) = validate_video(video_path)
        print(f"视频信息：")
        print(f"- 帧率：{fps} FPS")
        print(f"- 总帧数：{total_frames}")
        print(f"- 分辨率：{width}x{height}")
        
        # 打开视频
        cap = cv2.VideoCapture(video_path)
        
        # 使用tqdm创建进度条
        with tqdm(total=total_frames, desc="提取帧") as pbar:
            frame_count = 0
            while True:
                ret, frame = cap.read()
                if not ret:
                    break
                
                # 保存帧为图片
                frame_path = os.path.join(output_dir, f"frame_{frame_count:06d}.jpg")
                cv2.imwrite(frame_path, frame)
                
                frame_count += 1
                pbar.update(1)
        
        print(f"\n成功提取 {frame_count} 帧图片到 '{output_dir}' 目录")
        
    except Exception as e:
        print(f"处理过程中出现错误：{str(e)}")
        return False
    finally:
        if 'cap' in locals():
            cap.release()
    
    return True

def main():
    # 检查命令行参数
    if len(sys.argv) != 2:
        print("使用方法：python script.py <视频文件路径>")
        return
    
    video_path = sys.argv[1]
    output_dir = os.path.join(os.path.dirname(video_path), "output_frames")
    
    # 提取帧
    success = extract_frames(video_path, output_dir)
    if not success:
        sys.exit(1)

if __name__ == "__main__":
    main()

# 使用示例：
# python vid2frames.py 1.mp4
