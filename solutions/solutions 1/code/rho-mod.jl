# WARNING: If this file is edited, paper.tex may also need to be updated.

using PyPlot
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Beta density
f(t,a,b) = exp((a-1)*log(t) + (b-1)*log(1-t) - lbeta(a,b))
dt = 1/5000
t = [dt/2:dt:1-dt/2]

# Data
n = 30
z = 1

# Prior: Beta(a,b)
a = 0.05
b = 1.0

# Posterior: Beta(A,B)
A = a + z
B = b + n - z
p_t = f(t,A,B)

# Loss function
loss(theta,theta_hat) = abs(theta-theta_hat).*(1.0 + 9.0*(theta_hat.<theta))

# Posterior expected loss
# Compute using a Riemann sum approximation.
# Note: When z=0 this is not a good approximation since the density blows up at 0.
rho(theta_hat) = sum(loss(t,theta_hat).*p_t*dt)


# Plot posterior expected loss
figure(1); clf(); hold(true)
rhos = [rho(th)::Float64 for th in t]
plot(t,rhos,linewidth=2)
xlim(0,0.5)
ylim(0,0.5)
xlabel("\$c\$",fontsize=20)
ylabel("\$\\rho(c,x)\$",fontsize=20)
draw_now()

# Find minimizer
println(t[indmin(rhos)])

# Save figure
#savefig("rho.png",dpi=120)



