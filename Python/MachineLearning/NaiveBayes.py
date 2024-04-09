'''https://zhuanlan.zhihu.com/p/102391939'''
以二分类问题为例，我们假设特征集合为x，样本所属类别为c，后验概率p(c|x)为：p(c)p(x|c)/p(x),
其中p(c)是类的先验概率；p(x|c)是样本  相对于类标记的类条件概率；p(x)代表样本出现的概率，但是给定样本x，p(x)与类标记无关。因此我们只需要计算先验概率和类条件概率。

特征之间条件独立就是朴素。

求出所有类别的p(c|x)后取后验概率最大的类别c为最近预测类别。

Taking the binary classification problem as an example, we assume that the feature set is x, the sample belongs to category c, 
and the posterior probability p(c|x) is: p(c)p(x|c)/p(x).
Where p(c) is the prior probability of the class; P(x|c) is the class conditional probability of the sample relative to the class marker; 
P(x) represents the probability of occurrence of a sample, but given sample X, p(x) has nothing to do with the class label. 
So we only need to calculate the prior probability and the conditional probability.

Conditional independence between features is simplicity.

After finding p(c|x) of all categories, the category C with the largest posterior probability is taken as the latest prediction category.
