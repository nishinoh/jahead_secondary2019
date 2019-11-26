data {
    int C; // 子どもの情報
    int P; // 回答者のWave
    int R; // 回答者のIDごと
    int<lower=0, upper=P> id_personyear[C];
    int<lower=0, upper=R> id_text[P];
    int<lower=0, upper=1> infcare[C]; //被説明変数
    int<lower=0, upper=1> ch_female[C]; //個人レベルの説明変数
    real<lower=0> ch_age[C];
    real<lower=0, upper=1> ch_working[C];
    real<lower=0, upper=1> ch_dist_living_l[C];
    real<lower=0> t_age[P];
    int<lower=0, upper=6> lim_adl[P]; //ここから世帯単位の情報
    int<lower=0, upper=1> use_dayservice[P]; //個人レベルの説明変数
    int<lower=0> num_hh_memer[P];
    int<lower=0, upper=1> t_female[R];
    real<lower=0> daycare[C]; //ここから国単位の情報
}

parameters {
    real b_0; // 全体切片
    real b_1; // 係数@子の性別
    real b_2; // 係数@子の年齢
    real b_3; // 係数@子の雇用形態
    real b_4; // 係数@子の住んでいる距離
    real bp_1; // 係数@回答者の年齢
    real bp_2; // 係数@ニードの重さ
    real bp_3; // 係数@世帯の人数
    real bp_4; // 係数@デイケア利用
    real br_1; // 回答者の性別
    real b_p[P];
    real b_r[R];
    real<lower=0> sigma_p;
    real<lower=0> sigma_r;
}

transformed parameters {
    real q[C];
    real x_p[P];
    real x_r[R];
    for(r in 1:R)
        x_r[r] = br_1*t_female[r] + b_r[r];
    for(p in 1:P)
        x_p[p] = bp_1*t_age[p] + bp_2*lim_adl[p] + bp_3*num_hh_memer[p] + bp_4*use_dayservice[p] + b_p[p];
    for(c in 1:C)
        q[c] = inv_logit(b_0 + b_1*ch_female[c] + b_2*ch_age[c] + b_3*ch_working[c] + b_4*ch_dist_living_l[c] + x_p[id_personyear[c]] + x_r[id_text[c]]);
}

model {
    for (r in 1:R)
        b_r[r] ~ normal(0, sigma_r);
    for (p in 1:P)
        b_p[p] ~ normal(0, sigma_p);
    for (c in 1:C)
        infcare[c] ~ bernoulli(q[c]);
}
