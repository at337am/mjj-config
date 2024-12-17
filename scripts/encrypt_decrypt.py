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

def encrypt_file(filename, key):
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
        with open(filename, 'rb') as file:
            file_data = file.read()
        
        # 加密数据
        encrypted_data = cipher_suite.encrypt(file_data)
        
        # 创建加密后的文件名
        encrypted_filename = f"{filename}_encrypted"
        
        # 写入salt和加密数据
        with open(encrypted_filename, 'wb') as file:
            file.write(salt + encrypted_data)
        
        print(f"文件已成功加密: {encrypted_filename}")
        return encrypted_filename
    except Exception as e:
        print(f"加密失败: {e}")
        return None

def decrypt_file(filename, key):
    """
    使用Fernet对称解密文件
    """
    try:
        # 读取加密文件
        with open(filename, 'rb') as file:
            encrypted_data = file.read()
        
        # 提取salt
        salt = encrypted_data[:16]
        encrypted_content = encrypted_data[16:]
        
        # 使用密码和salt重新生成密钥
        fernet_key = generate_key(key, salt)
        cipher_suite = Fernet(fernet_key)
        
        # 解密数据
        decrypted_data = cipher_suite.decrypt(encrypted_content)
        
        # 创建解密后的文件名
        if filename.endswith('_encrypted'):
            decrypted_filename = filename[:-len('_encrypted')]
        else:
            decrypted_filename = f"{filename}_restored"
        
        # 写入解密数据
        with open(decrypted_filename, 'wb') as file:
            file.write(decrypted_data)
        
        print(f"文件已成功解密: {decrypted_filename}")
        return decrypted_filename
    except Exception as e:
        print(f"解密失败: {e}")
        return None

def main():
    # 创建参数解析器
    parser = argparse.ArgumentParser(description='文件加密/解密工具')
    
    # 使用互斥参数组
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-e', '--encrypt', action='store_true', 
                       help='加密模式')
    group.add_argument('-d', '--decrypt', action='store_true', 
                       help='解密模式')
    
    # 文件名参数
    parser.add_argument('filename', help='要处理的文件名')
    
    # 解析参数
    args = parser.parse_args()
    
    # 获取密码
    password = getpass("请输入密钥: ")
    
    # 根据模式执行加密或解密
    if args.encrypt:
        encrypt_file(args.filename, password)
    else:  # args.decrypt must be True
        decrypt_file(args.filename, password)

if __name__ == '__main__':
    main()
