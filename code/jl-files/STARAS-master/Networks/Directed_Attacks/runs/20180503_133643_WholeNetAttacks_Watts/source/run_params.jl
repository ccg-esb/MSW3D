const node_num = 50 #Number of different diffusion coefficients (equal to rownumbers)
const erdos_edges = 300 #Mean number of connections between microenvironments
const chan_len = 0.1 #Width of the connections
const ant_to_node = 50. #Antibiotic concentration for "attack"

#Watts parameter for network rewiring
const watts_beta = 0.5

#Network types dictionary
const nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)
