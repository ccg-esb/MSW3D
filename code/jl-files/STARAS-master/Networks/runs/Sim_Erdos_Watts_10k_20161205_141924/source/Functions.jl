
#Function to get data from the initial conditions vector
function get_data(node::node)
    B = node.B
    A = node.A 
    R = node.R 
    
    return [B...; A...; R]
end

#Declare data Array
function declare_darray(n0)
d0 = Array{Array{Array{Float64,1},1}}(length(n0))

    for i in eachindex(n0)
        d0[i] = copy(Any[[0.;get_data(n0[i])]])
    end
    
    return d0
end

function create_node(id)
    return node(id,[1e6,1e6],[0],2000,id/(node_num+1),0.5)
end

#Function to search the hub for inoculate there antibiotic.
function search_hub(con_mat)
    res = [1,1]
    for i =1:size(con_mat,1)
        
        sum = 0
        
        for j=1:size(con_mat,2)
            sum += con_mat[i,j]
        end
        
        if sum>res[2]
            res = [i,sum]
        end
    end
    return Int32(res[1])
end

function iter(d0,con_mat)

    data = deepcopy(d0)
    n = length(data)
    
    for i in time
        #Reaction
            for j=1:n
            # Define time vector and interval grid for the continuous part.

            vec = data[j][end][2:end]
            (t_i,newdata) = ode23(update,vec,t)
            append!(data[j],[[t_i[k]+i;newdata[k]] for k in 2:length(t_i)])
        end

        #Difussion
        temp = copy([data[m][end][4] for m=1:n])
        for k = 1:n-1
            for l = k+1:n
                data[k][end][4] += con_mat[k,l] * ant[1].delta * (temp[l] - temp[k])
                data[l][end][4] += con_mat[k,l] * ant[1].delta * (temp[k] - temp[l])
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
        if (sum([cosmos["S"];cosmos["R"]]) < 10^3)
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

#Function to connect all the components of a network
function connect_components(nwork)
    while length(connected_components(nwork)) > 1
        comp = connected_components(nwork)
        v1 = rand(comp[1])
        while degree(nwork)[v1] <= 1
            v1 = rand(comp[1])
        end

        v2 = rand(comp[2])
        
        rem_edge!(nwork,v1,rand(out_edges(nwork,v1))[2])
        add_edge!(nwork,v1,v2)
    end
end

#Functions to create and simulate networks
function create_nw(ntype::String,node_num::Int,mean_edges::Int,chan_len::Float64,ant_to_node::Float64,r=1)
    nwork = ntype == "erdos" ? nets[ntype](node_num, node_num*mean_edges) : nets[ntype](node_num,mean_edges*2,watts_beta)
        
    connect_components(nwork)
    
    nw_mat = adjacency_matrix(nwork)
    
    nw_mat = convert(Array{Float64},nw_mat) * chan_len
    nw_vert = [create_node(i) for i in nwork.vertices]
    
    chosen =  r == 0 ? search_hub(nw_mat) : rand(1:node_num) # Search for the most connected Or choose a random node
    nw_vert[chosen].A[1] = ant_to_node

    return nwork,nw_vert, nw_mat

end

function sim_network(vert,mat)
    d0 = declare_darray(vert)
    res = iter(d0,mat)

    return [Dict("S"=>i[end][2],"R"=>i[end][3]) for i in res]
end

function sim(ntype)
    nwork,nw_vert, nw_mat = create_nw(ntype,node_num,mean_edges,chan_len,ant_to_node)
    nw_res = sim_network(nw_vert,nw_mat)
    return push!(convert(Array{Float64},quantify_wins(nw_res)),nv(nwork),nwork.ne,global_clustering_coefficient(nwork))
end
