const node_num = 50 #Number of different diffusion coefficients (equal to rownumbers)
const mean_edges = 3 #Mean number of connections between microenvironments
const chan_len = 0.2 #Width of the connections
const ant_to_node = 28. #Antibiotic concentration for "attack"

#For the density simulator, the range of edge number
const BactDen_range = 1:100

#Watts parameter for network rewiring
const watts_beta = 0.3

#Network types dictionary
const nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)