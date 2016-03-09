module Snow

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Aomori
x = [188.6, 244.9, 255.9, 329.1, 244.5, 167.7, 298.4, 274.0, 241.3, 288.2, 208.3, 311.4, 273.2, 395.3, 353.5, 365.7, 420.5, 303.1, 183.9, 229.9, 359.1, 355.5, 294.5, 423.6, 339.8, 210.2, 318.5, 320.1, 366.5, 305.9, 434.3, 382.3, 497.2, 319.3, 398.0, 183.9, 201.6, 240.6, 209.4, 174.4, 279.5, 278.7, 301.6, 196.9, 224.0, 406.7, 300.4, 404.3, 284.3, 312.6, 203.9, 410.6, 233.1, 131.9, 167.7, 174.8, 205.1, 251.6, 299.6, 274.4, 248.0]
# Valdez
y = [351.0, 379.3, 196.1, 312.3, 301.4, 240.6, 257.6, 304.5, 296.0, 338.8, 299.9, 384.7, 353.5, 312.8, 550.7, 327.1, 515.8, 343.4, 341.6, 396.9, 267.3, 230.6, 277.4, 341.0, 377.0, 391.3, 337.0, 250.4, 353.7, 307.7, 237.5, 275.2, 271.4, 266.5, 318.7, 215.5, 438.3, 404.6]

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

for (rep,(m,c,a,s)) in enumerate([(200,1,1/2,80),
                                  (500,1,1/2,80),
                                  (200,1,1/2,20),
                                  (200,1,10/2,80)])
    b = s^2*a
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
    bar(bins-8,cx,8,color="b",label="Aomori")
    bar(bins,cy,8,color="r",label="Valdez")
    xlabel("Annual snowfall (inches)",fontsize=14)
    ylabel("count (years)",fontsize=14)
    subplots_adjust(bottom = 0.2)
    xticks(bins[1:2:end])
    xlim(0,600)
    ylim(0,10)
    legend(numpoints=1,loc=5,labelspacing=0.1,fontsize=15)
    draw_now()
    savefig("snow-histogram-$rep.png",dpi=120)

    # Scatterplot of prior
    N = 500
    mu,lambda = NormalGamma_sample(N,m,c,a,b)
    figure(2,figsize=(10,4)); clf(); hold(true)
    plot(mu,1.0./sqrt(lambda),"go",markersize=3,markeredgecolor="g")
    xlabel("\$\\mu\$  (Mean annual snowfall)",fontsize=14)
    ylabel("\$\\lambda^{-1/2}\$  (st.dev.)",fontsize=14)
    subplots_adjust(bottom = 0.2)
    xticks(bins[1:2:end])d
    xlim(0,maximum(bins))
    ylim(0,500)
    grid(true)
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
    legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15,markerscale=2)
    draw_now()
    savefig("snow-posteriors-$rep.png",dpi=120)

    # Compute posterior quantities
    N = 10^6
    mu_x,lambda_x = NormalGamma_sample(N,Mx,Cx,Ax,Bx)
    mu_y,lambda_y = NormalGamma_sample(N,My,Cy,Ay,By)

    println("=====================================================")
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
end

end


