'''https://zhuanlan.zhihu.com/p/139551727'''
# 例子
from pyecharts.charts import Bar

# 创建柱状图实例
bar = Bar()

# 添加 x 轴数据，即柱状图的分类标签
bar.add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])

# 添加 y 轴数据，即各分类的数据值
bar.add_yaxis("商家A", [5, 20, 36, 10, 75, 90])

# 渲染图表并生成 HTML 文件，默认会在当前目录生成 render.html 文件
# 也可以传入路径参数，如 bar.render("mycharts.html")
bar.render()

# 使用链式调用方式创建柱状图
bar = (
    Bar()
    .add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])
    .add_yaxis("商家A", [5, 20, 36, 10, 75, 90])
)
bar.render()

# 使用 options 配置项添加主标题和副标题
from pyecharts.charts import Bar
from pyecharts import options as opts

# 创建柱状图实例
bar = Bar()

# 添加 x 轴数据，即柱状图的分类标签
bar.add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])

# 添加 y 轴数据，即各分类的数据值
bar.add_yaxis("商家A", [5, 20, 36, 10, 75, 90])

# 使用 options 配置项设置主标题和副标题
bar.set_global_opts(title_opts=opts.TitleOpts(title="主标题", subtitle="副标题"))

# 渲染图表并生成 HTML 文件，默认会在当前目录生成 render.html 文件
# 也可以传入路径参数，如 bar.render("mycharts.html")
bar.render()

# 柱状图
from pyecharts import options as opts
from pyecharts.charts import Bar
from pyecharts.commons.utils import JsCode
from pyecharts.globals import ThemeType

list2 = [
    {"value": 12, "percent": 12 / (12 + 3)},
    {"value": 23, "percent": 23 / (23 + 21)},
    {"value": 33, "percent": 33 / (33 + 5)},
    {"value": 3, "percent": 3 / (3 + 52)},
    {"value": 33, "percent": 33 / (33 + 43)},
]

list3 = [
    {"value": 3, "percent": 3 / (12 + 3)},
    {"value": 21, "percent": 21 / (23 + 21)},
    {"value": 5, "percent": 5 / (33 + 5)},
    {"value": 52, "percent": 52 / (3 + 52)},
    {"value": 43, "percent": 43 / (33 + 43)},
]

c = (
    # 设置主题: 默认是黑红风格, 其他风格大部分还不如黑红风格好看
    Bar(init_opts=opts.InitOpts())
    # 新增x轴数据, 这里有五列柱状图
    .add_xaxis(
        [
            "名字很长的X轴标签1",
            "名字很长的X轴标签2",
            "名字很长的X轴标签3",
            "名字很长的X轴标签4",
            "名字很长的X轴标签5",
        ]
    )
    # 参数一: 系列名称; 参数二: 系列数据; stack: 数据堆叠; category_gap: 柱间距离
    .add_yaxis("product1", list2, stack="stack1", category_gap="50%")
    .add_yaxis("product2", list3, stack="stack1", category_gap="50%")
    # set_series_opts系列配置项，可配置图元样式、文字样式、标签样式、点线样式等; 其中opts.LabelOpts指标签配置项
    .set_series_opts(
        label_opts=opts.LabelOpts(
            position="right",   # 数据标签的位置
            formatter=JsCode(   # 标签内容的格式器, 这里展示了百分比
                "function(x){return Number(x.data.percent * 100).toFixed() + '%';}"
            ),
        )
    )
    # set_global_opts全局配置项
    .set_global_opts(
        # 旋转坐标轴: 解决坐标轴名字过长的问题
        xaxis_opts=opts.AxisOpts(axislabel_opts=opts.LabelOpts(rotate=-15)),
        title_opts=opts.TitleOpts(title="Bar-柱状图展示", subtitle="Bar-副标题"),
    )
    .render("stack_bar_percent.html")
)



# 散点图
from pyecharts import options as opts
from pyecharts.charts import EffectScatter
from pyecharts.faker import Faker
from pyecharts.globals import SymbolType

c = (
    # 特效散点图
    EffectScatter()
    # Faker返回假数据
    .add_xaxis(Faker.choose())
    # symbol=SymbolType.ARROW修改特效类型: 这里指箭头特效
    .add_yaxis("", Faker.values(), symbol=SymbolType.ARROW)
    .set_global_opts(
        title_opts=opts.TitleOpts(title="EffectScatter-显示分割线"),
        # 显示横纵轴分割线
        xaxis_opts=opts.AxisOpts(splitline_opts=opts.SplitLineOpts(is_show=True)),
        yaxis_opts=opts.AxisOpts(splitline_opts=opts.SplitLineOpts(is_show=True)),
    )
    .render("effectscatter_splitline.html")
)



