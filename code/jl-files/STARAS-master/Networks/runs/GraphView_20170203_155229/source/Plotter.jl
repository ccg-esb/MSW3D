function plot_nwork(nw,res)
    sums = [sum([i["R"];i["S"]]) for i in res]
    max = maximum(sums)
    
    R_S = [ceil(Int32,100*i["S"]/i["R"]) for i in res]
    print(maximum(R_S))
    palette = colormap("RdBu",maximum(R_S))
    cols = [palette[i] for i in R_S]
    
    gplot(nw,nodesize = [i/max for i in sums], nodefillc = cols, nodestrokec= "Black")
    
end