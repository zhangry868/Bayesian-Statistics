module Run
using Distributions

n = 8
sigma = 1.0
sigma_0s = linspace(0.05,10,250)
prior_0 = 0.5
prior_1 = 1-prior_0

# x = randn(n)
# print("x = ["); for i = 1:n; @printf("%.1f, ",x[i]); end; println("]")
# x = [0.1, -0.4, 0.0, 0.8, 0.8, 0.9, 1.0, 1.2]
x = [0.8, -0.4, 0.1, 0.0, 1.2, 0.8, 1.0, 0.9]

B = zeros(length(sigma_0s))
for (i,sigma_0) in enumerate(sigma_0s)
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

    B[i] = exp(log_Bayes_factor)
    # println("sigma_0 = ",sigma_0)
    # println("p(H_0|x) = ",posterior_0)
    # println("p(H_1|x) = ",1-posterior_0)
    # println("Bayes factor in favor of 1 over 0 = ", exp(log_Bayes_factor))
    # println("Bayes factor in favor of 0 over 1 = ", 1/exp(log_Bayes_factor))
    # println("Prior odds of 1 over 0 = ",exp(log_prior_odds))
    # println()
end

using PyPlot
figure(1); clf(); hold(true)
plot(sigma_0s,B)
title("Bayes factor in favor of H_1 over H_0")
xlabel("sigma_0")
ylabel("B_10")


end # module

