plumed driver --noatoms --plumed plumed_wham.dat
python wham_torch.py 
grep -v "#!" colvar > tmp
echo "#! FIELDS time D1 D2 dd1 r.bias" > col
paste tmp weights.dat |awk '{print $1,$2,$3,$4,0.593*log($5)}' >> col
plumed driver --noatoms --plumed plumed_fes.dat  --kt 0.593

