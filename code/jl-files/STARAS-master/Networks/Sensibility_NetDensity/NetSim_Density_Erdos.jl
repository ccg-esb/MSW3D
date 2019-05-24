
using ODE,LightGraphs

include("source/Model.jl")
include("source/Functions.jl")
include("source/run_params.jl")

#Simulate Watts
nsim_erdos_rden(parse(Int64,ARGS[1]))
