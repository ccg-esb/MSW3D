node_num = 20 #Number of different diffusion coefficients (equal to rownumbers)
mean_edges = 2 #Mean number of connections between microenvironments
chan_len = 0.1 #Width of the connections
ant_to_node = 20. #Antibiotic concentration for "attack"

#Watts parameter for network rewiring
watts_beta = 0.8

#Network types dictionary
nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)
