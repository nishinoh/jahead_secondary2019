library(tidyverse)
library(rstan)

load("~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_adl_4levels.rda")

post <- summary(fit_model)$summary %>% 
    #head(., 30) %>% 
    as.data.frame(.) %>% 
    mutate(term = row.names(.)) %>% 
    mutate(num = row_number()) %>% 
    filter(num >= 2,
           num <= 8)

display <- c("bi_1", "bi_2", "bc_1", "bp_1", "bp_2", "bp_3", "br_1")
term_full <- c("実の子ども", "子の性別(女性=1)", "居住場所の距離", "親のADL困難度", "親が配偶者と居住", "デイサービス利用回数", "親の性別")
term_list <- tibble(term = display,
                    term_full = term_full)

fig_data <- post %>% 
    dplyr::select(term, mean, se_mean, sd, `2.5%`, `50%`, `97.5%`, num) %>% 
    mutate(mean_o = exp(mean),
           ymin_o = exp(`2.5%`),
           ymax_o = exp(`97.5%`)) %>% 
    filter(term %in% display) %>% 
    left_join(term_list, by="term")

p <- fig_data %>% 
    ggplot(aes(x=reorder(term_full, -num), y=mean_o, ymax=ymax_o, ymin=ymin_o)) +
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

quartz(file="~/downloads/fig_result_adl_4levels.pdf", type="pdf",  width=8,height=4.5)
p
dev.off()