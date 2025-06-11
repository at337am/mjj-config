import os
import argparse

def split_file(file_path, parts=2):
    """
    将文件拆分为指定数量的部分
    
    :param file_path: 要拆分的文件路径
    :param parts: 要拆分的份数，默认为2
    """
    # 获取文件基本信息
    file_name = os.path.basename(file_path)
    file_dir = os.path.dirname(file_path)
    file_size = os.path.getsize(file_path)
    
    # 计算每个部分的大小
    part_size = file_size // parts
    
    # 打开源文件
    with open(file_path, 'rb') as source_file:
        for i in range(parts):
            # 计算当前部分的文件名
            part_file_name = f"{file_name}.part{i+1}"
            part_path = os.path.join(file_dir, part_file_name)
            
            # 处理最后一个部分可能需要额外数据的情况
            if i == parts - 1:
                remaining_data = source_file.read()
            else:
                remaining_data = source_file.read(part_size)
            
            # 写入分割后的文件
            with open(part_path, 'wb') as part_file:
                part_file.write(remaining_data)
            
            print(f"创建文件: {part_file_name}")

def combine_file(file_prefix, parts=2):
    """
    将分割的文件合并为一个完整的文件
    
    :param file_prefix: 文件前缀（通常是原始文件名）
    :param parts: 要合并的文件份数，默认为2
    """
    # 获取文件目录
    file_dir = os.getcwd()
    
    # 输出文件名
    output_file_name = file_prefix.replace('.part1', '')
    output_path = os.path.join(file_dir, output_file_name)
    
    # 打开输出文件
    with open(output_path, 'wb') as output_file:
        # 按顺序读取并写入每个分割文件
        for i in range(parts):
            part_file_name = f"{file_prefix}.part{i+1}"
            part_path = os.path.join(file_dir, part_file_name)
            
            with open(part_path, 'rb') as part_file:
                output_file.write(part_file.read())
            
            print(f"已合并文件: {part_file_name}")
    
    print(f"合并完成，输出文件: {output_file_name}")

def main():
    # 创建参数解析器
    parser = argparse.ArgumentParser(description='文件拆分和合并工具')
    
    # 添加互斥参数组，确保只能选择拆分或合并中的一个
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-s', '--split', help='拆分文件路径')
    group.add_argument('-c', '--combine', help='合并文件前缀')
    
    # 添加部分数量参数
    parser.add_argument('-p', '--parts', type=int, default=2, 
                        help='拆分或合并的文件份数（默认为2）')
    
    # 解析参数
    args = parser.parse_args()
    
    # 根据参数执行拆分或合并操作
    if args.split:
        split_file(args.split, args.parts)
    elif args.combine:
        combine_file(args.combine, args.parts)

if __name__ == '__main__':
    main()

# 使用示例：
# 拆分文件：python splitter.py -s file.7z
# 合并文件：python splitter.py -c file.7z -p 2
