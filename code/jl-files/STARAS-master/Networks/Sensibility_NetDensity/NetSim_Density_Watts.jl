
using ODE,LightGraphs

include("source/Model.jl")
include("source/Plotter.jl")
include("source/Functions.jl")
include("source/run_params.jl")

#Simulate Watts
nsim_watts_rden(parse(Int64,ARGS[1]))
