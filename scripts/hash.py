import os
import sys
import hashlib
import argparse

def calculate_file_hash(file_path, algorithm='sha256', chunk_size=8192):
    """
    计算文件的哈希值
    
    参数:
    file_path (str): 文件路径
    algorithm (str): 哈希算法名称 (默认为 'sha256')
    chunk_size (int): 读取文件的块大小 (默认 8192 字节)
    
    返回:
    str: 文件的哈希值（十六进制字符串）
    """
    # 选择哈希算法
    hash_func = hashlib.new(algorithm)
    
    try:
        # 以二进制读取模式打开文件
        with open(file_path, 'rb') as f:
            # 分块读取文件，避免一次性将大文件载入内存
            for chunk in iter(lambda: f.read(chunk_size), b''):
                hash_func.update(chunk)
        
        # 返回哈希值的十六进制表示
        return hash_func.hexdigest()
    
    except FileNotFoundError:
        print(f"错误：文件 {file_path} 未找到")
        return None
    except PermissionError:
        print(f"错误：没有权限读取文件 {file_path}")
        return None
    except IOError as e:
        print(f"读取文件时发生错误：{e}")
        return None

def compare_files(file1_path, file2_path, algorithm='sha256'):
    """
    比较两个文件是否相同
    
    参数:
    file1_path (str): 第一个文件路径
    file2_path (str): 第二个文件路径
    algorithm (str): 哈希算法名称 (默认为 'sha256')
    
    返回:
    dict: 文件比较结果
    """
    # 计算两个文件的哈希值
    hash1 = calculate_file_hash(file1_path, algorithm)
    hash2 = calculate_file_hash(file2_path, algorithm)
    
    # 如果任一文件哈希计算失败，返回None
    if hash1 is None or hash2 is None:
        return None
    
    # 返回详细的比较结果
    return {
        'are_same': hash1 == hash2,
        'file1_hash': hash1,
        'file2_hash': hash2
    }

def recursive_compare_directories(dir1_path, dir2_path, algorithm='sha256'):
    """
    递归比较两个目录中的文件和子目录
    
    参数:
    dir1_path (str): 第一个目录路径
    dir2_path (str): 第二个目录路径
    algorithm (str): 哈希算法名称 (默认为 'sha256')
    
    返回:
    dict: 包含详细比较结果的字典
    """
    try:
        # 初始化比较结果字典
        comparison_results = {
            'matching_files': [],
            'different_files': [],
            'only_in_first_dir': [],
            'only_in_second_dir': [],
            'matching_subdirs': [],
            'different_subdirs': [],
            'only_in_first_subdir': [],
            'only_in_second_subdir': []
        }
        
        # 获取目录中的项目（文件和子目录）
        items1 = set(os.listdir(dir1_path))
        items2 = set(os.listdir(dir2_path))
        
        # 找出共同的项目
        common_items = items1.intersection(items2)
        
        # 处理仅存在于单个目录的项目
        comparison_results['only_in_first_dir'] = list(items1 - items2)
        comparison_results['only_in_second_dir'] = list(items2 - items1)
        
        # 比较共同的项目
        for item in common_items:
            path1 = os.path.join(dir1_path, item)
            path2 = os.path.join(dir2_path, item)
            
            # 如果是文件
            if os.path.isfile(path1) and os.path.isfile(path2):
                file_result = compare_files(path1, path2, algorithm)
                
                if file_result and file_result['are_same']:
                    comparison_results['matching_files'].append(item)
                else:
                    comparison_results['different_files'].append(item)
            
            # 如果是目录，递归比较
            elif os.path.isdir(path1) and os.path.isdir(path2):
                subdir_result = recursive_compare_directories(path1, path2, algorithm)
                
                # 判断子目录是否基本一致
                if (not subdir_result['different_files'] and 
                    not subdir_result['only_in_first_dir'] and 
                    not subdir_result['only_in_second_dir']):
                    comparison_results['matching_subdirs'].append(item)
                else:
                    comparison_results['different_subdirs'].append(item)
                
                # 合并子目录比较结果
                for key in ['matching_files', 'different_files', 'only_in_first_dir', 'only_in_second_dir']:
                    comparison_results[key].extend([os.path.join(item, f) for f in subdir_result[key]])
                
                # 处理子目录的额外信息
                comparison_results['matching_subdirs'].extend([os.path.join(item, sd) for sd in subdir_result['matching_subdirs']])
                comparison_results['different_subdirs'].extend([os.path.join(item, sd) for sd in subdir_result['different_subdirs']])
                comparison_results['only_in_first_subdir'].extend([os.path.join(item, sd) for sd in subdir_result['only_in_first_dir']])
                comparison_results['only_in_second_subdir'].extend([os.path.join(item, sd) for sd in subdir_result['only_in_second_dir']])
        
        return comparison_results
    
    except PermissionError:
        print("错误：没有权限访问目录")
        return None
    except FileNotFoundError:
        print("错误：目录不存在")
        return None

