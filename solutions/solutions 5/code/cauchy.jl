using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

M = 10^6
for rep = 1:5
    x = rand(Cauchy(0,1),M)
    MC = cumsum(x)./[1:M]
    
    figure(1,figsize=(10,4)); clf(); hold(true); grid(true)
    semilogx(1:M, MC)
    draw_now()
    savefig("cauchy$rep.png",dpi=120)
end


