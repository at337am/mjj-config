#!/usr/bin/env python3
import os
import sys
import base64
import argparse
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from getpass import getpass


def generate_key(password, salt):
    """
    使用PBKDF2生成加密密钥
    """
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000,
    )
    key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
    return key


def encrypt_file(filename, key, output_dir):
    """
    使用Fernet对称加密文件
    """
    try:
        # 生成随机salt
        salt = os.urandom(16)

        # 使用密码和salt生成加密密钥
        fernet_key = generate_key(key, salt)
        cipher_suite = Fernet(fernet_key)

        # 读取原文件
        with open(filename, "rb") as file:
            file_data = file.read()

        # 加密数据
        encrypted_data = cipher_suite.encrypt(file_data)

        # 基于原文件名创建加密后的文件名, 并指定输出目录
        base_filename = os.path.basename(filename)
        encrypted_filename = os.path.join(output_dir, f"{base_filename}_encrypted")

        # 写入salt和加密数据
        with open(encrypted_filename, "wb") as file:
            file.write(salt + encrypted_data)

        print(f"-> 文件已加密: {encrypted_filename}")
        return encrypted_filename
    except Exception as e:
        print(f"加密失败: {e}")
        return None


def decrypt_file(filename, key, output_dir):
    """
    使用Fernet对称解密文件
    """
    try:
        # 读取加密文件
        with open(filename, "rb") as file:
            encrypted_data = file.read()

        # 提取salt
        salt = encrypted_data[:16]
        encrypted_content = encrypted_data[16:]

        # 使用密码和salt重新生成密钥
        fernet_key = generate_key(key, salt)
        cipher_suite = Fernet(fernet_key)

        # 解密数据
        decrypted_data = cipher_suite.decrypt(encrypted_content)

        # 基于原文件名创建解密后的文件名, 并指定输出目录
        base_filename = os.path.basename(filename)
        if base_filename.endswith("_encrypted"):
            decrypted_base_filename = base_filename[: -len("_encrypted")]
        else:
            decrypted_base_filename = f"{base_filename}_restored"
        decrypted_filename = os.path.join(output_dir, decrypted_base_filename)

        # 写入解密数据
        with open(decrypted_filename, "wb") as file:
            file.write(decrypted_data)

        print(f"-> 文件已解密: {decrypted_filename}")
        return decrypted_filename
    except Exception as e:
        print(f"解密失败: {e}")
        return None


def main():
    # 创建一个参数解析器, 提供脚本的描述信息
    parser = argparse.ArgumentParser(description="文件或目录加密/解密脚本")

    # 创建一个互斥参数组, 确保加密和解密模式只能二选一且必选
    group = parser.add_mutually_exclusive_group(required=True)

    # 添加加密模式选项, 设置为布尔值开关
    group.add_argument("-e", "--encrypt", action="store_true", help="加密模式")

    # 添加解密模式选项, 设置为布尔值开关
    group.add_argument("-d", "--decrypt", action="store_true", help="解密模式")

    # 添加位置参数 'path', 用于接收需要处理的文件或目录路径
    parser.add_argument("path", help="要处理的文件或目录路径")

    # 添加 -o 选项来指定输出目录
    parser.add_argument(
        "-o",
        "--output",
        default="output_cryptor",
        help="指定输出目录 (默认: output_cryptor)",
    )

    # 解析命令行参数
    args = parser.parse_args()

    target_path = args.path
    output_dir = args.output

    print(f"准备处理的路径: {target_path}")

    # 创建输出目录, 如果它不存在的话
    os.makedirs(output_dir, exist_ok=True)
    print(f"所有输出文件将保存到: {output_dir}")

    # 获取密码
    password = getpass("请输入密钥: ")

    # 检查路径是文件还是目录
    if os.path.isdir(target_path):
        # 如果是目录, 则遍历目录中的每个文件
        for filename in os.listdir(target_path):
            file_path = os.path.join(target_path, filename)
            # 确保当前项是文件, 而不是子目录
            if os.path.isfile(file_path):
                print(f"正在处理文件: {file_path}")
                if args.encrypt:
                    encrypt_file(file_path, password, output_dir)
                else:  # args.decrypt
                    decrypt_file(file_path, password, output_dir)
        print(f"目录处理完成: {target_path}")
    elif os.path.isfile(target_path):
        # 如果是文件, 则按原逻辑处理
        if args.encrypt:
            encrypt_file(target_path, password, output_dir)
        else:  # args.decrypt
            decrypt_file(target_path, password, output_dir)
    else:
        # 如果路径既不是文件也不是目录, 则报错
        print(f"错误: 路径 '{target_path}' 不是一个有效的文件或目录", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
