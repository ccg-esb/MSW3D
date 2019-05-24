function fout = f2types(x,params,Ris,Ais)

    Rminus1=Ris(1);
    Rplus1=Ris(2);

    Aminus1=Ais(1);
    Aplus1=Ais(2);
    

    R = x(1);
    A = x(2);
    Bs = x(3);
    Br = x(4);
    
    %Resource diffusion
    if ~isnan(Rminus1) &&  ~isnan(Rplus1)  %Middle
        DR = params.channel_width*params.diffusion_coefficient*(Rminus1-R) + params.channel_width*params.diffusion_coefficient*(Rplus1-R);
    elseif ~isnan(Rplus1) %Right
        DR = params.channel_width*params.diffusion_coefficient*(Rplus1-R);
    elseif ~isnan(Rminus1) %Left
        DR = params.channel_width*params.diffusion_coefficient*(Rminus1-R);    
    end
    
    %Antibiotic diffusion
    if ~isnan(Aminus1) &&  ~isnan(Aplus1)  %Middle
        DA = params.channel_width*params.diffusion_coefficient*(Aminus1-A) + params.channel_width*params.diffusion_coefficient*(Aplus1-A);
    elseif ~isnan(Aplus1) %Right
        DA = params.channel_width*params.diffusion_coefficient*(Aplus1-A);
    elseif ~isnan(Aminus1) %Left
        DA = params.channel_width*params.diffusion_coefficient*(Aminus1-A);    
    end

    f1 = -(U(R,params.pS).*Bs + U(R,params.pR).*Br) + DR;
    f2 = -params.alphaS*A*Bs - params.alphaR*A*Br + DA;
    f3 = (G(R,params.pS)*gamma(A,params.kS))*Bs;
    f4 = (G(R,params.pR)*gamma(A,params.kR))*Br;

    fout = params.T*[f1 ;f2 ;f3; f4];
end

%Bacteriostatic antibiotic
function ret = gamma(A,kN)
    ret = 1 - (kN(1)*A./(1+kN(2)*A));
end

function Gout = G(R,pN)
    rho = pN(1);
    Gout = rho.*U(R,pN);
end

function Uout = U(R,pN)
    
    mu = pN(2);
    K = pN(3);
    Uout = R*mu./(K+R);

end
