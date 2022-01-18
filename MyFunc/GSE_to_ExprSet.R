GSE_to_ExprSet <- function(GSEstr){
  #输入：GSE号码，如 "GSE42749"
  #输出：matrix格式的探针-样本矩阵，并有.csv文件
  #用法：GSE_to_ExprSet('GSE83923')
  
  suppressPackageStartupMessages(library(GEOquery))
  gset <- getGEO(GSEstr, destdir = '.',
                 AnnotGPL = F,
                 getGPL = F)
  ExprSet <- exprs(gset[[1]])
  write.csv(ExprSet, file = 'ExprData.csv')
  
  return(ExprSet)
}



