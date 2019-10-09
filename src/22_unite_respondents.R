##### 0. 前準備 ========================================================
library(tidyverse)

load("~/Data/JAHEAD/Process_Files/data_after_14.rda")
load("~/Data/JAHEAD/Process_Files/data_after_21.rda")

##### 1. データを統合

# 回答者(親)の情報のうち必要なものだけ抜き出し
tmp <- data_long %>% 
    select(id, id_text, id_personyear, wave, int_year,
           lim_adl, lim_iadl, lim_ability,
           exist_helper_adl, exist_helper_adl_l, exist_helper_iadl, exist_helper_iadl_l,
           who_helped_1_c, who_helped_1_ch_id, who_helped_2_c, who_helped_2_ch_id)

keys <- c("id_text", "id_personyear", "wave")
data_united <- data_child_dyad %>% 
    left_join(tmp, by=keys)

data_united <- data_united %>% 
    # 子ども番号から、親にケアを提供しているか否かを変数化
    # 番号が指し示す子どもが変数を通して一定であることが前提
    mutate(do_care_parents_primary = if_else((who_helped_1_c == "子ども" & ch_number == who_helped_1_ch_id), 1, 0),
           do_care_parents_secondary = if_else(who_helped_2_c == "子ども" & ch_number == who_helped_2_ch_id, 1, 0)) %>% 
    mutate(do_care_parents = case_when(do_care_parents_primary == 1 | do_care_parents_secondary == 1 ~ 1,
                                       is.na(who_helped_1_c) ~ NA_real_,
                                       TRUE ~ 0))

data_united %>% count(do_care_parents, wave)
data_united %>% group_by(id) %>% summarise(n=n())

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_united, file="~/Data/JAHEAD/Process_Files/data_after_22.rda")
rm(list = ls())