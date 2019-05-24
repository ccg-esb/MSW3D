vec=('0' '1') #two antibiotic values to compare
max_toDR='4' #Maximum value in Dose-Response simulation

for i in ${vec[@]};do
julia sim_node.jl $i > "output/single_node_curve_${i}ant" &
done
julia sim_oneNode_DR.jl $max_toDR > "output/sim_DR_node" &
