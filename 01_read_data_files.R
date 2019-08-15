library(tidyverse)
library(foreign)

# 各Waveごとのデータ読み込み
# エンコーディングの都合上havenでなくforeignで
# 変数ラベルは各フォルダにテキストファイルがある
org_jahead_w1to3 <- read.spss("~/Data/JAHEAD/0395/0395.sav", to.data.frame = TRUE, reencode = "CP932")
org_jahead_w4 <- read.spss("~/Data/JAHEAD/0679/0679.sav", to.data.frame = TRUE, reencode = "CP932")
org_jahead_w5to6 <- read.spss("~/Data/JAHEAD/0823/0823.sav", to.data.frame = TRUE, reencode = "CP932")
org_jahead_w7 <- read.spss("~/Data/JAHEAD/1185/1185.sav", to.data.frame = TRUE, reencode = "CP932")