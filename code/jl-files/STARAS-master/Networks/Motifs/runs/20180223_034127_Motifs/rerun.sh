motifs=('complete' 'star' 'cycle' 'wheel')

for i in ${motifs[@]};do
echo $i
julia Motif_DR.jl 10 $i > DR_Motifs_$i &
done