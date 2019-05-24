
function plot_lane(res)
    n = length(res)
    sums = [i[1]+i[2] for i in res]
    max = maximum(sums)
    
#Circle colors
    R_S = [ceil(Int32,100*i[1]/(i[1]+i[2]))+1 for i in res]
    ratio_palette = colormap("RdBu",101,mid=0.5)
    cols = [ratio_palette[i] for i in R_S]

#Circle positions
    x = [i/(n+1) for i=1:n]
    y = [0.5 * (1-top_space) + top_space for i=1:n]

#Circle radius
    sums = sums / maximum(sums)     #We factorize the population total growth to maximum one
    dist_fact = 2.5 #Factor for controlling the distance between nodes
    rad  = sums/(dist_fact*(n+1)) #Now we determine de ratio aspect
    maxrad = maximum(rad)

#Connective rectangles
rectx = x[1:end-1] #Upper left corner x value
recty = y[1:end-1]- maxrad * chan_width #Upper left corner y value
rect_xlen = repmat([x[2]-x[1]],n-1) #Horizontal length
rect_ylen = repmat([2*maxrad],n-1) * chan_width #Vertical length

#Colors
ant_con = [i[3] for i in res]
ant_relcon = [i/maximum(ant_con) for i in ant_con]
ant_palette = colormap("Greens",50)
rect_colind = [ceil(Int32,50*(ant_relcon[i]+ant_relcon[i-1])/2)+1 for i=2:n]
rect_cols = [ant_palette[i] for i in rect_colind]

#annotations
x_s1,colbar_y_01,indiv_widths1,colbar_wid1,cbar_cmap1,annot_colbar1 = plot_horiz_cmap(0.15,0.4,0.3,top_space/5,"RdBu","Res. Rel. Freq.")
    
x_s2,colbar_y_02,indiv_widths2,colbar_wid2,cbar_cmap2,annot_colbar2 = plot_horiz_cmap(0.55,0.4,0.3,top_space/5,"Greens","Antibiotic")
    
compose(context(),
    (context(),circle(x, y,rad),fill(cols),linewidth(0.08),stroke("gray")),
    (context(),circle(x,y,repmat([maxrad],n)),fill("white"),linewidth(0.1),stroke("black")),
    (context(),rectangle(rectx,recty,rect_xlen,rect_ylen),fill(rect_cols),linewidth(0.1), stroke("black")),
    (context(),rectangle(x_s1,colbar_y_01,colbar_wid1,indiv_widths1),fill(reverse(cbar_cmap1)),linewidth(0)),
    (context(),rectangle(x_s2,colbar_y_02,colbar_wid2,indiv_widths2),fill(cbar_cmap2),linewidth(0)),
    (context(),text(annot_colbar1...),fontsize(15pt),font("Helvetica")),
    (context(),text(annot_colbar2...),fontsize(15pt),font("Helvetica")))
    
end

function plot_horiz_cmap(x0::Float64,y0::Float64,len::Float64,width::Float64,colorname::String,varname::String,n_colors=100)
   
    colbar_len = len
    colbar_wid = width
    colbar_x_0 = x0
    colbar_y_0 = y0

    x0_s = colbar_x_0 + [colbar_len*i/n_colors for i = 1:n_colors] 
    indiv_len = colbar_len + colbar_x_0 - x0_s
    
    # color
    cbar_map = colormap(colorname,n_colors)
    
    # colorbar text
    colbar_title_x, colbar_title_y, colbar_title = (colbar_x_0 +0.0015 * 4 * (20-length(varname)) ,colbar_y_0 -0.03,varname)
    colbar_low_x, colbar_low_y, colbar_low = (colbar_x_0 - 0.03, colbar_y_0+0.1 ,"0")
    colbar_high_x, colbar_high_y, colbar_high = (colbar_x_0 + 0.01 + colbar_len ,colbar_y_0+0.1,"1")
5
    annot_colbar = [[colbar_title_x,colbar_low_x,colbar_high_x],
        [colbar_title_y,colbar_low_y,colbar_high_y],
        [colbar_title,colbar_low,colbar_high]]

    return (x0_s,[colbar_y_0],[colbar_wid],indiv_len,cbar_map,annot_colbar)
end