d8="$(date +%Y%m%d_%H%M%S)_Motifs"
wdir="runs/$d8"
mkdir $wdir
mkdir $wdir/output
cp -r source $wdir
cp DR_Stack.ipynb $wdir
cp rerun.sh $wdir
cp Motif_DR.jl $wdir

motifs=('complete' 'star' 'cycle' 'wheel')

for i in ${motifs[@]};do
echo $i
julia Motif_DR.jl 10 $i > $wdir/output/DR_motifs_$i &
done
