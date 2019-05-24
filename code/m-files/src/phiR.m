function ret=phiR(BsT,BrT)
    ret=zeros(1,length(BsT));
    for i=1:length(BsT)
        ret(i)=log10(BsT(i))/log10(BrT(i));
    end