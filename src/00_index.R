##### コードの目次 =============================================

##### 0. Waveをマージする =====================================
source("src/01_read_data_files.R", echo=TRUE)

##### 1. 変数を新たに作成 ===================================
# ADLやIADLの困難度
source("src/11_generate_variables_1.R", echo=TRUE)
# 私的なケアやサポートの有無
source("src/12_generate_variables_2.R", echo=TRUE)
# 公的ケアの利用状況
source("src/13_generate_variables_3.R", echo=TRUE)
# 年齢・性別など基本属性
source("src/14_generate_variables_4.R", echo=TRUE)

