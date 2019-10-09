##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(readr)

load("~/Data/JAHEAD/Process_Files/data_after_14.rda")

##### 1. 子ども1人の1年分の情報で1行になるようにデータを作成する関数 ===========
# 変数名のキー(共通の名前)を指定したら、子ども1人1年分で1行になるように変換する
# 質問ごとにデータを作成して後で統合する

generateChilds <- function(data, variable){
    quote_varname <- deparse(substitute(variable))
    output_varname <- str_c("ch_", quote_varname)
    data %>%
        # まずは必要な変数だけ抜き出す
        # containsだけで絞れないかもしれないので、先に子どもの変数だけ抜き出して、2段階で抜き出す
        select(id_text, wave, id_personyear, starts_with("ch_")) %>% 
        select(id_text, wave, id_personyear, contains(quote_varname)) %>% 
        gather(key=question, value=value, -id_text, -wave, -id_personyear) %>% 
        # 下で4～5文字目を抜き出すというのは、「ch_01_age」などの形式の変数名となっているのが前提
        # 変数名は「00_bariable_names.csv」のファイルを参照
        mutate(ch_number = str_sub(question, 4,5)) %>% 
        arrange(id_personyear) %>% 
        filter(value != "NA",
               value != "非該当") %>% 
        #子ども番号が、別のWaveでは一貫しないので、id_personyearごとにだけIDを作る
        mutate(id_personyear_child = str_c(id_personyear, "-C", ch_number),
               id_child = str_c(id_text, "-C", ch_number)) %>% 
        select(id_text, id_personyear, id_personyear_child, id_child, wave, ch_number, value) %>% 
        mutate(ch_number = as.integer(ch_number)) %>% 
        rename(!!output_varname := value)
}

##### 2. 関数を使ってデータを作成 ==================================================

# 実際に関数を適用
dyad_ch_sex <- generateChilds(data_long, sex) # 性別　ch005_xx - 1:20
dyad_ch_age <- generateChilds(data_long, age) # 年齢
dyad_ch_married <- generateChilds(data_long, married) # 婚姻状態
dyad_ch_working <- generateChilds(data_long, working) # 働いているか
dyad_ch_dist_living <- generateChilds(data_long, dist_living)

# 結合
id_var <- c("id_text", "id_personyear", "id_personyear_child", "id_child", "wave", "ch_number")
data_child_dyad <- dyad_ch_sex %>%
    left_join(dyad_ch_age, by=id_var) %>% 
    left_join(dyad_ch_married, by=id_var) %>% 
    left_join(dyad_ch_working, by=id_var) %>% 
    left_join(dyad_ch_dist_living, by=id_var)

##### 3. 不具合修正 ==================================================
# ラベルの中身がWaveごとに全角半角混在していたので揃える
data_child_dyad <- data_child_dyad %>% 
    mutate(ch_dist_living = case_when(ch_dist_living == "１０分未満" ~ "10分未満",
                                      ch_dist_living == "１時間未満" ~ "1時間未満",
                                      ch_dist_living == "１時間以上" ~ "1時間以上",
                                      ch_dist_living == "DK" ~ NA_character_,
                                      ch_dist_living == "DK/NA" ~ NA_character_,
                                      TRUE ~ ch_dist_living)) %>% 
    mutate(ch_dist_living = fct_relevel(ch_dist_living,
                                        c("同居", "10分未満", "1時間未満", "1時間以上"))) %>% 
    mutate(ch_dist_living_l = unclass(ch_dist_living))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_child_dyad, file="~/Data/JAHEAD/Process_Files/data_after_21.rda")
rm(list = ls())