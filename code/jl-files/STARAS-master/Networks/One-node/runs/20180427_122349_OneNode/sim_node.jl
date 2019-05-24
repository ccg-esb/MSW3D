using ODE

include("source/Model.jl")
include("source/Functions.jl")

sim = sim_node_wAnt(parse(Int64,ARGS[1]))

for i in 1:length(sim[1])
    print(sim[1][i],"\t")
    for element in sim[2][i]
        print(element,"\t")
    end
    print("\n")
end