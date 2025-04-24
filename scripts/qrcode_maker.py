import qrcode

def text_to_qrcode(text, output_file="qrcode.png"):
    """将文本转换为二维码并保存为图片"""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=2,
    )
    qr.add_data(text)
    qr.make(fit=True)
    
    img = qr.make_image(fill="black", back_color="white")
    img.save(output_file)
    print(f"二维码已保存为 {output_file}")

if __name__ == "__main__":
    text = "WIFI:T:WPA;S:wifiname;P:wifipasswd;;"
    text_to_qrcode(text)

# 使用示例：
# python qrcode_maker.py
