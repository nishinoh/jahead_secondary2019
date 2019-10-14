##### 0. 前準備 ========================================================
# library(tidyverse)
library(foreign)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(readr)
library(ggplot2)
theme_set(theme_bw(base_size = 18, base_family = "HiraKakuProN-W3") +
              theme(axis.text=element_text(colour="black")))

##### 1.  利用するデータの準備 ===================================
load("~/Data/JAHEAD/Process_Files/data_after_14.rda")
load("~/Data/JAHEAD/Process_Files/data_after_71_data_frame.rda")

readDataFile <- function(file){
    read.spss(file, to.data.frame = TRUE, reencode = "CP932") %>% 
        as.tibble(.)
}

org_jahead_w1to3 <- readDataFile("~/Data/JAHEAD/0395/0395.sav")
org_jahead_w4 <- readDataFile("~/Data/JAHEAD/0679/0679.sav")
org_jahead_w5to6 <- readDataFile("~/Data/JAHEAD/0823/0823.sav")
org_jahead_w7 <- readDataFile("~/Data/JAHEAD/1185/1185.sav")

##### 欠票理由確認 =========================================

org_jahead_w7 %>%
    count(J7N027)

##### 支援者が誰かの確認 ========================
tmp <- data_long %>%
    filter(wave == 7) %>% 
    filter(needs_type != "どちらも不要")

p_first <- tmp %>% 
    filter(!is.na(who_helped_1_c),
           who_helped_1_c != "DK/NA") %>% 
    count(who_helped_1_c) %>% 
    ggplot(aes(x=reorder(who_helped_1_c, n), y=n)) +
        geom_bar(stat="identity", fill="#009FE1") +
        coord_flip() +
        theme(axis.title.y=element_blank())

quartz(file="~/downloads/fig_who_helped_primary.pdf", type="pdf",  width=8,height=3)
p_first
dev.off()

p_second <- tmp %>% 
    filter(!is.na(who_helped_2_c),
           who_helped_2_c != "DK/NA") %>% 
    count(who_helped_2_c) %>% 
    ggplot(aes(x=reorder(who_helped_2_c, n), y=n)) +
    geom_bar(stat="identity", fill="#009FE1") +
    coord_flip() +
    theme(axis.title.y=element_blank())

quartz(file="~/downloads/fig_who_helped_secondary.pdf", type="pdf",  width=8,height=3)
p_second
dev.off()

##### その他重要な変数のヒストグラム ====================================

# ID一覧を作る
# 分析で利用したIDの一覧を取り出す
tmp <- unique(data_complete_cases$id_personyear)

# 上で取り出したIDと合致するものを元のデータから抜き出す
data_selected <- data_long %>%
    filter(id_personyear %in% tmp)

data_selected %>% 
    mutate(wave = str_sub(id_personyear, 10,11)) %>% 
    count(wave)

data_selected %>% 
    count(lim_adl) %>% 
    ggplot(aes(x=lim_adl, y=n)) +
        geom_bar(stat="identity", fill="#009FE1")

data_selected %>% 
    count(use_dayservice_n) %>% 
    ggplot(aes(x=use_dayservice_n, y=n)) +
        geom_bar(stat="identity", fill="#009FE1")

data_selected %>% 
    count(use_homehelp_n) %>% 
    ggplot(aes(x=use_homehelp_n, y=n)) +
        geom_bar(stat="identity", fill="#009FE1")

data_selected %>% 
    ggplot(aes(x=lim_adl)) +
        geom_histogram(binwidth = 1, fill="#009FE1", colour = "black")

