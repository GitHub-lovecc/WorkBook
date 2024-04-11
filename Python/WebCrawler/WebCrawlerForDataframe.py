# 下载统计表

import os
import pandas as pd
# 定义下载目录
download_dir = r"C:\Users\Administrator\Desktop\教育经费统计表"
data_filtered = pd.read_csv('C:\Users\Administrator\Desktop\经费统计表下载链接.csv')


# 比较早的年代没有下载链接
data_filtered = data_filtered[0:21]
# 创建下载目录
os.makedirs(download_dir, exist_ok=True)

# 存储下载失败的文件标题和链接
failed_downloads = []

import requests

max_retries = 3  # 最大重试次数

# 添加请求头
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36'
}

for link, title in zip(data_filtered['链接'], data_filtered['标题']):
    # 处理标题，使其成为有效的文件名
    file_name = os.path.join(download_dir, f"{title}.doc")
    
    # 发送请求并下载文件，最多尝试 max_retries 次
    for attempt in range(max_retries):
        try:
            # 发送 GET 请求并获取响应
            response = requests.get(link, headers=headers)
            
            # 如果响应状态码为 200，则表示请求成功
            if response.status_code == 200:
                # 写入文件
                with open(file_name, 'wb') as f:
                    f.write(response.content)
                print(f"已下载文件: {file_name}")
                break  # 如果下载成功，跳出重试循环
            else:
                # 如果响应状态码不是 200，则打印错误信息并记录到失败列表中
                print(f"第 {attempt+1} 次尝试下载文件失败: 响应状态码 {response.status_code}")
                if attempt == max_retries - 1:
                    failed_downloads.append((title, link))
                    print("已达到最大重试次数，放弃下载该文件")
        except Exception as e:
            # 捕获所有异常，打印错误信息并记录到失败列表中
            print(f"第 {attempt+1} 次尝试下载文件失败: {e}")
            if attempt == max_retries - 1:
                failed_downloads.append((title, link))
                print("已达到最大重试次数，放弃下载该文件")
