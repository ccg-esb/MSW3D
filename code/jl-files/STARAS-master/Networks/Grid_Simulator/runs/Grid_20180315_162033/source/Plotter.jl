
function plot_grid(res,l::Int)
    top_space = 0.12
    right_space = 0
    
    n = Int(length(res)/l)
    sums = [j[1]+j[2] for j in res]
    max = maximum(sums)
    
#Circle colors
    Rel_Freq = [round(Int32,100*i[1]/(i[1]+i[2]))+1 for i in res]
    ratio_palette = colormap("RdBu",maximum(Rel_Freq)+1,mid=0.5)
    
    cols = [ratio_palette[i] for i in Rel_Freq]

#Circle positions
    x = [(1-right_space) * j/(n+1) for i=1:l for j=1:n]
    y = [(1-top_space) *i/(l+1) + top_space for i=1:l for j=1:n]

#Circle radius
    limiting_dimension = n > l ? n : l
    rad_normalizer = n > l ? (1-top_space) : (1-right_space)
    
    sums = sums / max   #We factorize the population total growth to maximum one
    longer = l>n ? l : n
    dist_fact = 3*longer/4 #Factor for controlling the distance between nodes
    rad  = rad_normalizer*[i/(limiting_dimension* dist_fact) for i in sums] #Now we determine de ratio aspect
    maxrad = maximum(rad)

#Connective rectangles
    chan_width = [i/(l-1) for i=0:(l-1)]
    
    rectx = x[[i*n+j for i=1:l-1 for j=1:n-1]] #Upper left corner x value
    recty = [y[i*n+j]- maxrad * chan_width[i+1] for i=1:l-1 for j=1:n-1] #Upper left corner y value
    hor_len = 1/(n+1)
    ver_len = 1/(l+1)
    rect_xlen = [hor_len for i=1:(l-1)*(n-1)] #Horizontal length
    rect_ylen = [2 * maxrad * chan_width[i] for i=2:l for j=1:n-1]  #Vertical length
    
    #colorbar
    x_s,colbar_y_0,indiv_widths,colbar_wid,cbar_cmap,annot_colbar = plot_horiz_cmap(0.6,5*top_space/6,0.2,top_space/2,"RdBu")
    
    #Colors
    ant_con = reshape([i[3] for i in res],(l,n))'
    ant_maxvector = [maximum(ant_con[i,:]) for i=1:l]
    ant_relcon = (ant_con ./ ant_maxvector) #We divide to get the relative antibiotic per lane.
    rect_colind = [ceil(Int32,100*(ant_relcon[i,j]+ant_relcon[i,j+1])/2+1) for i in 1:l, j in 1:(n-1)]
          
    ant_palette = colormap("Oranges",101)
    rect_cols = [ant_palette[i] for i in vec(rect_colind')]
    
    composition = compose(context(),
    (context(),circle(x, y,rad),fill(cols),linewidth(0.08),stroke("gray")),
    (context(),circle(x,y,[maxrad for i=1:l*n]),fill("white"),linewidth(0.1),stroke("black")),
    (context(),rectangle(rectx,recty,rect_xlen,rect_ylen),fill(rect_cols),linewidth(0.1), stroke("black")),
    (context(),rectangle(x_s,colbar_y_0,indiv_widths,colbar_wid),fill(cbar_cmap),linewidth(0),stroke("black")),
    (context(),text(annot_colbar...),fontsize(10pt),font("Helvetica")))
    
    
     draw(SVG(wpath*"/Images/Grid.svg", 12cm, 10cm), composition)
     compose(composition),ratio_palette
end

function plot_vert_cmap(x0::Float64,y0::Float64,len::Float64,width::Float64,colorname::String,n_colors=1000)
   
    colbar_len = len
    colbar_wid = width
    colbar_x_0 = x0
    colbar_y_0 = y0

    x_s = colbar_y_0 + [colbar_len*i/n_colors for i = 1:n_colors] 
    indiv_len = colbar_len + colbar_y_0 - x_s
    
    # color
    cbar_map = colormap(colorname,n_colors)
    
    # colorbar text
    colbar_title_x, colbar_title_y, colbar_title = (colbar_x_0 ,colbar_y_0 - 0.01,"Res. Rel. Freq.")
    colbar_low_x, colbar_low_y, colbar_low = (colbar_x_0 -0.02, colbar_y_0 + 0.6*colbar_wid ,"0")
    colbar_high_x, colbar_high_y, colbar_high = (colbar_x_0 + 0.01 + colbar_len,colbar_y_0 + 0.6*colbar_wid ,"1")

    annot_colbar = [[colbar_title_x,colbar_low_x,colbar_high_x],
        [colbar_title_y,colbar_low_y,colbar_high_y],
        [colbar_title,colbar_low,colbar_high]]

    return (x_s,[colbar_y_0],indiv_len,[colbar_wid],cbar_map[end:-1:1],annot_colbar)
end