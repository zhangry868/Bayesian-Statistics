using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

lambda = 1.0
lambda_0 = 1/10^2
likelihood(x,theta) = pdf(Normal(0,1/sqrt(lambda)),x-theta)

x = 2.0
L = lambda + lambda_0
M = lambda*x / L

N = 10^6
R = 5
values = zeros(R)
for rep = 1:R
    theta_samples = rand(Normal(M,1/sqrt(L)),N)
    harmonic_mean = 1/mean(1.0./likelihood(x,theta_samples))
    values[rep] = harmonic_mean
end

truth = pdf(Normal(0,sqrt(1/lambda + 1/lambda_0)),x)

println(values[1:5])
println(truth)

figure(1,figsize=(10,4)); clf(); hold(true); grid(true)
plt.hist(values,50)
plot([truth,truth],[0,ylim()[2]],"k--",linewidth=2)
draw_now()
savefig("harmonic_mean.png",dpi=120)


figure(2,figsize=(10,4)); clf(); hold(true); grid(true)
plt.hist(1.0./values,50)
plot([truth,truth],[0,ylim()[2]],"k--",linewidth=2)
#xlim(0,1.5)
draw_now()
# savefig("harmonic_mean_inverse.png",dpi=120)

