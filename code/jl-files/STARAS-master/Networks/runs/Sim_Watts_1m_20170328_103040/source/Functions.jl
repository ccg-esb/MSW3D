
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
    return node(id,[1e6,1e6],0,2000)
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

function create_nw(ntype::String,node_num::Int,mean_edges::Int,chan_len::Float64,ant_to_node::Float64,r=1)
    nwork = ntype == "erdos" ? nets[ntype](node_num, node_num*mean_edges) : nets[ntype](node_num,mean_edges*2,watts_beta)
    
    connect_components(nwork)
    
    nw_mat = convert(Array{Float64},adjacency_matrix(nwork)) * chan_len
    nw_vert = [create_node(i) for i in nwork.vertices]
    
    chosen =  r == 0 ? search_hub(nw_mat) : rand(1:node_num) # Search for the most connected Or choose a random node
    nw_vert[chosen].A = ant_to_node

    return nwork,nw_vert, nw_mat

end

function sim_network(vert,mat)
    res = iter(declare_darray(vert),mat)

    return [Dict("S"=>i[1],"R"=>i[2]) for i in res]
end

function sim(ntype::String)
    nwork,nw_vert, nw_mat = create_nw(ntype,node_num,mean_edges,chan_len,ant_to_node)
    nw_res = sim_network(nw_vert,nw_mat)
    return  push!([sum([i["S"] for i in nw_res])], sum([i["R"] for i in nw_res]), quantify_wins(nw_res)..., density(nwork), global_clustering_coefficient(nwork))
end
    
function nsim_watts(n::Int64)
    for i=1:n
        for j in sim("watts")
            print("$j\t")
        end
        print("\n")
    end
end

function nsim_erdos(n::Int64)
    for i=1:n
        for j in sim("erdos")
            print("$j\t")
        end
        print("\n")
    end
end