d8="Sim_Watts_Den_1m_$(date +%Y%m%d_%H%M%S)"
wdir="runs/$d8"
mkdir $wdir
cp -r source $wdir
cp ../Plotter.ipynb $wdir


for i in $(seq 1 10); do
julia NetSim_Density_Watts.jl 100000  | tee "$wdir/Watts_$i" &
done 

#for i in $(seq 1 10); do
#julia NetSim_Density_Watts.jl 100000  | tee "$wdir/Erdos_$i" &
#done 

wait

cat $wdir/Watts_* > $wdir/out_watts
#cat $wdir/Erdos_* > $wdir/out_erdos

#wait 

#rm $wdir/Watts_*
#rm $wdir/Erdos_*
