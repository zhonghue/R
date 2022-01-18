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

