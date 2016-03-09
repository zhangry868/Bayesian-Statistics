# WARNING: If this file is edited, paper.tex may also need to be updated.
using Distributions
if false
    theta_0 = 1/18
    n = 8
    D = Exponential(1/theta_0)
    x = rand(D,n)
    for i = 1:n; @printf("%.1f, ",x[i]); end
end

using PyPlot
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Data
x = [20.9, 69.7, 3.6, 21.8, 21.4, 0.4, 6.7, 10.0]
n = length(x)

# Prior: Gamma(a,b)
a = 0.1
b = 1.0

# Gamma density
f(t,a,b) = exp((a-1)*log(t) - b*t + a*log(b) - lgamma(a))

# Make plots
figure(1); clf(); hold(true)
t = linspace(eps(),0.3,500)
# Plot prior
plot(t,f(t,a,b),label="prior, \$p(\\theta)\$",linewidth=2)
# Plot posterior
A = a + n
B = b + sum(x)
plot(t,f(t,A,B),label="posterior, \$p(\\theta|x_{1:n})\$",linewidth=2)
# Adjust plot settings
ylim(0,25)
xlabel("\$\\theta\$",fontsize=20)
legend(loc=1,fontsize=18)
draw_now()
# Save figure
#savefig("homework.png",dpi=120)



