d8="$(date +%Y%m%d_%H%M%S)_OneNode"
wdir="runs/$d8"
mkdir $wdir
mkdir "$wdir/output"
mkdir "$wdir/figs"
cp -r source $wdir
cp sim_node.jl  $wdir
cp sim_oneNode_DR.jl $wdir
cp rerun.sh $wdir
cp Plotter.ipynb $wdir

vec=('0' '1') #two antibiotic values to compare
max_toDR='4' #Maximum value in Dose-Response simulation

for i in ${vec[@]};do
julia sim_node.jl $i > "$wdir/output/single_node_curve_${i}ant" &
done
julia sim_oneNode_DR.jl $max_toDR > "$wdir/output/sim_DR_node" &
