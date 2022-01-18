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

Install_Bio_db <- function(GPLNumber){
  #输入：GPL号， 如'GPL99'
  #输出：一个下载R包的动作
  #用法：a=Install_Bio_db('GPL99') //存在此平台
  #      Install_Bio_db('GPL30000') //不存在此平台
  
  id_symbol <- read.csv('GPL2RPackage.csv')
  if(GPLNumber %in% id_symbol$GPL){
    Platform <- subset(id_symbol, GPL==GPLNumber)$db
    print(subset(id_symbol, GPL==GPLNumber))
    
    GPL_db <- paste(Platform, '.db', sep = '')
    
    BiocManager::install(GPL_db, update = F)
    return(GPL_db)
  }else{
    noquote('Oh! Package Not Exist.')
  }
  
  
}

#ids <- toTable(hugene10sttranscriptclusterSYMBOL)
ID_Transvert <- function(ExprData, ids){
  #输入：ExprSet, ids 
  #输出：探针注释后的AnnoExprData
  #用法：AnnoExprData <- ID_Transvert(exprSet)
  #注意：需事先加载探针注释包  
  #      修改toTable函数中的“包SYMBOL”  
  
  ExprData <- ExprData[rownames(ExprData) %in% ids$probe_id,]
  ids <- ids[match(rownames(ExprData), ids$probe_id),]
  tmp <- by(ExprData,
            ids$symbol,
            function(x) rownames(x)[which.max(rowMeans(x))])
  probes <- as.character(tmp)
  ExprData <- ExprData[rownames(ExprData) %in% probes, ]
  rownames(ExprData)=ids[match(rownames(ExprData),ids$probe_id),2]
  
  write.csv(ExprData, 'Annoted_ExprData.csv')
  return (ExprData)
}

