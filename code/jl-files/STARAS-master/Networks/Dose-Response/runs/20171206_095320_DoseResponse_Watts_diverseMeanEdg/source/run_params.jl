const node_num = 50 #Number of different diffusion coefficients (equal to rownumbers)
const chan_len = 0.1 #Width of the connections
ant_range = 0.:0.1:400

#Watts parameter for network rewiring
const watts_beta = 0.5

#Network types dictionary
const nets = Dict("erdos" => erdos_renyi, "watts" => watts_strogatz)
