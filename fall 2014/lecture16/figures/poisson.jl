module Run
using Distributions

a,b = 4,0.02
prior_0 = 0.75
prior_1 = 1-prior_0

x = [204,  215, 182,  225,  207,   188,  205,  227,  190,  211, 196,  203]
y = [211, 233, 244,  241,  195,  252,  238,  249,  220,  213]


function log_marginal_likelihood(x)
    n = length(x)
    s = sum(x)
    return a*log(b)-lgamma(a)-sum(lgamma(x+1)) + lgamma(a+s) - (a + s)*log(b + n)
end

log_lik_0 = log_marginal_likelihood([x,y])
log_lik_1 = log_marginal_likelihood(x) + log_marginal_likelihood(y)

log_Bayes_factor = log_lik_1 - log_lik_0
log_prior_odds = log(prior_1)-log(prior_0)

posterior_0 = 1/(1+exp(log_Bayes_factor + log_prior_odds))

println("p(H_0|x) = ",posterior_0)
println("p(H_1|x) = ",1-posterior_0)
println("Bayes factor in favor of 1 over 0 = ", exp(log_Bayes_factor))
println("Bayes factor in favor of 0 over 1 = ", 1/exp(log_Bayes_factor))
println("Prior odds of 1 over 0 = ",exp(log_prior_odds))
println()


end # module

