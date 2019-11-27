##### このファイルについて ========================================================
# Stanに渡すデータを作成する
# 両方とも共通するケースを抜き出して、必要であればリストの段階でADLとIADLのデータを分ける

##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)

load("~/Data/JAHEAD/Process_Files/data_after_70_data_frame.rda")

##### 子どもでベル(C)の変数だけ抜き出す ====================================================
data_stan_childs <- data_complete_cases %>% 
    select(id_personyear_child_d_n, id_personyear_child_n, id_personyear_n, id_n,
           do_care_parents_adl, do_care_parents_iadl, 
           is_real_child, ch_female, ch_married, ch_dist_living_l)

##### 回答者のパーソンイヤー単位(P)の変数だけ抜き出す =====================================================
data_stan_panels <- data_complete_cases %>% 
    # dplyr::distinct()が、重複している行を省いてくれる関数
    distinct(id_personyear, .keep_all = TRUE) %>% 
    arrange(id_personyear_n) %>% 
    select(id_personyear_n, id_n, t_age, t_female, lim_adl, lim_iadl,
           use_dayservice_n, use_homehelp_n,
           living_spouse)
# mutate(use_dayservice_n = if_else(use_dayservice_n == 0, 0, 1))

##### 2レベルのモデルに渡すリストを作成 ===================================
list_stan_2levels <- c(list(C = nrow(data_stan_childs)),
                       list(P = nrow(data_stan_panels)),
                       as.list(data_stan_childs),
                       as.list(data_stan_panels))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除
save(list_stan_2levels, file="~/Data/JAHEAD/Process_Files/data_after_71a_72a.rda")
rm(list = ls())