
function plot_grid(res,l::Int)
    top_space = 0
    right_space = 0.1
    
    n = Int(length(res)/l)
    sums = [j[1]+j[2] for j in res]
    max = maximum(sums)
    
#Circle colors
    Rel_Freq = [round(Int32,100*i[1]/(i[1]+i[2]))+1 for i in res]
    ratio_palette = colormap("RdBu",100+1,mid=0.5)
    
    cols = [ratio_palette[i] for i in Rel_Freq]

#Circle positions
    x = [(1-right_space) * j/(n+0.5) for i=1:l for j=1:n]
    y = [(1-top_space) *i/(l+0.5) + top_space for i=1:l for j=1:n]

#Circle radius
    limiting_dimension = n > l ? n : l
    rad_normalizer = n > l ? (1-top_space) : (1-right_space)
    
    sums = sums / max   #We factorize the population total growth to maximum one
    longer = l>n ? l : n
    dist_fact = longer*(5/8) #Factor for controlling the distance between nodes
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
    x_s1,colbar_y_01,indiv_widths1,colbar_wid1,cbar_cmap1,annot_colbar1 = plot_vert_cmap(1-right_space*(3/4),0.2,0.2,right_space/3,"RdBu","SRF")
    x_s2,colbar_y_02,indiv_widths2,colbar_wid2,cbar_cmap2,annot_colbar2 = plot_vert_cmap(1-right_space*(3/4),0.6,0.2,right_space/3,"Greens","ANT")
    
    #Colors
    ant_con = reshape([i[3] for i in res],(l,n))'
    ant_maxvector = [maximum(ant_con[i,:]) for i=1:l]
    ant_relcon = (ant_con ./ ant_maxvector) #We divide to get the relative antibiotic per lane.
    rect_colind = [ceil(Int32,100*(ant_relcon[i,j]+ant_relcon[i,j+1])/2+1) for i in 1:l, j in 1:(n-1)]
          
    ant_palette = colormap("Greens",101)
    rect_cols = [ant_palette[i] for i in vec(rect_colind')]
    
    composition = compose(context(),
    (context(),circle(x, y,rad),fill(cols),linewidth(0.08),stroke("gray")),
    (context(),circle(x,y,[maxrad for i=1:l*n]),fill("white"),linewidth(0.1),stroke("black")),
    (context(),rectangle(rectx,recty,rect_xlen,rect_ylen),fill(rect_cols),linewidth(0.1), stroke("black")),
    (context(),rectangle(x_s1,colbar_y_01,indiv_widths1,colbar_wid1),fill(cbar_cmap1),linewidth(0)),
    (context(),rectangle(x_s1,colbar_y_02,indiv_widths2,colbar_wid2),fill(cbar_cmap2),linewidth(0)),
    (context(),text(annot_colbar1...),fontsize(18pt),font("Helvetica")),
    (context(),text(annot_colbar2...),fontsize(18pt),font("Helvetica")))
    
    
     draw(SVG(wpath*"/Images/Grid.svg", 12cm, 10cm), composition)
     compose(composition),ratio_palette
end

function plot_vert_cmap(x0::Float64,y0::Float64,len::Float64,width::Float64,colorname::String,varname::String,n_colors=1000)
   
    colbar_len = len
    colbar_wid = width
    colbar_x_0 = x0
    colbar_y_0 = y0

    y0_s = colbar_y_0 + [colbar_len*i/n_colors for i = 1:n_colors] 
    indiv_len = colbar_len + colbar_y_0 - y0_s
    
    # color
    cbar_map = colormap(colorname,n_colors)
    
    # colorbar text
    colbar_title_x, colbar_title_y, colbar_title = (colbar_x_0 -0.0015 * (4-length(varname)) ,colbar_y_0 - 0.03,varname)
    colbar_low_x, colbar_low_y, colbar_low = (colbar_x_0 + 0.01, colbar_y_0 + colbar_len + 0.03 ,"0")
    colbar_high_x, colbar_high_y, colbar_high = (colbar_x_0 + 0.01,colbar_y_0 - 0.005  ,"1")
5
    annot_colbar = [[colbar_title_x,colbar_low_x,colbar_high_x],
        [colbar_title_y,colbar_low_y,colbar_high_y],
        [colbar_title,colbar_low,colbar_high]]

    return ([colbar_x_0],y0_s,[colbar_wid],indiv_len,cbar_map[end:-1:1],annot_colbar)
end