# 漏斗图
data = [[x_data[i], y_data[i]] for i in range(len(x_data))]

(
    # InitOpts初始化配置项: 配置画布长宽
    Funnel(init_opts=opts.InitOpts(width="800px", height="500px"))
    .add(
        series_name="网页访问数据",
        data_pair=data,
        # gap: 数据图形间距, 默认0
        gap=2,
        # tooltip_opts: 鼠标提示框组件配置项, a: series_name, b: x_data, c: y_data
        tooltip_opts=opts.TooltipOpts(trigger="item", formatter="{a} <br/>{b} : {c}%"),
        # label_opts: 标签配置项, inside指标签在图层内部
        label_opts=opts.LabelOpts(is_show=True, position="inside"),
        # 图元样式配置项
        itemstyle_opts=opts.ItemStyleOpts(border_color="#fff", border_width=1),
    )
    .set_global_opts(title_opts=opts.TitleOpts(title="漏斗图", subtitle="纯属虚构"))
    .render("funnel_chart.html")
)


# 关系图
from pyecharts import options as opts
from pyecharts.charts import Graph

# 构造数据: nodes表示节点信息和对应的节点大小; links表示节点之间的关系
nodes = [
    {"name": "结点1", "symbolSize": 10},
    {"name": "结点2", "symbolSize": 20},
    {"name": "结点3", "symbolSize": 30},
    {"name": "结点4", "symbolSize": 40},
    {"name": "结点5", "symbolSize": 50},
    {"name": "结点6", "symbolSize": 40},
    {"name": "结点7", "symbolSize": 30},
    {"name": "结点8", "symbolSize": 20},
]
links = []
# fake节点之间的两两双向关系
for i in nodes:
    for j in nodes:
        links.append({"source": i.get("name"), "target": j.get("name")})
c = (
    Graph()
    # repulsion: 节点之间的斥力因子, 值越大表示节点之间的斥力越大
    .add("", nodes, links, repulsion=8000)
    .set_global_opts(title_opts=opts.TitleOpts(title="Graph-基本示例"))
    .render("graph_base.html")
)


# 组合直方图和折线图
from pyecharts import options as opts
from pyecharts.charts import Bar, Grid, Line
from pyecharts.faker import Faker

bar = (
    Bar()
    .add_xaxis(Faker.choose())
    .add_yaxis("商家A", Faker.values())
    .add_yaxis("商家B", Faker.values())
    .set_global_opts(title_opts=opts.TitleOpts(title="Grid-Bar"))
)
line = (
    Line()
    .add_xaxis(Faker.choose())
    .add_yaxis("商家A", Faker.values())
    .add_yaxis("商家B", Faker.values())
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Grid-Line", pos_top="48%"),
        legend_opts=opts.LegendOpts(pos_top="48%"),
    )
)

grid = (
    Grid()
    # GridOpts: 直角坐标系网格配置项
    # pos_bottom: grid组件离容器底部的距离
    # pos_top: grid组件离容器顶部的距离
    .add(bar, grid_opts=opts.GridOpts(pos_bottom="60%"))
    .add(line, grid_opts=opts.GridOpts(pos_top="60%"))
    .render("grid_vertical.html")
)


# 折线图


import pyecharts.options as opts
from pyecharts.charts import Line
from pyecharts.faker import Faker

c = (
    Line()
    # Faker: 获取伪造数据集
    .add_xaxis(Faker.choose())
    .add_yaxis("商家A", Faker.values())
    .add_yaxis("商家B", Faker.values())
    .set_global_opts(title_opts=opts.TitleOpts(title="Line-基本示例"))
    .render("line_base.html")
)


# 地图

from pyecharts import options as opts
from pyecharts.charts import Map
from pyecharts.faker import Faker

c = (
    Map()
    # Faker: 伪造数据集, 包括国家和对应的value
    .add("商家A", [list(z) for z in zip(Faker.country, Faker.values())], "world")
    # 显示label
    .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Map-世界地图"),
        # VisualMapOpts: 视觉映射配置项, 指定组件的最大值
        visualmap_opts=opts.VisualMapOpts(max_=200),
    )
    .render("map_world.html")



  # 层叠组件

  from pyecharts import options as opts
from pyecharts.charts import Bar, Line
from pyecharts.faker import Faker

v1 = [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3]
v2 = [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3]
v3 = [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2]


bar = (
    Bar()
    .add_xaxis(Faker.months)
    .add_yaxis("蒸发量", v1)
    .add_yaxis("降水量", v2)
    .extend_axis(
        # 新增y坐标轴配置项: 因为有三个纵轴数据, 包括蒸发量/降水量(单位是ml), 平均温度(单位是°C)
        yaxis=opts.AxisOpts(
            axislabel_opts=opts.LabelOpts(formatter="{value} °C"), interval=5
        )
    )
    .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Overlap-bar+line"),
        # 设置y坐标轴配置项
        yaxis_opts=opts.AxisOpts(axislabel_opts=opts.LabelOpts(formatter="{value} ml")),
    )
)

