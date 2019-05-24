
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
    return Int64(res[1])
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
        if (sum([cosmos["S"];cosmos["R"]]) < cutoff_value)
            None += 1
        elseif cosmos["S"]<cosmos["R"]
                R += 1
        elseif cosmos["S"]>cosmos["R"]
                S += 1
        end
    end
    
    if sum([S,R,None]) != length(data)
            print("equal")
    end
    
    return [S,R,None] / node_num
end

#Create network with no antibiotic using a motif from the dictionary
function create_nw(ntype::String, node_num::Int, chan_len::Float64, ant_to_node::Float64)
    nwork = nets[ntype](node_num)
    
    nw_mat = convert(Array{Float64},adjacency_matrix(nwork)) * chan_len
    nw_vert = [create_node(i) for i in nwork.vertices]
  
    return nwork,nw_vert, nw_mat

end

function sim_network(vert,mat)
    res = iter(declare_darray(vert),mat)

    return [Dict("S"=>i[1],"R"=>i[2]) for i in res]
end

function single_attack(nwork::LightGraphs.Graph,nw_vert_empty::Array{node,1}, nw_mat::Array{Float64,2},chosen::Int64,ant_to_node::Float64)
    
    nw_vert_tmp = nw_vert_empty
    nw_vert_tmp[chosen].A = ant_to_node
    nw_res = sim_network(nw_vert_tmp,nw_mat)
    return push!([sum([i["S"]+i["R"] for i in nw_res])]/node_num,sum([i["S"] for i in nw_res]), sum([i["R"] for i in nw_res]), quantify_wins(nw_res)..., density(nwork), global_clustering_coefficient(nwork), closeness_centrality(nwork)[chosen], degree(nwork,chosen), betweenness_centrality(nwork)[chosen],ant_to_node)
end
    
function sim_attacks(ntype::String,ant_to_node::Float64)
    nwork,nw_vert, nw_mat = create_nw(ntype,node_num,chan_len,ant_to_node)
    result_vector = single_attack(nwork,deepcopy(nw_vert),nw_mat,rand(1:length(nw_vert)),ant_to_node)
        
    return result_vector
end

function sim_motif_network(reps::Int64,ntype::String)
    for i =1:reps
        for ant_con in ant_range
            for j in sim_attacks(ntype,ant_con)
                 print(j,"\t")
            end
            print("\n")
        end
    end
end