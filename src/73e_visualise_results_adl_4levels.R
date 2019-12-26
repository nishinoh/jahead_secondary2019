library(tidyverse)
library(rstan)

load("~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_adl_4levels.rda")

post <- summary(fit_model_adl)$summary %>% 
    #head(., 30) %>% 
    as.data.frame(.) %>% 
    mutate(term = row.names(.)) %>% 
    mutate(num = row_number()) %>% 
    filter(num >= 2,
           num <= 8)

display <- c("bi_1", "bi_2", "bc_1", "bp_1", "bp_2", "bp_3", "br_1")
term_full <- c("実の子ども", "子の性別(女性=1)", "居住場所の距離", "親のADL困難度", "親が配偶者と居住", "デイサービス利用", "親の性別(女性=1)")
term_list <- tibble(term = display,
                    term_full = term_full)

estimated_parameters_adl <- post %>% 
    dplyr::select(term, mean, se_mean, sd, `2.5%`, `50%`, `97.5%`, num) %>% 
    mutate(eap_odds = exp(mean),
           med_odds = exp(`50%`),
           ymin_odds = exp(`2.5%`),
           ymax_odds = exp(`97.5%`)) %>% 
    filter(term %in% display) %>% 
    left_join(term_list, by="term")

p <- estimated_parameters_adl %>% 
    ggplot(aes(x=reorder(term_full, -num), y=med_odds, ymax=ymax_odds, ymin=ymin_odds)) +
    geom_pointrange(size=1) +
    geom_hline(aes(yintercept = 1), size = .25, linetype = "dashed") +
    scale_y_continuous(trans="log", #軸を対数変換
                       breaks = c(0, 0.2, 0.5, 1, 2, 4)) +
    coord_flip() + 
    labs(y="オッズ比") +
    theme_bw(base_size = 18, base_family = "HiraKakuProN-W3") +
    theme(axis.text=element_text(colour="black"),
          axis.title.y=element_blank())
print(p)

# 以下の保存場所は、分析者の個人的なフォルダ環境です。
# 他の方がこのコードを使うときは、各自の環境に合わせて指定してください。
quartz(file="~/Dropbox/00_Projects/dropbox_jahead_secondary2019/fig/fig_result_adl_4levels.pdf", type="pdf",  width=8,height=4.5)
p
dev.off()

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除
save(estimated_parameters_adl, file = "~/Data/JAHEAD/Process_Files/estimated_parameters_adl.rda")
# rm(list = ls())