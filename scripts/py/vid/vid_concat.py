import subprocess
import os

def remove_audio(input_video, output_video):
    """去除视频音轨"""
    command = [
        "ffmpeg", "-i", input_video, "-c", "copy", "-an", output_video
    ]
    subprocess.run(command, check=True)

def get_video_duration(video_path):
    """获取视频时长（秒）"""
    command = [
        "ffprobe", "-i", video_path, "-show_entries", "format=duration", "-v", "quiet", "-of", "csv=p=0"
    ]
    result = subprocess.run(command, capture_output=True, text=True, check=True)
    return float(result.stdout.strip())

def loop_video(input_video, output_video, duration):
    """循环短视频直到达到指定时长"""
    command = [
        "ffmpeg", "-stream_loop", "-1", "-i", input_video, "-t", str(duration), "-c", "copy", output_video
    ]
    subprocess.run(command, check=True)

def concat_videos(video1, video2, output_video):
    """横向拼接两个视频，并统一高度"""
    command = [
        "ffmpeg", "-i", video1, "-i", video2,
        "-filter_complex",
        "[0:v]scale=-2:1080[v0];[1:v]scale=-1:1080[v1];[v0][v1]hstack=inputs=2[out]",
        "-map", "[out]", "-c:v", "libx264", "-crf", "23", "-preset", "fast", output_video
    ]
    subprocess.run(command, check=True)

def add_audio(video, audio, output_video):
    """给拼接后的视频添加音轨"""
    command = [
        "ffmpeg", "-i", video, "-i", audio, "-c:v", "copy", "-c:a", "aac", "-strict", "experimental", output_video
    ]
    subprocess.run(command, check=True)

if __name__ == "__main__":
    # 输入文件
    video1 = "01.mp4"  # 第一个视频
    video2 = "02.mp4"  # 第二个视频
    audio = "output.mp3"  # 背景音乐
    output_video = "output.mp4"  # 最终输出文件

    # 去除音轨
    video1_no_audio = "temp1.mp4"
    video2_no_audio = "temp2.mp4"
    remove_audio(video1, video1_no_audio)
    remove_audio(video2, video2_no_audio)

    # 获取视频和音频时长
    duration1 = get_video_duration(video1_no_audio)
    duration2 = get_video_duration(video2_no_audio)
    audio_duration = get_video_duration(audio)
    
    # 计算目标时长
    max_video_duration = max(duration1, duration2)
    target_duration = max(max_video_duration, audio_duration)

    # 使视频循环匹配目标时长
    video1_looped = "looped1.mp4"
    video2_looped = "looped2.mp4"
    
    if duration1 < target_duration:
        loop_video(video1_no_audio, video1_looped, target_duration)
    else:
        video1_looped = video1_no_audio
    
    if duration2 < target_duration:
        loop_video(video2_no_audio, video2_looped, target_duration)
    else:
        video2_looped = video2_no_audio

    # 横向拼接视频
    concat_output = "concat.mp4"
    concat_videos(video1_looped, video2_looped, concat_output)

    # 添加背景音乐
    add_audio(concat_output, audio, output_video)

    # 清理临时文件
    os.remove(video1_no_audio)
    os.remove(video2_no_audio)
    if video1_looped != video1_no_audio:
        os.remove(video1_looped)
    if video2_looped != video2_no_audio:
        os.remove(video2_looped)
    os.remove(concat_output)

    print(f"处理完成，输出文件：{output_video}")
