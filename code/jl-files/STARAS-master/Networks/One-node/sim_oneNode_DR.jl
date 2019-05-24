using ODE

include("source/Model.jl")
include("source/Functions.jl")

for i in sim_DR_node(parse(Float64,ARGS[1]))
    for j in i
        print(j,"\t")
    end
    print("\n")
end
#writedlm(DR,"data/sim_DR_node")