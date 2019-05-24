d8="Sim_Watts_1m_$(date +%Y%m%d_%H%M%S)"
wdir="runs/$d8"
mkdir $wdir
cp -r source $wdir
cp "HexBin Plotter.ipynb" $wdir

for i in $(seq 1 10); do
julia NetSim_Watts.jl $i  > "$wdir/Watts_$i" &
done 
wait

cat $wdir/Watts_* > $wdir/out_watts

wait 

rm $wdir/Watts_*
