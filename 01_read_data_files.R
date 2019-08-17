library(tidyverse)
library(foreign)

# 各Waveごとのデータ読み込み
# エンコーディングの都合上havenでなくforeignで
readDataFile <- function(file){
    read.spss(file, to.data.frame = TRUE, reencode = "CP932") %>% 
        as.tibble(.)
}

org_jahead_w1to3 <- readDataFile("~/Data/JAHEAD/0395/0395.sav")
org_jahead_w4 <- readDataFile("~/Data/JAHEAD/0679/0679.sav")
org_jahead_w5to6 <- readDataFile("~/Data/JAHEAD/0823/0823.sav")
org_jahead_w7 <- readDataFile("~/Data/JAHEAD/1185/1185.sav")


##### 1.1. CSVファイルにリストを作成し、それを読み込んで共通変数名をつける =================

var_table <- read_csv("00_variable_names.csv")

#各列がWave。CSVファイルでも、空のセルにはNAをちゃんと入れること。
#odsとcsvファイルを併用するかは検討中。色をつけたりもしたいし、odsで編集して常にcsvで書き出しってしてもいいかも。
#na.omit()をした各列をベクトルにして、その文字列たちに合致する例を持ってくる

modules <- c("w1", "w2", "w3", "w4_main", "w4_alt",
             "w5_main", "w5_alt", "w6_main", "w6_alt", "w7_main", "w7_alt")


selectVariables <- function(data, var_table, module){
    # moduleで入力した変数名とcommon_nameをペアにしておく    
    var_pair <- c("common_name", module)
    
    # これからつける共通変数名と、元の変数名のペアのDFを作成
    var_names <- var_table %>%
        # 仮にvar_pair という列名があるとそちらが選ばれるので、安全策として「!!」でunquote
        select(!! var_pair) %>%
        filter(!is.na(.[[module]]))
    
    # データから該当する列を取り出し、名前を共通の変数名に変更
    out <- data %>%
        select(var_names[[module]])
    names(out) <- var_names$common_name
    
    return(out)
}

test <- selectVariables(org_jahead_w5to6, var_table, module="wave6_main")
