'''https://zhuanlan.zhihu.com/p/105480985'''
分类学习最基本的思想就是基于训练集在样本空间中找到一个划分超平面，将不同类别的样本区分开,我们的任务就是寻找到最优的划分超平面。
使用判别式计算所有点与超平面的间隔，并且判断位置。
距离超平面最近的几个训练点正好使分类判别式等号成立，它们被称为“支持向量”。
为了找到合适的超平面使得分类结果是最鲁棒的(即对未见示例的泛化能力最强)，我们令划分超平面的“间隔”最大化。
训练完成后，大部分的训练样本不需要保留，最终模型只与支持向量有关。

The basic idea of classification learning is to find a partition hyperplane in the sample space based on the training set, 
and to distinguish different samples. Our task is to find the optimal partition hyperplane.
Use discriminant to calculate the margin between point and hyperplane, and judge the position.
The nearest training points to the hyperplane just make the classification discriminant equal, and they are called "support vectors".
In order to find a suitable hyperplane so that the classification result is the most robust 
(that is, the generalization ability to the unknown examples is the strongest), we maximize the "margin" of dividing hyperplanes.
After the training is completed, most of the training samples do not need to be retained, and the final model is only related to support vectors.
