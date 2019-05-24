
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

function iter_node(data)
    xaxis_time, newdata = ode23s(update,data,t)
    
    return xaxis_time, newdata
end

function sim_node_wAnt(ant::Int)
    
    node_toiter = [5e5,5e5,ant,2000] 
    
    return(iter_node(node_toiter))
    
end

function sim_DR_node(maxAnt::Float64,step=0.01)
    finalVals_vec = []
    for i in 0:step:maxAnt
        node_toiter = [5e5,5e5,i,2000] 
        push!(finalVals_vec,[i,iter_node(node_toiter)[2][end]...])
    end
    return(finalVals_vec)
end