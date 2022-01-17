GSE_to_ExprSet <- function(GSEstr){
  suppressPackageStartupMessages(library(GEOquery))
  gset <- getGEO(GSEstr, destdir = '.',
                 AnnotGPL = F,
                 getGPL = F)
  ExprSet <- exprs(gset[[1]])
  write.csv(ExprSet, file = 'ExpressionData.csv')
  
  return(ExprSet)
}



