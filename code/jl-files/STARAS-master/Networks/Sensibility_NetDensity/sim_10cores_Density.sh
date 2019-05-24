d8="$(date +%Y%m%d_%H%M%S)_Sim_Watts_Density"
wdir="runs/$d8"
mkdir $wdir
cp -r source $wdir
cp Hex_Stack-Watts.ipynb $wdir

for i in $(seq 1 10); do
julia NetSim_Density_Watts.jl 1000  | tee "$wdir/Watts_$i" &
done 

wait

cat $wdir/Watts_* > $wdir/out_watts

wait 

rm $wdir/Watts_*
   
