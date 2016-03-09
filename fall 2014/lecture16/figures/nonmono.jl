module Run
using Distributions

n_max =  1500
ns = linspace(1,n_max,100)
sigma = 1.0
sigma_0 = 5.0
prior_0 = 0.5
prior_1 = 1-prior_0
n_reps = 1000

xs = randn(n_max) + 0.1
# print("x = ["); for i = 1:n; @printf("%.1f, ",x[i]); end; println("]")
# x = [0.1, -0.4, 0.0, 0.8, 0.8, 0.9, 1.0, 1.2]
# x = [0.8, -0.4, 0.1, 0.0, 1.2, 0.8, 1.0, 0.9]

log_B = zeros(length(ns),n_reps)
for rep in 1:n_reps
    for (i,n) in enumerate(ns)
        x = randn(int(n)) +0.1#xs[1:n]
        
        function log_marginal_likelihood(x)
            n = length(x)
            s = 1/sqrt(n/sigma^2 + 1/sigma_0^2)
            m = (s^2/sigma^2)*sum(x)
            return log(s/sigma_0) + 0.5*m^2/s^2 + sum(logpdf(Normal(0,sigma),x))
        end

        log_lik_0 = sum(logpdf(Normal(0,sigma),x))
        log_lik_1 = log_marginal_likelihood(x)

        log_Bayes_factor = log_lik_1 - log_lik_0
        log_prior_odds = log(prior_1)-log(prior_0)

        posterior_0 = 1/(1+exp(log_Bayes_factor + log_prior_odds))

        log_B[i,rep] = log_Bayes_factor
        # println("sigma_0 = ",sigma_0)
        # println("p(H_0|x) = ",posterior_0)
        # println("p(H_1|x) = ",1-posterior_0)
        # println("Bayes factor in favor of 1 over 0 = ", exp(log_Bayes_factor))
        # println("Bayes factor in favor of 0 over 1 = ", 1/exp(log_Bayes_factor))
        # println("Prior odds of 1 over 0 = ",exp(log_prior_odds))
        # println()
    end
end

using PyPlot
figure(1); clf(); hold(true)
semilogy(ns,exp(mean(log_B,2)))
title("Bayes factor in favor of H_1 over H_0")
xlabel("n")
ylabel("B_10")

println(exp(mean(log_B,2)[100]

end # module

