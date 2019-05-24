node_num = 50 #Number of different diffusion coefficients (equal to rownumbers)
mean_edges = 2 #Mean number of connections between microenvironments
chan_len = 0.1 #Width of the connections
ant_to_node = 40. #Antibiotic concentration for "attack"

#Watts parameter for network rewiring
watts_beta = 0.5

#Network types dictionary
nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)
