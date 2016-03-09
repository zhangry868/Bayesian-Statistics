module gumbel

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

c,b = 2,0.5

N = 10^5
u = rand(N)
x = -b*log(log(1.0./u)) + c
z = rand(Gumbel(c,b),N)

figure(1,figsize=(10,4)); clf(); hold(true)
plt.hist(x,100)
xlim(-5,12)
draw_now()

figure(2,figsize=(10,4)); clf(); hold(true)
plt.hist(z,100)
xlim(-5,12)
draw_now()

end
