module Box

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

rand_uniform(a,b) = rand()*(b-a)+a

rand_box(a,c) = rand_uniform(max(0,a-c),min(1,a+c))
rand_u(v,c) = rand_uniform(abs(v),1-abs(v))
function rand_v(u,c)
    @assert(c<=1)
    if u<=c/2
        return rand_uniform(-u,u)
    elseif u<=1-c/2
        return rand_uniform(-c/2,c/2)
    else
        return rand_uniform(u-1,1-u)
    end
end

for c in [0.25,0.05,0.02]

    # Untransformed
    # Short run
    figure(1,figsize=(6.5,6)); clf(); hold(true)
    x,y = 0.5,0.5
    N = 50
    for i=1:N
        xn = rand_box(y,c)
        plot([x,xn],[y,y],"k-")
        yn = rand_box(xn,c)
        plot([xn,xn],[y,yn],"k-")
        plot(x,y,"ko",markersize=3)
        plot(xn,yn,"ko",markersize=3)
        x,y = xn,yn
    end
    xlim(0,1)
    ylim(0,1)
    xlabel("\$x\$",fontsize=16)
    ylabel("\$y\$",fontsize=16)
    draw_now()
    savefig("box-walk-c=$c.png",dpi=120)


    # Long run
    x,y = 0.5,0.5
    N = 10^3
    xr = zeros(N)
    yr = zeros(N)
    for i=1:N
        x = rand_box(y,c)
        y = rand_box(x,c)
        xr[i] = x
        yr[i] = y
    end

    figure(2,figsize=(6.5,6)); clf(); hold(true)
    subplots_adjust(bottom = 0.2)
    plot(xr,yr, "b.", markersize=3)
    xlim(0,1)
    ylim(0,1)
    xlabel("\$x\$",fontsize=16)
    ylabel("\$y\$",fontsize=16)
    draw_now()
    savefig("box-scatter-c=$c.png",dpi=120)

    figure(3,figsize=(10,3)); clf(); hold(true)
    subplots_adjust(bottom = 0.2)
    plot(xr, "k.", markersize=3)
    ylim(0,1)
    xlabel("iteration \$k\$",fontsize=14)
    ylabel("\$x\$",fontsize=16)
    draw_now()
    savefig("box-x_trace-c=$c.png",dpi=120)

    # Transformed

    # Long run
    u,v = 0.5,0.0
    N = 10^3
    xr = zeros(N)
    yr = zeros(N)
    for i = 1:N
        u = rand_u(v,c)
        v = rand_v(u,c)
        xr[i] = u + v
        yr[i] = u - v
    end

    figure(4,figsize=(6.5,6)); clf(); hold(true)
    subplots_adjust(bottom = 0.2)
    plot(xr,yr, "b.", markersize=3)
    xlim(0,1)
    ylim(0,1)
    xlabel("\$x\$",fontsize=16)
    ylabel("\$y\$",fontsize=16)
    draw_now()
    savefig("box-scatter-c=$c-transformed.png",dpi=120)

    figure(5,figsize=(10,3)); clf(); hold(true)
    subplots_adjust(bottom = 0.2)
    plot(xr, "k.", markersize=3)
    ylim(0,1)
    xlabel("iteration \$k\$",fontsize=14)
    ylabel("\$x\$",fontsize=16)
    draw_now()
    savefig("box-x_trace-c=$c-transformed.png",dpi=120)
end

end
