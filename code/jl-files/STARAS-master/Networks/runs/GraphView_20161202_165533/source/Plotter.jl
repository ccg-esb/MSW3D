using Compose
using Colors

function p_plate(final_data,nodes)
    sums = [sum([i["S"];i["R"]]) for i in final_data]
    max = maximum(sums)
    x0 = [i.x for i in nodes]
    y0 = [i.y for i in nodes]
    rad = [i/max for i in sums]
    
    palette = colormap("RdBu",200)
    R_S = [ceil(Int32,100*i["S"]/i["R"]) for i in final_data]

    #Truncate outliers
    for i in R_S
        if i>200
            print("entra")
            i=200
        end
    end
    
    cols = [palette[i] for i in R_S]
    
    composition = compose(context(), circle(x0, y0, rad * 0.025), fill([palette[i] for i in R_S]),linewidth(0.1mm), stroke("black"),) #0.001 for normalize to the display
    
    display(composition)
end

function plot_nwork(nw,res)
    sums = [sum([i["R"];i["S"]]) for i in res]
    max = maximum(sums)
    
    R_S = [ceil(Int32,100*i["S"]/i["R"]) for i in res]
    
    palette = colormap("RdBu",200)
    cols = [palette[i] for i in R_S]
    
    gplot(nw,nodesize = [i/max for i in sums], nodefillc = cols)
    
end