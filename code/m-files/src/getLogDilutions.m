function dilutions=getLogDilutions(minDose, maxDose, N)

Ds=(logspace(minDose,maxDose,N));
dilutions=[0 Ds];