# 爬取教育经费执行公报网址


from selenium import webdriver
import time
import pandas as pd
from selenium.webdriver.common.by import By

def crawl_data(url, file_path):
    try:
        browser = webdriver.Chrome()
        browser.get(url)
        time.sleep(5)

        data = pd.DataFrame([], columns=['链接', '标题'])

        # 定位具有特定 class 的元素
        class_element = browser.find_element(By.CLASS_NAME, 'moe-list')  # 请替换 'class_name' 为您要定位的 class 名称

        # 在定位的元素下寻找 <li> 元素
        poli = class_element.find_elements(By.TAG_NAME, 'li')
        for elements in poli:
            try:
                link = elements.find_element(By.TAG_NAME, "a").get_attribute('href')  # 链接
                title = elements.find_element(By.TAG_NAME, "a").text  # 标题
                content = [link, title]
                while len(content) < 2:
                    content.append(0)
                content = pd.DataFrame([content], columns=['链接', '标题'])
                data = pd.concat([data, content])
            except Exception as e:
                print(f"爬取失败: {e}")

        print(f"已爬取完当前页面内容: {url}")

        # 将 DataFrame 写入 CSV 文件
        data.to_csv(file_path, encoding='utf_8_sig', index=False)

    except Exception as e:
        print(f"爬取失败: {e}")

    finally:
        # 关闭浏览器
        browser.quit()

# 调用函数进行爬取
url_1 = 'http://www.moe.gov.cn/jyb_sjzl/sjzl_jfzxgg/'
file_path_1 = r'C:\Users\Administrator\Desktop\教育经费执行公报1.csv'
crawl_data(url_1, file_path_1)

url_2 = 'http://www.moe.gov.cn/jyb_sjzl/sjzl_jfzxgg/index_1.html'
file_path_2 = r'C:\Users\Administrator\Desktop\教育经费执行公报2.csv'
crawl_data(url_2, file_path_2)
