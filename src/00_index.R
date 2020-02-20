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
# 子どものダイアドに子の配偶の情報も含める
source("src/21_2_generate_dyads_childs_spouse.R", echo=TRUE)
# 子どものデータと親(回答者)のデータを結合
source("src/22_unite_respondents.R", echo=TRUE)
# 親子データから新たな変数を作成
source("src/23_generate_childs_variables_1.R", echo=TRUE)

##### 4. 分析に使うデータを特定する ========================================
# 共通で使うケースを抜き出す
source("src/41_identify_complete_cases.R", echo=TRUE)

##### 7. Stanで推定 ===================================================

# それぞれの推定に使うデータを作成
source("src/70_prepare_list_for_4level_models.R", echo=TRUE)
