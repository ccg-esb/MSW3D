
using LightGraphs, GraphPlot, Compose
wpath=ARGS[2]
try mkpath(wpath*"/NetExamples") catch print("nel") end
include("source/run_params.jl")

net = watts_strogatz(25,parse(Int64,ARGS[1]),watts_beta)
draw(PNG(wpath*"/NetExamples/"*ARGS[1]*"_ME_25nodes", 16cm, 16cm), gplot(net))
