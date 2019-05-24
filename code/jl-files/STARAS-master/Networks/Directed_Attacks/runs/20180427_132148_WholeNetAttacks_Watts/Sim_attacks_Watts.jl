
using ODE,LightGraphs

include("source/Model.jl")
include("source/Plotter.jl")
include("source/Functions.jl")
include("source/run_params.jl")

#Simulate Attacks on every node in the network
print(nsim_attacks_watts(parse(Int64,ARGS[1])))
