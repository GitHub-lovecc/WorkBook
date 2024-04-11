import asyncio
import aiohttp
import pandas as pd
from bs4 import BeautifulSoup

# 异步函数：获取网页内容
async def fetch_page(session, url):
    async with session.get(url) as response:
        return await response.text()

# 异步函数：解析网页内容，提取链接和标题
async def parse_page(html):
    data = pd.DataFrame([], columns=['链接', '标题'])
    soup = BeautifulSoup(html, 'html.parser')
    # 找到包含文章列表的元素
    class_element = soup.find('ul', class_='moe-list')
    if class_element:
        # 遍历每个列表项，提取链接和标题
        for li in class_element.find_all('li'):
            link = li.find('a')['href']
            title = li.find('a').text
            data = data.append({'链接': link, '标题': title}, ignore_index=True)
    return data

# 异步函数：爬取数据，并保存到CSV文件中
async def crawl_data(url, file_path):
    # 创建一个异步HTTP客户端会话
    async with aiohttp.ClientSession() as session:
        # 获取网页内容
        html = await fetch_page(session, url)
        # 解析网页内容，提取数据
        data = await parse_page(html)
        # 将数据保存到CSV文件中
        data.to_csv(file_path, encoding='utf_8_sig', index=False)
        print(f"已爬取完当前页面内容: {url}")

# 主函数
async def main():
    tasks = []  # 创建一个任务列表
    base_url = 'http://www.moe.gov.cn/jyb_sjzl/sjzl_jfzxgg/index_{}.html'
    file_path_base = r'C:\Users\Administrator\Desktop\教育经费执行公报{}.csv'
    # 循环遍历要爬取的页面数量
    for i in range(1, 3):  # 假设要爬取前两页数据
        url = base_url.format(i)
        file_path = file_path_base.format(i)
        # 创建异步任务，并添加到任务列表中
        tasks.append(crawl_data(url, file_path))
    # 并发执行所有任务
    await asyncio.gather(*tasks)

if __name__ == "__main__":
    asyncio.run(main())  # 运行主函数

