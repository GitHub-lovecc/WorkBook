'''https://zhuanlan.zhihu.com/p/119339281'''

数据集质量不佳有两个可能原因，一，特征与关注点不相关，二，两个特征非常类似。

主成分分析的作用就是降维，提取有效信息，舍弃无效信息，降低数据复杂度，当然这也会以损失一部分信息作为代价，机器学习本身就处处充满了trade-off的过程。

在主成分分析方法中，数据从原来的坐标系转换到新的坐标系，而组成新坐标系的坐标轴正是原有特征的线性组合。
第一个新坐标轴选择的是原始数据中方差最大的方向（因为方差越大表示数据代表越多的信息），
第二个新坐标轴选择的是和第一个坐标轴正交（组成坐标系的重要条件，且不会浪费信息）且具有最大方差的方向。
该过程一直重复，重复次数即为原始数据中特征的数目。
新坐标轴的方差逐渐递减，大部分的方差都包含在最前面的几个坐标轴中，
因此我们忽视余下的坐标轴（这就是以损失一部分信息为代价）即完成数据的降维。

最近重构性：样本点到这个超平面的距离都足够近。
最大可分性：样本点在这个超平面的投影尽可能分开。
最近重构性表示降维后忽视的坐标轴带来的信息损失尽可能最少，最大可分性表示新的坐标系尽可能代表原来样本点更多的信息。

There are two possible reasons for the poor quality of data sets. First, the features are irrelevant to the concerns. Second, the two features are very similar.

The function of principal component analysis is to reduce dimension, extract effective information, discard invalid information and reduce data complexity.
Of course, this will also be at the cost of losing some information. Machine learning itself is full of trade-off processes everywhere.

In the principal component analysis method, the data is transformed from the original coordinate system to the new coordinate system,
and the coordinate axes that make up the new coordinate system are the linear combination of the original features.
The first new coordinate axis selects the direction with the largest variance in the original data 
(because the larger variance means that the data represents more information).
The second new coordinate axis chooses the direction that is orthogonal to the first coordinate axis 
(an important condition to form a coordinate system and will not waste information) and has the largest variance.
This process is repeated all the time, and the number of repetitions is the number of features in the original data.
The variance of the new coordinate axis decreases gradually, and most of the variance is contained in the first few coordinate axes.
Therefore, we ignore the remaining coordinate axis (that is, at the expense of losing some information), that is, completing the dimensionality reduction of data.

Nearest reconstruction: the distance between the sample points and this hyperplane is close enough.
Maximum separability: the projections of sample points on this hyperplane are as separate as possible.
The nearest reconstruction means that the information loss caused by the neglected coordinate axis after dimensionality reduction is as little as possible, 
and the maximum separability means that the new coordinate system represents more information of the original sample point as much as possible.
