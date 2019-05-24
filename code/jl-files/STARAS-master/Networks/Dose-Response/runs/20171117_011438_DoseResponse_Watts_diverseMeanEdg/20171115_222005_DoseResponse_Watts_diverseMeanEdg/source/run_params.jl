const node_num = 50 #Number of different diffusion coefficients (equal to rownumbers)
#const mean_edges_vector = [1,2,3,4,5]#Mean number of connections between microenvironments
const chan_len = 0.2 #Width of the connections
#const ant_to_node = 40. #Antibiotic concentration for "attack"
ant_range = 0.:1:800

#Watts parameter for network rewiring
const watts_beta = 0.5

#Network types dictionary
const nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)