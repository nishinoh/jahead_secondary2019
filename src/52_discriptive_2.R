##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(readr)
library(ggplot2)
theme_set(theme_bw(base_size = 14, base_family = "HiraKakuProN-W3") +
              theme(axis.text=element_text(colour="black")))


##### 欠票理由確認 =========================================
readDataFile <- function(file){
    read.spss(file, to.data.frame = TRUE, reencode = "CP932") %>% 
        as.tibble(.)
}

org_jahead_w1to3 <- readDataFile("~/Data/JAHEAD/0395/0395.sav")
org_jahead_w4 <- readDataFile("~/Data/JAHEAD/0679/0679.sav")
org_jahead_w5to6 <- readDataFile("~/Data/JAHEAD/0823/0823.sav")
org_jahead_w7 <- readDataFile("~/Data/JAHEAD/1185/1185.sav")

tmp <- org_jahead_w7 %>%
    count(J7N027)

##### 支援者が誰かの確認 ==============
load("~/Data/JAHEAD/Process_Files/data_after_14.rda")

tmp <- data_long %>%
    filter(wave == 7) %>% 
    filter(needs_type != "どちらも不要")

tmp %>% 
    filter(!is.na(who_helped_1_c),
           who_helped_1_c != "DK/NA") %>% 
    count(who_helped_1_c) %>% 
    ggplot(aes(x=reorder(who_helped_1_c, n), y=n)) +
        geom_bar(stat="identity", fill="#009FE1") +
        coord_flip() +
        theme(axis.title.y=element_blank())
        

tmp %>% 
    count()

data_long %>%
    
    filter(wave == 7) %>% 
    count(who_helped_2_c)
    