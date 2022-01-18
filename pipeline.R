source('FuncSum.R')

ExprSet <- GSE_to_ExprSet('GSE42872')
Install_Bio_db('GPL6244')
library(hugene10sttranscriptcluster.db)
ids <- toTable(hugene10sttranscriptclusterSYMBOL)
AnnoExprSet <- ID_Transvert(ExprSet, ids)