d8="Sim_Watts_InitBactDen_${1}0_$(date +%Y%m%d_%H%M%S)"
wdir="runs/$d8"
mkdir $wdir
cp -r source $wdir

echo -e "Sum_S\tSum_R\tNodes_S\tNodes_R\tNodes_none\tEdge_number\tDensity\tGlobal_CC\tResistant_Init_Density (e5)" > out_watts

for i in $(seq 1 10); do
julia NetSim_InitBactDen.jl $1   | tee > "$wdir/Watts_$i" &
done 
wait

cat $wdir/Watts_* > $wdir/out_watts

wait 

#rm $wdir/Watts_*
