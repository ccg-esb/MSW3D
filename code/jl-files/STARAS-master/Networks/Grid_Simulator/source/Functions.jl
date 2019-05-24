
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
    
    for i in time
        #Reaction
            for j=1:n
            # Define time vector and interval grid for the continuous part.
            
            vec = data[j]
            newdata = ode23s(update,vec,t)
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

    end
    return data
end

function quantify_wins(data)
    S = 0
    R = 0
    None = 0
    for cosmos in data
        if (sum([cosmos["S"];cosmos["R"]]) < 10^4)
            None += 1
        elseif cosmos["S"]<cosmos["R"]
                R += 1
        elseif cosmos["S"]>cosmos["R"]
                S += 1
        end
    end
    
    #Checamos que todos haya entrado.
    if sum([S,R,None]) != length(data)
            print("equal")
    end
    
    return [S,R,None]
end

#Not used
function evaluate(data)
    
    winner = "T"
    
    if data[1] > data[2]
        winner = "S"
    elseif data[2] > data[1]
        winner = "R"
    end
    
    return winner
end

function create_grid(l::Int,n::Int)
    con_mat  = zeros(l*n,l*n)
    for j=0:l-1
        chan_width = j/(l-1)
        for i=1:n
            d=j*l+i
            if i%n>1
                x = [d-1,d+1]
                con_mat[d,x] = chan_width
            elseif (i==1)
                con_mat[d,d+1] = chan_width
            else
                con_mat[d,d-1] = chan_width
            end
        end
    end
    
    grid = [create_node(i) for i=1:n*l]
    
    #Inoculate first node with antibiotic
    
    for i=0:l-1
        grid[i*n+1].A = ant_to_node
    end
    
    return grid,con_mat
end