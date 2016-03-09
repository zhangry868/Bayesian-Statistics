
# Non-infected
x =[0
    0
    0
    0
    0
    0
    0
    0.001
    0.001
    0.001
    0.001
    0.001
    0.001
    0.001
    0.002
    0.002
    0.003
    0.003
    0.005
    0.009
    0.009
    0.01
    0.011
    0.016
    0.018
    0.02
    0.031
    0.036
    0.039
    0.043
    0.043
    0.047
    0.048
    0.048
    0.051
    0.055
    0.056		
    0.058		
    0.067
    0.067
    0.075
    0.081
    0.087
    0.095
    0.112
    0.119
    0.119
    0.129
    0.14
    0.14
    0.144
    0.159
    0.164
    0.169
    0.18
    0.183
    0.184
    0.192
    0.194
    0.21
    0.216
    0.216
    0.222
    0.222
    0.229	
    0.233	
    0.233	
    0.248	
    0.294	
    0.318	
    0.341	
    0.401	
    0.431	
    0.482	
    0.696]

# Infected
y =[0.254
    0.364
    0.49
    0.509
    0.65
    0.702
    0.716
    0.743
    0.752
    0.879
    0.899
    0.927
    0.937
    1.057
    1.064
    1.081
    1.116
    1.263
    1.346
    1.402
    1.665
    1.698
    1.799
    1.801
    1.934]

using PyPlot
function draw_now(number = 0)
    if number>0; figure(number); end
    pause(0.001) # this forces the figure to update (draw() is supposed to do this, but doesn't work for me)
    get_current_fig_manager()[:window][:raise_]() # bring figure window to the front
end

x = max(x,minimum(x[x.>0]))

figure(1); clf(); hold(true)
plt.hist(log(x),25)
draw_now()

figure(2); clf(); hold(true)
plt.hist(log(y),25)
draw_now()


nothing


