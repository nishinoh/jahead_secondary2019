##### このファイルについて ========================================================
# Stanに渡すデータを作成する
# 両方とも共通するケースを抜き出して、必要であればリストの段階でADLとIADLのデータを分ける

##### このファイルについて ========================================================
# Stanに渡すデータを作成する
# 両方とも共通するケースを抜き出して、必要であればリストの段階でADLとIADLのデータを分ける

##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)

load("~/Data/JAHEAD/Process_Files/data_after_41_data_frame.rda")

##### 1. 完全な個人単位(I)の変数だけ抜き出す ====================================================
data_stan_individuals <- data_complete_cases %>% 
    # IDは自分の階層と1つ上の階層のものだけ含めないとエラーになる
    select(id_personyear_child_d_n, id_personyear_child_n,
           do_care_parents_adl, do_care_parents_iadl, do_care_parents_iadl_only,
           is_real_child, ch_female, ch_married)

##### 3. 子ども夫婦単位(C)の変数だけ抜き出す =====================================================
data_stan_childs_couples <- data_complete_cases %>% 
    distinct(id_personyear_child, .keep_all = TRUE) %>% 
    select(# id_personyear_child,id_personyear, id_text,
           id_personyear_child_n, id_personyear_n,
           ch_dist_living_l)

##### 3. 回答者のパーソンイヤー単位(P)の変数だけ抜き出す =====================================================
data_stan_panels <- data_complete_cases %>% 
    # dplyr::distinct()が、重複している行を省いてくれる関数
    distinct(id_personyear, .keep_all = TRUE) %>% 
    arrange(id_personyear_n) %>% 
    select(id_personyear_n, id_n, t_age, lim_adl, lim_iadl,
           use_dayservice_d, use_homehelp_d,
           living_spouse)

##### 3. 回答者単位(R)の変数だけ抜き出す =====================================================
data_stan_respondents <- data_complete_cases %>% 
    distinct(id_text, .keep_all = TRUE) %>% 
    arrange(id_n) %>% 
    select(id_text, id_n, t_female)

##### 4レベルのモデルに渡すリストを作成 ===================================
list_stan_4levels <- c(list(I = nrow(data_stan_individuals)),
                       list(C = nrow(data_stan_childs_couples)),
                       list(P = nrow(data_stan_panels)),
                       list(R = nrow(data_stan_respondents)),
                       as.list(data_stan_individuals),
                       as.list(data_stan_childs_couples),
                       as.list(data_stan_panels),
                       as.list(data_stan_respondents))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除
save(list_stan_4levels, file="~/Data/JAHEAD/Process_Files/data_after_70.rda")
rm(list = ls())