# Figures for lecture 4
module Figures

using PyPlot
using Distributions

function draw_now(number = 0)
    if number>0; figure(number); end
    pause(0.001) # this forces the figure to update (draw() is supposed to do this, but doesn't work for me)
    get_current_fig_manager()[:window][:raise_]() # bring figure window to the front
end

if false
# Poisson process example (1d)
figure(1); clf(); hold(true)
n = 200
a = 0.2
T = 40
x = rand(Exponential(1/a), n)
ts = cumsum(x)
for t in ts
    plot([t,t],[0,1],"b-")
    plot(t,1,"bo")
end
ylim(0,2)
xlim(0,T)
yticks()
title("Event times in a 1d Poisson process")
xlabel("time")
draw_now()

figure(2); clf(); hold(true)
N = 0
for i=1:n-1
    N += 1
    plot(ts[i],N,"bo")
    plot([ts[i],ts[i+1]],[N,N],"b-")
end
xlim(0,T)
ylim(0,sum(int(ts.<T))+1)
title("Number of events N(t) up to time t")
xlabel("time")
ylabel("N(t)")
draw_now()
end

if false
# Poisson process example (2d)
figure(3); clf(); hold(true)
w,h = 10,4
N = rand(Poisson(25))
x = rand(N)*w
y = rand(N)*h
plot(x,y,"ro")
xlim(0,w)
ylim(0,h)
yticks(0:h)
title("Points in a 2d Poisson process")
draw_now()
end


if false
# 2d Inhomogeneous Poisson process
figure(4); clf(); hold(true)
r(x) = 0.5*(cos(norm(x))+1)
w = 40
# importance sampling estimate of integral of r over [-w/2,w/2]x[-w/2,w/2]
c = mean([r(rand(2)*w-w/2)*w*w for i=1:10^4])
println(c)
N = rand(Poisson(c))
x = zeros(N)
y = zeros(N)
n = 0
while n<N
    # sample from r/c using rejection sampling
    u = rand(2)*w - w/2
    if rand()*1.0 < r(u) # we multiply rand() times an upper bound on r, in this case, 1.0
        n += 1
        x[n] = u[1]
        y[n] = u[2]
    end
end
plot(x,y,"b.")
xlim(-w/2,w/2)
ylim(-w/2,w/2)
#title("Sample from a 2d inhomogeneous Poisson process")
draw_now()
end

if true
# Seizure example
#m,s = 0.3,1.0
#b = m/s^2
#a = b*m
a,b = 0.1,0.3
println(cdf(Gamma(a,1/b),0.03))
println(a," ",b)

q = 0.25
v = 365
n = 8
#f(t) = q/(q+(1+t/(b+v))^(-(a+n))*(1-q))
f(t) = q/(q+((b+v)/(b+v+t))^(a+n)*(1-q))

gampdf(x,a,b) = exp(a*log(b)-lgamma(a)+(a-1)*log(x)-b*x)
figure(5); clf(); hold(true)
xs = linspace(0.001,1,1000)
plot(xs,gampdf(xs,a,b))
draw_now()

ts = 1:365
figure(6); clf(); hold(true)
plot(ts,[f(t) for t in ts],"-")
xlim(0,365)
ylim(0,1)
title("Prob. of effective treatment, given no seizure up to time t")
xlabel("t  (\# days after treatment)")
ylabel("probability")
draw_now()


g(t) = q/(q+((0+v)/(0+v+t))^(0+n)*(1-q))
figure(7); clf(); hold(true)
plot(ts,[f(t) for t in ts],"b-")
plot(ts,[g(t) for t in ts],"r--",linewidth=1)
xlim(0,365)
ylim(0,1)
title("Prob. of effective treatment, given no seizure up to time t")
xlabel("t  (\# days after treatment)")
ylabel("probability")
legend(["proper","improper"],loc=4)
draw_now()
println(f(60))
println(g(60))
end



end # module

