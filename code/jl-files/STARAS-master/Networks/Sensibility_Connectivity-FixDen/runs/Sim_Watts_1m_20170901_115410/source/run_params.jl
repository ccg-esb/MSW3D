const node_num = 50 #Number of different diffusion coefficients (equal to rownumbers)
const mean_edges = 4 #Mean number of connections between microenvironments
chan_width = 0.01:0.01:0.25 #Width of the connections
const ant_to_node = 40. #Antibiotic concentration for "attack"

#Watts parameter for network rewiring
const watts_beta = 0.3

#Network types dictionary
const nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)