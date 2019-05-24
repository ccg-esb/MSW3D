
function plot_grid(res,l::Int)
    n = Int(length(res)/l)
    sums = [j[1]+j[2] for j in res]
    max = maximum(sums)
    
#Circle colors
    S_R = [round(Int32,100*i[1]/(i[1]+i[2]))+1 for i in res]
    println(S_R)
    ratio_palette = colormap("RdBu",maximum(S_R)+1,mid=0.5)
    
    cols = [ratio_palette[i] for i in S_R]

#Circle positions
    x = [j/(n+1) for i=1:l for j=1:n]
    y = [i/(l+1) for i=1:l for j=1:n]

#Circle radius
    sums = sums / max   #We factorize the population total growth to maximum one
    longer = l>n ? l : n
    dist_fact = longer/2 #Factor for controlling the distance between nodes
    rad  = [i/(dist_fact*(longer+1)) for i in sums] #Now we determine de ratio aspect
    maxrad = maximum(rad)

#Connective rectangles
    chan_width = [i/(l-1) for i=0:(l-1)]
    
    rectx = x[[i*n+j for i=1:l-1 for j=1:n-1]] #Upper left corner x value
    recty = [y[i*n+j]- maxrad * chan_width[i+1] for i=1:l-1 for j=1:n-1] #Upper left corner y value
    hor_len = 1/(n+1)
    ver_len = 1/(l+1)
    rect_xlen = [hor_len for i=1:(l-1)*(n-1)] #Horizontal length
    rect_ylen = [2 * maxrad * chan_width[i] for i=2:l for j=1:n-1]  #Vertical length

    #Colors
    ant_con = reshape([i[3] for i in res],(l,n))'
    #println(ant_con)
    ant_maxvector = [maximum(ant_con[i,:]) for i=1:l]
    #println(ant_maxvector)
    ant_relcon = (ant_con ./ ant_maxvector) #We divide to get the relative antibiotic per lane.
    #println(ant_relcon)
    rect_colind = [ceil(Int32,100*(ant_relcon[i,j]+ant_relcon[i,j+1])/2+1) for i in 1:l, j in 1:(n-1)]
    
    #Check for negative values
            
    ant_palette = colormap("Oranges",101)
    #print(rect_colind)
    rect_cols = [ant_palette[i] for i in vec(rect_colind')]
    composition = compose(context(),
    (context(),circle(x, y,rad),fill(cols),linewidth(0.08),stroke("gray")),
    (context(),circle(x,y,[maxrad for i=1:l*n]),fill("white"),linewidth(0.1),stroke("black")),
    (context(),rectangle(rectx,recty,rect_xlen,rect_ylen),fill(rect_cols),linewidth(0.1), stroke("black")))
    
     draw(SVG(wpath*"/Images/Grid.svg", 12cm, 10cm), composition)
     compose(composition),ratio_palette
end