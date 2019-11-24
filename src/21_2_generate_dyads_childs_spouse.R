##### このファイルについて ========================================================
# 子どもの配偶者の情報を作り、ダイアドに含める

##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(readr)

load("~/Data/JAHEAD/Process_Files/data_after_21.rda")

##### 1. 子ども1人の1年分の情報から、配偶者の情報を作る ===========
# 子供1人に対して配偶者1人のはずなので、子供のデータにそのまま変数を付け足して、
# 配偶者のものとして扱える変数を抜き出す。
# 子と配偶者は共通の情報も多いが、年齢や仕事はNAにしないといけないので、
# gatherではなく、個別に作って後でbind_rowsする。

# 子の配偶者の情報を作る
data_child_spouse <- data_child_dyad %>% 
    filter(ch_married == "はい") %>% 
    # 配偶者の変数を作る
    mutate(id_personyear_child_d = str_c(id_personyear_child, "-S"),
           chs_sex = case_when(ch_sex == "男性" ~ "女性",
                               ch_sex == "女性" ~ "男性"),
           is_child = "子の配偶者") %>% 
    select(id_text, id_personyear, id_personyear_child, id_personyear_child_d, id_child, 
           wave, ch_number, is_child, chs_sex, ch_married, ch_dist_living, ch_dist_living_l) %>% 
    rename(ch_sex = chs_sex)

# 子どもの情報に子か配偶者かの情報を追加
data_child_dyad <- data_child_dyad %>% 
    mutate(id_personyear_child_d = str_c(id_personyear_child, "-C"),
           is_child = "子ども") %>% 
    select(id_text, id_personyear, id_personyear_child, id_personyear_child_d,
           wave, ch_number, is_child, everything())

# 下に配偶者の情報を結合
data_child_dyad <- data_child_dyad %>% 
    bind_rows(data_child_spouse)

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_child_dyad, file="~/Data/JAHEAD/Process_Files/data_after_21_2.rda")
rm(list = ls())