# 新增折线图
line = Line().add_xaxis(Faker.months).add_yaxis("平均温度", v3, yaxis_index=1)
# 使用层叠组件组合图形
bar.overlap(line)
bar.render("overlap_bar_line.html")
)


# 饼状图

from pyecharts import options as opts
from pyecharts.charts import Pie
from pyecharts.faker import Faker

c = (
    Pie()
    .add(
        "",
        # 设置数据集
        [list(z) for z in zip(Faker.choose(), Faker.values())],
        radius=["40%", "55%"],
        # 设置标签配置项
        label_opts=opts.LabelOpts(
            # 标签位置
            position="outside",
            # 标签内容格式器: {a}（系列名称），{b}（数据项名称），{c}（数值）, {d}（百分比）
            formatter="{a|{a}}{abg|}\n{hr|}\n {b|{b}: }{c}  {per|{d}%}  ",
            # 文字块背景色
            background_color="#eee",
            # 文字块边框颜色
            border_color="#aaa",
            border_width=1,
            border_radius=4,
            # 在 rich 里面，可以自定义富文本样式。利用富文本样式，可以在标签中做出非常丰富的效果
            rich={
                "a": {"color": "#999", "lineHeight": 22, "align": "center"},
                "abg": {
                    "backgroundColor": "#e3e3e3",
                    "width": "100%",
                    "align": "right",
                    "height": 22,
                    "borderRadius": [4, 4, 0, 0],
                },
                "hr": {
                    "borderColor": "#aaa",
                    "width": "100%",
                    "borderWidth": 0.5,
                    "height": 0,
                },
                "b": {"fontSize": 16, "lineHeight": 33},
                "per": {
                    "color": "#eee",
                    "backgroundColor": "#334455",
                    "padding": [2, 4],
                    "borderRadius": 2,
                },
            },
        ),
    )
    .set_global_opts(title_opts=opts.TitleOpts(title="Pie-富文本示例"))
    .render("pie_rich_label.html")
)


# 雷达图
import pyecharts.options as opts
from pyecharts.charts import Radar

"""
Gallery 使用 pyecharts 1.1.0
参考地址: https://echarts.baidu.com/examples/editor.html?c=radar

目前无法实现的功能:

1、雷达图周围的图例的 textStyle 暂时无法设置背景颜色
"""
v1 = [[4300, 10000, 28000, 35000, 50000, 19000]]
v2 = [[5000, 14000, 28000, 31000, 42000, 21000]]

(
    Radar(init_opts=opts.InitOpts(width="1280px", height="720px", bg_color="#CCCCCC"))
    .add_schema(
        schema=[
            opts.RadarIndicatorItem(name="销售（sales）", max_=6500),
            opts.RadarIndicatorItem(name="管理（Administration）", max_=16000),
            opts.RadarIndicatorItem(name="信息技术（Information Technology）", max_=30000),
            opts.RadarIndicatorItem(name="客服（Customer Support）", max_=38000),
            opts.RadarIndicatorItem(name="研发（Development）", max_=52000),
            opts.RadarIndicatorItem(name="市场（Marketing）", max_=25000),
        ],
        splitarea_opt=opts.SplitAreaOpts(
            is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
        ),
        textstyle_opts=opts.TextStyleOpts(color="#fff"),
    )
    .add(
        series_name="预算分配（Allocated Budget）",
        data=v1,
        linestyle_opts=opts.LineStyleOpts(color="#CD0000"),
    )
    .add(
        series_name="实际开销（Actual Spending）",
        data=v2,
        linestyle_opts=opts.LineStyleOpts(color="#5CACEE"),
    )
    .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
    .set_global_opts(
        title_opts=opts.TitleOpts(title="基础雷达图"), legend_opts=opts.LegendOpts()
    )
    .render("basic_radar_chart.html")
)


# 普通散点图

from pyecharts import options as opts
from pyecharts.charts import Scatter
from pyecharts.faker import Faker

c = (
    Scatter()
    .add_xaxis(Faker.choose())
    .add_yaxis("商家A", Faker.values())
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Scatter-显示分割线"),
        xaxis_opts=opts.AxisOpts(splitline_opts=opts.SplitLineOpts(is_show=True)),
        yaxis_opts=opts.AxisOpts(splitline_opts=opts.SplitLineOpts(is_show=True)),
    )
    .render("scatter_splitline.html")
)


'''https://github.com/pyecharts/pyecharts/'''
