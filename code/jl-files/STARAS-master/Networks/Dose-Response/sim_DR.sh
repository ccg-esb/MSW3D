d8="$(date +%Y%m%d_%H%M%S)_DoseResponse_Watts_diverseMeanEdg"
wdir="runs/$d8"
mkdir $wdir
mkdir "$wdir/ANT"
cp -r source $wdir
cp DR_Stack_Watts.ipynb $wdir
cp Sim_DR_Watts.jl $wdir
cp ANT_hist.ipynb $wdir

vec=('0' '2' '4' '6' '8' '10')

for i in ${vec[@]};do
julia Sim_DR_Watts.jl 5 $i $wdir  > "$wdir/DR_N_50_meanedg_${i}_watts_out" &
julia build_NetExample.jl $i $wdir
done
