d8="$(date +%Y%m%d_%H%M%S)_WholeNetAttacks_Watts"
wdir="runs/$d8"
mkdir $wdir
mkdir "$wdir/output"
cp -r source $wdir
cp "ViolinPlot.ipynb" $wdir
#cp "Sim_attacks_Erdos.jl" $wdir
cp "Sim_attacks_Watts.jl" $wdir
cp "rerun.sh" $wdir

julia Sim_attacks_Watts.jl 10 > "$wdir/output/NetAttack_watts_out" &
#julia Sim_attacks_Erdos.jl 10 > "$wdir/output/NetAttack_erdos_out" &
