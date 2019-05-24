#Data types
#Making weaker the resistand and decreasing the diffusion rate.

type bact
    c::Float64
    Vmax::Float64
    Km::Float64 
    k::Float64 # Antibiotic effect
    alpha::Float64 # Antibiotic lossrate
end

type antb
    delta::Float64 # Antibiotic diffussion rate
end

type node
    B::Array{Float64} # Vector with bacteria strains concentrations
    A::Array{Float64} # Vector with antibiotic concentrations
    R::Float64 # Resource concentration
    x::Float64 # x coordinate for plotting
    y::Float64 # y coordinate for plotting
end

#Growth Functions

function u(R::Float64,b::bact) # u(R)= Vmax * R / (Km + R) ----- Where Km and Vmax are given by bact.
    return b.Vmax * R / (b.Km + R)
end

function G(u::Function, b::bact, R::Float64) # G(R) = c * u(R) ----- Where c is also given by bact.
    return b.c * u(R,b)
end


#Constants

strains = 
    [bact(
    2.18e4, # c
    8.6e-6, # Vmax
    0.0527, # Km
    0.1, # k (Antibiotic effect)
    0) # alpha
    bact(1.8e4, 8.3e-6, 0.1, 0.05,0)]

ant = [antb(
    0.5)] #Diffussion rate

#Function for the ODE solving

function f(t, vec)
    # Extract the coordinates from the r vector
    (bs, br, a, r) = vec
    
    # The equations
    dBs_dt = bs*(*G(u,strains[1],r) - strains[1].k * a)
    dBr_dt = br*(G(u,strains[2],r) - strains[2].k * a)
    dA_dt = -(bs*strains[1].alpha + br*strains[2].alpha)
    dR_dt = -(bs*u(r,strains[1])+br*u(r,strains[2]))
    
    # Return the derivatives as a vector
    [dBs_dt; dBr_dt; dA_dt; dR_dt]
end;

dif_interval = 0.2 #Interval in hours
time = 0:dif_interval:23

dt = 0.1
t = 0:dt:dif_interval
