function ret=strParams(params)

    ret='';
    ret=[ret,char(10),' nh=',num2str(params.nh)];
    ret=[ret,char(10),' maz=',num2str(params.maz)];
    ret=[ret,char(10),' mv=',num2str(params.mv)];
    ret=[ret,char(10),' mdc=',num2str(params.mdc)];
    ret=[ret,char(10),' gammaAZ=',num2str(params.gammaAZ)];
    ret=[ret,char(10),' gammaV=',num2str(params.gammaV)];
    ret=[ret,char(10),' gammaDC=',num2str(params.gammaDC)];
    ret=[ret,char(10),' thetaDC=',num2str(params.thetaDC)];
    ret=[ret,char(10),' thetaAZ=',num2str(params.thetaAZ)];
    ret=[ret,char(10),' deltaAZ=',num2str(params.deltaAZ)];
    ret=[ret,char(10),' deltaV=',num2str(params.deltaV)];
    ret=[ret,char(10),' deltaDC=',num2str(params.deltaDC)];
    ret=[ret,char(10),' kAZ=',num2str(params.kAZ)];
    ret=[ret,char(10),' kV=',num2str(params.kV)];
    ret=[ret,char(10),' kDC=',num2str(params.kDC)];
    ret=[ret,char(10),' alphaAZ=',num2str(params.alphaAZ)];
    ret=[ret,char(10),' alphaV=',num2str(params.alphaV)];
    ret=[ret,char(10),' inState=[',num2str(params.inState'),']'];

