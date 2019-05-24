
using ODE,LightGraphs

include("source/Model.jl")
include("source/Plotter.jl")
include("source/Functions.jl")
include("source/run_params.jl")

#We call the bash parameters
reps = parse(Int64,ARGS[1])
ME = parse(Int64,ARGS[2])
wdir = ARGS[3]

#We declare the antibiotic array to fill with the distribution of antibiotic in the networks

ant_vector_tofile = Array{Float64,1}(0)

#Simulate Attacks on every node in the network
if ME>0
    nsim_dr_erdos(reps,ME,wdir)
else
    sim_empty_network(reps,node_num,wdir)
end