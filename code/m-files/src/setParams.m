function params=setParams()

    params.diffusion_coefficient = .2;                 %Diffusion parameter (A)
    params.channel_width = 0.;                 %Distance between nodes
   
    params.alphaS=1e-10;                %Antibiotic degradation rate (S)
    params.alphaR=1e-9;                 %Antibiotic degradation rate (R)
    
    params.pS = [1.4e8, 7.3e-10, 1];  %growth rate data (rho, mu, K)
    params.pR = [1.05e8, 8e-10, 1]; %growth rate data  (rho, mu, K)

    params.kS = [0.16, .04];  %antibiotic inhibition S (k1, k2)
    params.kR = [.055, .06];  %antibiotic inhibition R (k1, k2) 

    

    