def validate_paths(path1, path2):
    """
    验证两个路径的类型和有效性
    
    参数:
    path1 (str): 第一个路径
    path2 (str): 第二个路径
    
    返回:
    dict: 包含路径类型和验证结果的字典
    """
    # 检查路径是否存在
    if not (os.path.exists(path1) and os.path.exists(path2)):
        print("错误：提供的路径必须存在")
        return None
    
    # 判断路径类型
    is_dir1 = os.path.isdir(path1)
    is_dir2 = os.path.isdir(path2)
    is_file1 = os.path.isfile(path1)
    is_file2 = os.path.isfile(path2)
    
    # 检查路径类型是否一致
    if is_dir1 != is_dir2 or is_file1 != is_file2:
        print("错误：两个路径必须是同一类型（都是文件或都是目录）")
        return None
    
    return {
        'is_directory': is_dir1,
        'is_file': is_file1
    }

def format_comparison_result(result):
    """
    格式化比较结果，提供更美观的输出
    """
    # 定义颜色常量
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'

    # 文件比较输出
    def print_file_comparison():
        print(f"\n{BLUE}📁 文件比较结果 {RESET}")
        
        if result['matching_files']:
            print(f"{GREEN}✅ 相同文件 ({len(result['matching_files'])}): {RESET}")
            for file in sorted(result['matching_files']):
                print(f"   {GREEN}●{RESET} {file}")
        
        if result['different_files']:
            print(f"\n{RED}❌ 不同文件 ({len(result['different_files'])}): {RESET}")
            for file in sorted(result['different_files']):
                print(f"   {RED}●{RESET} {file}")
        
        if result['only_in_first_dir']:
            print(f"\n{YELLOW}🔹 仅在第一个目录中的文件 ({len(result['only_in_first_dir'])}): {RESET}")
            for file in sorted(result['only_in_first_dir']):
                print(f"   {YELLOW}●{RESET} {file}")
        
        if result['only_in_second_dir']:
            print(f"\n{YELLOW}🔹 仅在第二个目录中的文件 ({len(result['only_in_second_dir'])}): {RESET}")
            for file in sorted(result['only_in_second_dir']):
                print(f"   {YELLOW}●{RESET} {file}")

    # 子目录比较输出
    def print_subdir_comparison():
        print(f"\n{BLUE}📂 子目录比较结果 {RESET}")
        
        if result['matching_subdirs']:
            print(f"{GREEN}✅ 相同子目录 ({len(result['matching_subdirs'])}): {RESET}")
            for subdir in sorted(result['matching_subdirs']):
                print(f"   {GREEN}●{RESET} {subdir}")
        
        if result['different_subdirs']:
            print(f"\n{RED}❌ 不同子目录 ({len(result['different_subdirs'])}): {RESET}")
            for subdir in sorted(result['different_subdirs']):
                print(f"   {RED}●{RESET} {subdir}")
        
        if result['only_in_first_subdir']:
            print(f"\n{YELLOW}🔹 仅在第一个目录中的子目录 ({len(result['only_in_first_subdir'])}): {RESET}")
            for subdir in sorted(result['only_in_first_subdir']):
                print(f"   {YELLOW}●{RESET} {subdir}")
        
        if result['only_in_second_subdir']:
            print(f"\n{YELLOW}🔹 仅在第二个目录中的子目录 ({len(result['only_in_second_subdir'])}): {RESET}")
            for subdir in sorted(result['only_in_second_subdir']):
                print(f"   {YELLOW}●{RESET} {subdir}")

    # 概览统计
    print(f"{BLUE}📊 目录比较概览 {RESET}")
    print(f"总计相同文件: {GREEN}{len(result['matching_files'])}{RESET}")
    print(f"总计不同文件: {RED}{len(result['different_files'])}{RESET}")
    print(f"仅在第一个目录的文件: {YELLOW}{len(result['only_in_first_dir'])}{RESET}")
    print(f"仅在第二个目录的文件: {YELLOW}{len(result['only_in_second_dir'])}{RESET}")

    # 详细比较
    print_file_comparison()
    print_subdir_comparison()

def main():
    # 创建命令行参数解析器
    parser = argparse.ArgumentParser(description='递归比较文件或目录的哈希值')
    parser.add_argument('path1', help='第一个文件或目录路径')
    parser.add_argument('path2', help='第二个文件或目录路径')
    parser.add_argument('-a', '--algorithm', default='sha256', 
                        help='哈希算法（默认：sha256）')
    
    # 解析命令行参数
    args = parser.parse_args()
    
    try:
        # 验证路径
        path_validation = validate_paths(args.path1, args.path2)
        
        if not path_validation:
            sys.exit(1)
        
        # 根据路径类型选择比较方法
        if path_validation['is_file']:
            print("正在比较文件...")
            result = compare_files(args.path1, args.path2, args.algorithm)
            
            if result:
                print(f"文件是否相同: {result['are_same']}")
                print(f"文件1哈希值: {result['file1_hash']}")
                print(f"文件2哈希值: {result['file2_hash']}")
            else:
                print("文件比较失败")
        
        elif path_validation['is_directory']:
            print("正在递归比较目录...")
            result = recursive_compare_directories(args.path1, args.path2, args.algorithm)
            
            if result:
                format_comparison_result(result)
            else:
                print("目录比较失败")
    
    except Exception as e:
        print(f"发生错误：{e}")
        sys.exit(1)

# 如果直接运行此脚本，执行主函数
if __name__ == '__main__':
    main()