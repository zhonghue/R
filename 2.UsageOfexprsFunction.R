library(GEOquery)

gset <- getGEO('GSE42872', destdir = '.',
               AnnotGPL = F,
               getGPL = F)
data.matrix=read.table('GSE42872_series_matrix.txt.gz',
                       sep = '\t', comment.char = '!',
                       header = T)


#观察data.matrix发现第一列"ID_REF" 是探针号
colnames(data.matrix) 

#给每一行的行名都取名为本基因的探针号
#data.matrix的第一列，作为data.matrix的每一行的名
rownames(data.matrix) <- data.matrix[,1]
data.matrix <- data.matrix[,-1]

#与此同时我们使用exprs函数获取data.matrix.2
#发现gset的class是list，查找这个list的第一个元素
class(gset)
gset[[1]]

#可从gset[[1]]中使用exprs函数萃取出data.matrix.2
data.matrix.2 <- exprs(gset[[1]])

#使用exprs函数获得的data.matrix.2 是"matrix" "array" 对象
class(data.matrix) #"data.frame"
class(data.matrix.2) #"matrix" "array"

#至此，观察data.matrix & data.matrix.2数据形式完全一致。
View(data.matrix)
View(data.matrix.2)

#说明exprs函数包括了上述操作
