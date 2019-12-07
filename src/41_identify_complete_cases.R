##### このファイルについて ========================================================
# Stanに渡すデータを特定する
# 利用するケースを抜き出してデータフレームを作成。
# ここで欠損が全くないデータフレームを作っておく。
# Stanに渡すリスト形式のデータは、ここで作成したデータフレームから削り出して使う。

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

##### 1. Stanに渡せる、欠損のないケースをここで完全に特定する ======================================================
# ここで作成したデータから必要なものを、モデルごとに切り出してリスト化する
# リストにするのは別のファイルで行う。

data_complete_cases <- data_united %>% 
    # Stanに投入する変数だけ抜き出す
    # ここで抽出したケースが分析のサンプルサイズを決めるので、モデルで使わない変数は落とす
    # 子どもの婚姻状態は使うかかなり迷っているので、念のため残しておく
    select(id_personyear_child_d, id_personyear_child, id_personyear, id_text, wave,
           do_care_parents_adl, #ADLで支援のある人を抜き出す
           do_care_parents_iadl, #IADLで支援のある人を抜き出す
           do_care_parents_iadl_only,
           is_child, ch_sex, ch_married, ch_dist_living_l,
           # 親の情報でモデルに含める変数
           t_age, lim_adl, lim_iadl, use_dayservice_d, use_dayservice_n, use_homehelp_d, use_homehelp_n, living_spouse,
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
    mutate(t_female = case_when(t_gender == "女性" ~ 1,
                                t_gender == "男性" ~ 0)) %>% 
    # ここでStanに渡すべきデータが完全に特定
    filter(complete.cases(.)) %>% 
    # Stanで使う共通IDを作成。各種のIDを1からの連番にする。
    arrange(id_personyear_child_d) %>% 
    mutate(id_personyear_child_d_n = as.factor(id_personyear_child_d),
           id_personyear_child_n = as.factor(id_personyear_child),
           id_personyear_n = as.factor(id_personyear),
           id_n = as.factor(id_text)) %>% 
    mutate(id_personyear_child_d_n = unclass(id_personyear_child_d_n),
           id_personyear_child_n = unclass(id_personyear_child_n),
           id_personyear_n = unclass(id_personyear_n),
           id_n = unclass(id_n))

# 念のためIDが問題なく作れているかチェック(データ名変わっているので使うとき修正)
# max(data_complete_cases$id_personyear_child_n)
# max(data_complete_cases$id_personyear_n)
# cor.test(1:nrow(data_stan_child), data_stan_child$id_personyear_child_n)
# cor.test(1:nrow(data_stan_panel), data_stan_panel$id_personyear_n)

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除
save(data_complete_cases, file = "~/Data/JAHEAD/Process_Files/data_after_41_data_frame.rda")
rm(list = ls())