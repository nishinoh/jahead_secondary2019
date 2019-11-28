data {
    int I; // ユニット数(個人)
    int C; // 子どもとその配偶者のペア数
    int P; // 回答者(パーソンイヤー)のケース数
    int R; // 回答者の数
    int<lower=0, upper=C> id_personyear_child_n[I];
    int<lower=0, upper=P> id_personyear_n[C];
    int<lower=0, upper=R> id_n[P];
    int<lower=0, upper=1> do_care_parents_adl[I]; //被説明変数
    int<lower=0, upper=1> is_real_child[I]; //個人レベルの説明変数
    int<lower=0, upper=1> ch_female[I]; 
    real<lower=0, upper=4> ch_dist_living_l[C];
    // real<lower=0> t_age[P]; //回答者の年齢
    int<lower=0, upper=6> lim_adl[P]; //ここから世帯単位の情報
    int<lower=0, upper=1> living_spouse[P]; //配偶者と住んでいるか
    int<lower=0> use_dayservice_n[P]; //特に着目する説明変数
    int<lower=0, upper=1> t_female[R]; //回答者の性別(女性ダミー)
}

parameters {
    real b_0; // 全体切片
    real bi_1; // 係数@子の子どもかは子の配偶者か
    real bi_2; // 係数@子の性別
    real bc_1; // 係数@子の住んでいる距離
    // real bp_1; // 係数@回答者の年齢
    real bp_1; // 係数@ニードの重さ
    real bp_2; // 係数@配偶者と住んでいるか
    real bp_3; // 係数@デイケア利用
    real br_1; // 係数@回答者の性別(女性ダミー)
    real ec[C]; //子ども世帯レベルの残差
    real ep[P]; //回答者パーソンイヤーレベルの残差
    real er[R]; //回答者レベルの残差
    real<lower=0> sigma_c;
    real<lower=0> sigma_p;
    real<lower=0> sigma_r;
}

transformed parameters {
    real q[I]; //最終的な線形予測子
    real ac[C]; // 子どものペア別切片
    real ap[P]; // 回答者パーソンイヤー別切片
    real ar[R]; // 回答者個人別切片
    for(r in 1:R)
        ar[r] = b_0 + br_1*t_female[r] + er[r];
    for(p in 1:P)
        ap[p] = ar[id_n[p]] + bp_1*lim_adl[p] + bp_2*living_spouse[p] + bp_3*use_dayservice_n[p] + ep[p];
    for(c in 1:C)
        ac[c] = ap[id_personyear_n[c]] + bc_1*ch_dist_living_l[c] + ec[c];
    for(i in 1:I)
        q[i] = inv_logit(ac[id_personyear_child_n[i]] + bi_1*is_real_child[i] + bi_2*ch_female[i]);
}

model {
    for(i in 1:I)
        do_care_parents_adl[i] ~ bernoulli(q[i]);
    for(c in 1:C)
        ec[c] ~ normal(0, sigma_c);
    for(p in 1:P)
        ep[p] ~ normal(0, sigma_p);
    for(r in 1:R)
        er[r] ~ normal(0, sigma_r);
}
