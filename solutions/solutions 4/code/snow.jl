module Snow

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

x = vec(readdlm("aomori.dat"))  # cm/year (1954 - 2014)
x = 0.393701*x # convert to inches
y = vec(readdlm("valdez.dat"))  # tenths of inches/year (1976 - 2013)
y = 0.1*y # convert to inches

for (rep,(m,c,a,s)) in enumerate([(200,1,1/2,80),
                                  (500,1,1/2,80),
                                  (200,1,1/2,20),
                                  (200,1,10/2,80)])
    b = s^2*a
                                 
    function NormalGamma_posterior(x,m,c,a,b)
        mx = mean(x)
        vx = mean((x-mx).^2)
        n = length(x)
        C = c + n
        A = a + n/2
        M = (c*m + n*mx)/C
        B = b + 0.5*n*vx + 0.5*(c*n/C)*(mx-m)^2
        return M,C,A,B,mx,vx
    end

    function NormalGamma_sample(n,m,c,a,b)
        lambda = rand(Gamma(a,1/b),n)
        mu = rand(Normal(0,1),n)./sqrt(c*lambda) + m
        return (mu,lambda)
    end

    Mx,Cx,Ax,Bx,mx,vx = NormalGamma_posterior(x,m,c,a,b)
    My,Cy,Ay,By,my,vy = NormalGamma_posterior(y,m,c,a,b)
    sx,sy = sqrt(vx),sqrt(vy)


    lower,upper = -12.5,612.5

    # Histograms
    figure(1,figsize=(10,4)); clf(); hold(true); grid(true)
    edges = lower:25:upper
    edges,cx = hist(x,edges)
    edges,cy = hist(y,edges)
    bins = midpoints(edges)
    # plot(midpoints(edges),cx,"bo-",label="Aomori",linewidth=2)
    # plot(midpoints(edges),cy,"ro-",label="Valdez",linewidth=2)
    bar(bins-8,cx,8,color="b",label="Aomori")
    bar(bins,cy,8,color="r",label="Valdez")
    xlabel("Annual snowfall (inches)",fontsize=14)
    ylabel("count (years)",fontsize=14)
    subplots_adjust(bottom = 0.2)
    xticks(bins[1:2:end])
    xlim(0,600)
    ylim(0,10)
    legend(numpoints=1,loc=5,labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
    # tick_params(axis="x",direction="out",top="off")
    draw_now()
    savefig("snow-histogram-$rep.png",dpi=120)



    # Scatterplot of prior
    N = 500
    mu,lambda = NormalGamma_sample(N,m,c,a,b)
    figure(2,figsize=(10,4)); clf(); hold(true)
    plot(mu,1.0./sqrt(lambda),"go",markersize=3,markeredgecolor="g")
    xlabel("\$\\mu\$  (Mean annual snowfall)",fontsize=14)
    ylabel("\$\\lambda^{-1/2}\$  (std.dev.)",fontsize=14)
    subplots_adjust(bottom = 0.2)
    xticks(bins[1:2:end])
    xlim(0,maximum(bins))
    ylim(0,500)
    grid(true)
    # legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15,markerscale=2) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
    # tick_params(axis="x",direction="out",top="off")
    draw_now()
    savefig("snow-prior-$rep.png",dpi=120)

    # Scatterplots of posterior
    N = 200
    mu_x,lambda_x = NormalGamma_sample(N,Mx,Cx,Ax,Bx)
    mu_y,lambda_y = NormalGamma_sample(N,My,Cy,Ay,By)
    figure(3,figsize=(10,4)); clf(); hold(true)
    plot(mu_x,1.0./sqrt(lambda_x),"r^",label="Aomori",markersize=3,markeredgecolor="r")
    plot(mu_y,1.0./sqrt(lambda_y),"bo",label="Valdez",markersize=3,markeredgecolor="b")
    xlabel("\$\\mu\$  (Mean annual snowfall)",fontsize=14)
    ylabel("\$\\lambda^{-1/2}\$  (std.dev.)",fontsize=14)
    subplots_adjust(bottom = 0.2)
    xticks(bins[1:2:end])
    xlim(0,maximum(bins))
    ylim(0,140)
    grid(true)
    legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15,markerscale=2) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
    # tick_params(axis="x",direction="out",top="off")
    draw_now()
    savefig("snow-posteriors-$rep.png",dpi=120)


    # Compute posterior quantities
    N = 10^6
    mu_x,lambda_x = NormalGamma_sample(N,Mx,Cx,Ax,Bx)
    mu_y,lambda_y = NormalGamma_sample(N,My,Cy,Ay,By)

    # println("x = ")
    # for xi in x; @printf("%.1f, \n",xi); end
    # println()

    # println("y = ")
    # for yi in y; @printf("%.1f, \n",yi); end
    # println()

    println("Prior parameters:")
    println("prior: m,c,a,b = $m, $c, $a, $b")
    println()
    println("Summary statistics:")
    println("n(x) = ",length(x))
    println("n(y) = ",length(y))
    println("mean(x) = ",mx)
    println("mean(y) = ",my)
    println("std(x) = ",sx)
    println("std(y) = ",sy)
    println("posterior_x: M,C,A,B = $Mx, $Cx, $Ax, $Bx")
    println("posterior_y: M,C,A,B = $My, $Cy, $Ay, $By")
    println()
    println("P(mu_x > mu_y | data) = ",mean(mu_x.>mu_y))
    println("P(mu_x < mu_y | data) = ",mean(mu_x.<mu_y))
    println()
    println("P(sigma_x > sigma_y | data) = ",mean(lambda_x.<lambda_y))
    println()
end

end


