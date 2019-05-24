
using ODE,LightGraphs

include("source/Model.jl")
include("source/Functions.jl")
include("source/run_params.jl")

#Simulate Watts
#print("Sum_S","\t","Sum_R","\t","Nodes_S","\t","Nodes_R","\t","Nodes_none","\t","Edge_number","\t", "Density","\t","Global_CC","\t","Resistant Initial Density (x e5)") #We print the headers of our simulation results
nsim_watts_rInitBactDen(parse(Int64,ARGS[1]))
