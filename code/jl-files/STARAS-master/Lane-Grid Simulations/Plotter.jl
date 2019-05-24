#Color palette
function plot_r(data,dir,lanename)
    n = length(data)

    #Normalize time
    x = [[j[1] for j in data[i]] for i in 1:n]    

    #Resource
    r = [[data[i][j][5] for j in eachindex(x[i])] for i=1:n]


    #Make the layers
    ly = [layer(x=x[i], y=r[i],Geom.line) for i in eachindex(data)]

    #Plot and add layers
    p = plot(ly[2], Guide.xlabel("Time"),Guide.ylabel("Resource Concentration"))

    for i in 3:n
        append!(p.layers, ly[i]);
    end
    display(p)
    draw(SVGJS(string(dir,"source_",lanename,".svg"),10inch, 15inch),p)
end


function plot_a(data,dir,lanename)
    n = length(data)

    #Normalize time
    x = [[j[1] for j in data[i]] for i in 1:n]
    # Antibiotic
    a = [[data[i][j][4] for j in eachindex(x[i])] for i=1:n]

    #Make the layers
    ly = [layer(x=x[i], y=a[i], Geom.smooth,Theme(default_color=cols[100-(i-2)*20])) for i=2:n]

    #Plot and add layers
    p = plot(ly[1], Guide.xlabel("Time"), Guide.ylabel("Antibiotic Concentration"),
    Guide.manual_color_key("Distance from Antibiotic Source",
        ["$(i-1)" for i in 2:n],
        [cols[100-(i-2)*20] for i=2:n])) 

    [append!(p.layers, ly[i]) for i in 2:n-1]
    
    display(p)
    draw(SVGJS(string(dir,"ant_",lanename,".svg"),10inch, 15inch),p)
end

function plot_b(data,dir,lanename)
    n = length(data)

    #Normalize time
    x = [[j[1] for j in data[i]] for i in 1:n]
    
    #Bacteria
    bs = [[data[i][j][2] for j in eachindex(x[i])] for i=1:n]
    br = [[data[i][j][3] for j in eachindex(x[i])] for i=1:n]


    pl = [plot(layer(x=x[i], y=bs[i],Geom.line,Theme(default_color=colorant"blue")),
        layer(x=x[i], y=br[i], Geom.line, Theme(default_color=colorant"red"))) for i=2:n]

    draw(SVGJS(10inch, 15inch),vstack(pl))
    draw(SVGJS(string(dir,"bact_",lanename,".svg"),10inch, 15inch),vstack(pl))
end