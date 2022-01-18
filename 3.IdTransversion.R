#目的：转换GPL平台的探针id数字 --> gene symbol名
#多个探针对应一个基因，哪个探针在所有样本的表达量平均值最高，我们就取哪个。

#通过GEOquery下载GSE文件，下载目的地：该文件夹
#不下载GPL注释文件，因为文件太大
library(GEOquery) 
gset <- getGEO('GSE42872', destdir = '.',
               AnnotGPL = F, #不下载GPL注释文件，因为文件太大
               getGPL = F)

#使用exprs函数获取GSE文件中的“基因探针--送检样本（GSM）”矩阵
#该矩阵固定命名为“exprSet”
exprSet <- exprs(gset[[1]])

#在GEO页面查询GPL平台，通过id转换的CSV文件找到对应R包
#用Biocmanager下载、加载这个R包，如下：
#BiocManager::install('hugene10sttranscriptcluster.db')
library(hugene10sttranscriptcluster.db)

#这个R包不仅可以将探针号转为symbol名，还能转为其他
#可以使用columns(hugene10sttranscriptcluster())来查看
columns(hugene10sttranscriptcluster())



#totable函数等于as.data.frame函数
#hugene10sttranscriptclusterSYMBOL转化为两列表格形式
#ids对应表：一列探针号，一列基因名，彼此是相互对应关系
ids <- toTable(hugene10sttranscriptclusterSYMBOL)
View(ids)
class(hugene10sttranscriptclusterSYMBOL)
head(as.data.frame(hugene10sttranscriptclusterSYMBOL))

#在ids对应表中，探针号唯一，而symbol可以多次重复出现
#即多个探针对应一个基因
#实际检测出的基因为：18858个
length(unique(ids$symbol)) #18858
plot(table(sort(table(ids$symbol))))

#rownames(exprSet)是实际测出探针号:33297个
#ids$probe_id是探针对应表中有记载的探针号:19869个
#实际测出的探针号 & 有记载探针号相交，即可注释的探针号：19869个
table(rownames(exprSet) %in% ids$probe_id)
#（1）第一次过滤：rownames(exprSet) 33297 && 19869 = 19869
exprSet <- exprSet[rownames(exprSet) %in% ids$probe_id,]
dim(exprSet)
View(exprSet)


#ids重新取子集，选定条件为：实际测出和有记载的探针号相重合
#（2）通过match函数，将exprSet和ids$probe_id的探针顺序一一匹配
ids <- ids[match(rownames(exprSet),ids$probe_id),]
dim(ids)

#by语法：by(数据集， 分类数据，操作)
#意为以数据集中的分类数据进行分类，分类后产生的子集再进行操作
#本句释义：以exprSet为全数据集，以ids$symbol为分类条件
    #分为若干子数据集，对这些子数据集进行操作。

#function(x) rownames(x)[which.max(rowMeans(x))])
    #x为同一symbol所取的子数据集
    #rownames(x)为这一symbol的所有探针号
    #rowMeans(x)为这个子数据集的每个探针，其对应的所有样本的表达量的平均值
    #which.Max(x)取一列数的最大值的下标
    #本句意义：对每一个symbol有多个探针，取哪个探针比较好呢？
    #答：哪个探针在所有样本里的表达量最大，我们就取第几个。
    
tmp <-  by(exprSet, ids$symbol,
          function(x) rownames(x)[which.max(rowMeans(x))])

probes <- as.character(tmp)
class(probes)
class(rownames(exprSet))
dim(exprSet)
#exprSet取子集，标准就是刚才的标准（表达量最大的探针）
#（3）第二次过滤，分割为子集取最大一个探针，19869变为18858
exprSet <- exprSet[rownames(exprSet) %in% probes, ]
rownames(exprSet)=ids[match(rownames(exprSet),ids$probe_id),2]
dim(exprSet)
View(exprSet)
