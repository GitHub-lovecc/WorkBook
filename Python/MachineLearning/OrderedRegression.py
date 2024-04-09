'''https://zhuanlan.zhihu.com/p/109862616'''
一般我们以没有数值意义但是有顺序意义的数据统称为定序数据。

如果对定序变量使用多分类logit模型，那么会无视数据内在的排序从而导致排序信息的缺失。
如果使用普通线性回归模型，那么就是将定序变量视为连续变量处理，会导致人为的信息膨胀。

定序逻辑/概率回归模型

我们将会构造分段的概率函数，并将概率分布假定成标准正态分布和逻辑分布，分别对应着probit定序回归和logit定序回归
然后使用参数估计，极大似然估计，统计推断，中心极限定理，假设检验。



Generally, we refer to data with no numerical significance but sequential significance as ordinal data.

If the multi-classification logit model is used for ordered variables, the inherent sorting of data will be ignored, 
which will lead to the lack of sorting information.
If the ordinary linear regression model is used, then the ordered variables are treated as continuous variables, 
which will lead to artificial information expansion.
  
ordered logit/probit model

We will construct a piecewise probability function and assume that the probability distribution is a standard normal distribution 
  and a logical distribution, which correspond to probit ordered regression and logit ordered regression respectively.
Then parameter estimation, maximum likelihood estimation, statistical inference, central limit theorem and hypothesis testing are used.
