# 爬取教育经费执行公告统计表链接


import pandas as pd
from selenium import webdriver
import time
from selenium.webdriver.common.by import By

# 从 CSV 文件加载数据
df = pd.read_csv('C:\Users\Administrator\Desktop\combined_df经费.csv')  # 替换为您的 DataFrame 文件路径

# 定义处理函数
def process_url(url, index, total_data):
    browser = webdriver.Chrome()
    browser.get(url)
    time.sleep(5)


    poli = browser.find_elements(By.TAG_NAME, 'p')
    for elements in poli:
        try:
            link = elements.find_element(By.TAG_NAME, "a").get_attribute('href')  # 链接
            title = elements.find_element(By.TAG_NAME, "a").text  # 标题
            content = [link, title]
            content = pd.DataFrame([content], columns=['链接', '标题'])
            total_data = pd.concat([total_data, content])
            break  # 找到第一个链接和标题后立即退出循环
        except:
            pass

    print(f"已获取完第{index + 1}张表")
    # 停止浏览器
    browser.quit()
    return total_data

# 创建一个空的 DataFrame 来存储数据
total_data = pd.DataFrame([], columns=['链接', '标题'])

# 循环处理每个网址
for index, row in df.iterrows():
    url = row['链接']  # 根据您的 DataFrame 结构获取网址列的名称
    total_data = process_url(url, index, total_data)

# 将处理后的数据写入 CSV 文件
total_data.to_csv('C:\Users\Administrator\Desktop\经费统计表下载链接.csv', index=False)

print("数据处理完成并保存到 processed_data.csv 文件中。")
