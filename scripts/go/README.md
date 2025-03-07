1. 对路径下所有视频文件进行清洗, 检查 MIME 类型和后缀名是否匹配  

```bash
vidfixer ./
```

2. 将所有 mov 转换成 mp4  

```bash
mov2mp4 ./
```

3. 统一后缀名 .mp4 为小写, 并删除多余的 mov  

```bash
fmp4 ./
```

4. 最后按照修改日期顺序重命名所有文件  

```bash
tmrn -d ./
```
