const node_num = 50 #Number of different diffusion coefficients (equal to rownumbers)
const mean_edges = 2 #Mean number of connections between microenvironments
const chan_len = 0.15 #Width of the connections
const ant_to_node = 25. #Antibiotic concentration for "attack"

#For the density simulator, the range of edge number
const edge_range = 150:1200

#Watts parameter for network rewiring
const watts_beta = 0.5

#Network types dictionary
const nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)
