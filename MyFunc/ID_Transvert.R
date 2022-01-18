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


