##### このファイルについて ========================================================
# Stanに渡すデータを作成する
# 両方とも共通するケースを抜き出して、必要であればリストの段階でADLとIADLのデータを分ける

##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(readr)

load("~/Data/JAHEAD/Process_Files/data_after_14.rda")
load("~/Data/JAHEAD/Process_Files/data_after_23.rda")

##### 1. 子どものデータを抜き出してリスト化 ======================================================
# リストにしてStanに渡すべきケースをここで完全に特定する

data_complete_cases <- data_united %>% 
    # Stanに投入する変数だけ抜き出す
    select(id_personyear_child_d, id_personyear_child, id_personyear, id_text,
           do_care_parents_adl, #ADLで支援のある人を抜き出す
           do_care_parents_iadl, #IADLで支援のある人を抜き出す
           is_child, ch_sex, ch_married, ch_dist_living_l,
           # 親の情報でモデルに含める変数
           t_age, lim_adl, lim_iadl, use_dayservice_n, use_homehelp_n, num_hh_member,
           t_gender
           ) %>% 
    # ここから加工するべき変数を加工する
    # 「NA」という文字列で入っているものを除いたりするので、後には回せない。
    mutate(ch_female = case_when(ch_sex == "男性" ~ 0,
                                 ch_sex == "女性" ~ 1),
           ch_married = case_when(ch_married == "はい" ~ 1,
                                  ch_married == "いいえ" ~ 0),
           is_real_child = case_when(is_child == "子ども" ~ 1,
                                     is_child == "子の配偶者" ~ 0)) %>% 
    # ここでStanに渡すべきデータが完全に特定
    filter(complete.cases(.)) %>% 
    # Stanで使う共通IDを作成。各種のIDを1からの連番にする。
    arrange(id_personyear_child_d) %>% 
    mutate(id_personyear_child_d_n = as.factor(id_personyear_child_d),
           id_personyear_child_n = as.factor(id_personyear_child),
           id_personyear_n = as.factor(id_personyear)) %>% 
    mutate(id_personyear_child_d_n = unclass(id_personyear_child_d_n),
           id_personyear_child_n = unclass(id_personyear_child_n),
           id_personyear_n = unclass(id_personyear_n))

##### ダイアドで使う変数だけ抜き出す ====================================================
data_stan_child <- data_complete_cases %>% 
    select(id_personyear_child_d_n, id_personyear_child_n, id_personyear_n,
           do_care_parents_adl, do_care_parents_iadl, 
           is_real_child, ch_female, ch_married, ch_dist_living_l)

##### 回答者の各時点データを抜き出す =====================================================
data_stan_panel <- data_complete_cases %>% 
    # dplyr::distinct()が、重複している行を省いてくれる関数
    distinct(id_personyear, .keep_all = TRUE) %>% 
    mutate(t_female = case_when(t_gender == "女性" ~ 1,
                                t_gender == "男性" ~ 0)) %>% 
    arrange(id_personyear_n) %>% 
    select(id_personyear, id_personyear_n, t_age, t_female, lim_adl, lim_iadl,
           use_dayservice_n, use_homehelp_n,
           num_hh_member)
    # mutate(use_dayservice_n = if_else(use_dayservice_n == 0, 0, 1))

# 念のためIDが問題なく作れているかチェック
# max(data_stan_child$id_personyear_child_n)
# max(data_stan_panel$id_personyear_n)
# cor.test(1:nrow(data_stan_child), data_stan_child$id_personyear_child_n)
# cor.test(1:nrow(data_stan_panel), data_stan_panel$id_personyear_n)

##### リストにする ===================================
list_stan_adl <- c(list(C = nrow(data_stan_child)),
                   list(P = nrow(data_stan_panel)),
                   as.list(data_stan_child),
                   as.list(data_stan_panel))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除
save(data_complete_cases, file = "~/Data/JAHEAD/Process_Files/data_after_71_data_frame.rda")
save(list_stan_adl, file="~/Data/JAHEAD/Process_Files/data_after_71.rda")
rm(list = ls())