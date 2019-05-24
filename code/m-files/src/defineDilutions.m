N=19;
minDose=-1;
maxDose=2;


%Ds=(linspace(power(10,minDose),power(10,maxDose),N));
Ds=(logspace(minDose,maxDose,N));
[0 Ds]

semilogx((Ds),Ds,'ok');
ylabel('Drug');
xlabel('log10(Drug)');