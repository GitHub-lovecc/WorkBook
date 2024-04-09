'''https://zhuanlan.zhihu.com/p/104038378'''

与随机森林赋予每一颗决策树相同的投票权重不同，XGBoost算法中下一棵决策树的生成和前一棵决策树的训练和预测相关
（通过对上一轮决策树训练准确率较低的样本赋予更高的学习权重来提高模型准确率）。相比于其他集成学习算法，XGBoost一方面通过引入正则项和列抽样的方法提高了模型稳健性，
另一方面又在每棵树选择分裂点的时候采取并行化策略从而极大提高了模型运行的速度。

Different from the random forest giving every decision tree the same voting weight, 
the generation of the next decision tree in XGBoost algorithm is related to the training and prediction of the previous decision tree.
(The accuracy of the model is improved by giving higher learning weights to the samples with lower accuracy in the last round of decision tree training). 
Compared with other ensemble learning algorithms, XGBoost improves the robustness of the model by introducing regular items and column sampling.
On the other hand, the parallelization strategy is adopted when each tree chooses the split point, which greatly improves the running speed of the model.
