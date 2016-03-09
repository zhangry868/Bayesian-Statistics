
module Figures

using PyPlot

gampdf(x,a,b) = exp(a*log(b)-lgamma(a)+(a-1)*log(x)-b*x)


figure(1); clf(); hold(true)
x = linspace(0.1,20,500)
for (a,b,color) in [(0.5,0.5,"b"),(1,0.1,"r"),(5,1,"g"),(25,2,"y")]
    plot(x,gampdf(x,a,b),color)
end
ylim(0,0.4)

mu = 20
sigma = 8
b = mu/sigma^2
a = mu*b
println("a = $a")
println("b = $b")

figure(2); clf(); hold(true)
x = linspace(0.1,50,500)
plot(x,gampdf(x,a,b))

y = [16, 10, 22, 14, 19, 18]
n = length(y)
A = a+sum(y)
B = b+n

figure(3); clf(); hold(true)
x = linspace(0.1,50,500)
plot(x,gampdf(x,a,b),"b")
plot(x,gampdf(x,A,B),"r")
title("Prior and posterior density of theta")
ylabel("density")
xlabel("pizzas/hour")
legend(["prior","posterior"])

using Distributions

q1 = quantile(Gamma(A,1/B),0.025)
q2 = quantile(Gamma(A,1/B),0.975)
println("Interval: [$q1,$q2]")

figure(4); clf(); hold(true)
x = linspace(10,28,500)
plot(x,gampdf(x,A,B))
plot([q1,q1],[0,0.25],"g")
plot([q2,q2],[0,0.25],"g")


f(y) = exp(lgamma(A+y)-lgamma(y+1)-lgamma(A) + A*log(B/(B+1)) - y*log(B+1))
figure(5); clf(); hold(true)
x = 0:30
plot(x,[f(y) for y in x],"ro-")

L(d,y) = 14*d + 20*max(y-6*d,0)
R(d) = sum([L(d,y)*f(y) for y = 0:1000])

figure(6) #; clf(); hold(true)
ds = 0:20
plot(ds,[R(d) for d in ds],"bo-")
title("Bayes risk for pizza problem")
xlabel("d  (# of deliverers")
ylabel("R(d)  (dollars/hour)")



end # module




