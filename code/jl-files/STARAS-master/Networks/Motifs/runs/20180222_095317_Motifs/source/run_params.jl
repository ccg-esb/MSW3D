const node_num = 8 #Number of different diffusion coefficients (equal to rownumbers)

const chan_len = 0.1 #Width of the connections
const ant_range = 0:1.:node_num*10 #Antibiotic concentration for "attack"

const cutoff_value = 1e6 #Value from which we assume there was no growth

#Network types dictionary
const nets = Dict("complete" => CompleteGraph, "star" => StarGraph, "cycle"=>CycleGraph,"wheel"=>WheelGraph)#,"roach"=>RoachGraph
