#install.packages('BiocManager') 首先下载Biocmanager包

#BiocManager::install('GEOquery') 通过Bio从manager包下载GEOquery。

library(GEOquery)  #读取GEOquery包

#下载GSE文件，目标文件夹：本文件夹下
gset <- getGEO('GSE42872', destdir = '.')

#下载得到matrix的.gz文件，首先将其解压为.txt
#或者用7-zip软件解压.gz文件
txt.file <- gzfile("GSE42872_series_matrix.txt.gz")

#打开文件后用记事本观察数据形状
#发现真正数据使用tab键分割，注释语言使用！符号开头
data.matrix=read.table(txt.file,
             header=T, comment.char = '!', sep = '\t' )
write.csv(data.matrix, file = 'ExpressionData.csv')
