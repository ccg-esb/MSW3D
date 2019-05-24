
#Function to get data from the initial conditions vector
function get_data(node::node)
    B = node.B
    A = node.A 
    R = node.R 
    
    return [B...; A; R]
end

#Declare data Array
function declare_darray(n0::Array{node,1})
d0 = Array{Array{Float64,1},1}(length(n0))

    for i in eachindex(n0)
        d0[i] = get_data(n0[i])
    end
    
    return d0
end

function create_node(id)
    return node(id,[5e5,5e5],0,2000)
end

function iter(d0,con_mat)

    data = deepcopy(d0)
    n = length(data)
    lane_plot = plot_lane(data)
    draw(SVG("Images/Time_Lapse/Lane_$(nnum)nodes_$(ant_to_node)ant2node_t00.svg", 16cm, 6cm), lane_plot)
    
    for i in time
        #Reaction
            for j=1:n
            # Define time vector and interval grid for the continuous part.
            
            vec = data[j]
            newdata = ode23(update,vec,t)
            data[j] = copy(newdata[2][end])
        end

        #Difussion
        temp = copy([data[m][3] for m=1:n])
        for k = 1:n-1
            for l = k+1:n
                data[k][3] += con_mat[k,l] * ant.delta * (temp[l] - temp[k])
                data[l][3] += con_mat[k,l] * ant.delta * (temp[k] - temp[l])
            end
        end
        lane_plot = plot_lane(data)
        draw(SVG("Images/Time_Lapse/Lane_$(nnum)nodes_$(ant_to_node)ant2node_t$(i+0.2).svg", 16cm, 6cm), lane_plot)
    end
    return data
end

function create_lane(n::Int)
    con_mat  = zeros(n,n)
    for i=1:n
        if i>1 && i<n
            x = [i-1,i+1]
            con_mat[i,x] = chan_width
            elseif (i==1)
                con_mat[i,2] = chan_width
            else
                con_mat[i,end-1] = chan_width
        end
    end
    
    lane = [create_node(i) for i=1:n]
    
    #Inoculate first node with antibiotic
    lane[1].A = ant_to_node
    
    return lane, con_mat
end