#Function to build the connection matrix
function build_ccon(lane_num,col_num)
	con_matrix = Array{Float64}(lane_num,col_num)
	for i=1:lane_num
		for j=1:col_num
			if (i==j-1 || i==j+1)
				con_matrix[lane_num*(i-1)+j]=1
			else
				con_matrix[lane_num*(i-1)+j]=0.
			end
        end
    end
    return con_matrix
end

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



function iter_lane(con_mat)

    data = deepcopy(d0)
    n = length(data)
    
    for i in time
        #Reaction
            for j=1:n
            # Define time vector and interval grid for the continuous part.

            vec = data[j][end][2:end]
            (t_i,newdata) = ode23(f,vec,t)
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

###Analysis

function search_tast_SR(result,a_ast,lane_num,col_num)

    t_ast = Array{Float64}(lane_num,col_num) # time it takes to surpass A* [ant] (A* is the cutpoint for the res_strain to win)
    S_R = Array{Float64}(lane_num,col_num) #Rel_Freq(t) given t=24. Suceptible vs Resistant densities
    SR_t = Array{Float64}(lane_num,col_num) #Rel_Freq(t) given t
    
    #We search in lane
    for lane=1:lane_num
        #Into each well
        for well in 1:col_num
            suc = result[lane][well][end][2]
            res = result[lane][well][end][3]
            S_R[lane,well] = res/(res+suc)
            #We take the time when A(t) > t
            for t in eachindex(result[lane][well])
                if (result[lane][well][t][4]>a_ast)
                    t_ast[lane,well] = result[lane][well][t][1] 
                    SR_t[lane,well] = result[lane][well][t][3]/(result[lane][well][t][3]+result[lane][well][t][3])
                    break
                end
            if (t==length(result[lane][well]))
                    t_ast[lane,well] = -lane
                end
            end
        end
    end
        return (t_ast,S_R,SR_t)
end
