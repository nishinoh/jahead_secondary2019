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

##### 2. 子どものダイアドを作成
# 子どもについて聞かれた情報からダイアド形式のデータを作成
source("src/21_generate_dyads.R", echo=TRUE)
# 子どものデータと親(回答者)のデータを結合
source("src/22_unite_respondents.R", echo=TRUE)
# 親子データから新たな変数を作成
source("src/23_generate_childs_variables_1.R", echo=TRUE)

##### 7. Stanで推定 ===================================================
# 
source("src/71a_prepare_list_data.R", echo=TRUE)
