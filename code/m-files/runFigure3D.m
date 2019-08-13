
clc;
clear all;
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% PARAMETERS

MSC=.72; %Computed from single-node experiment

Ts=[6, 12, 24, 48, 72, 96];  % Duration of the experiment

N=11;   % Number of microenvironments
ns=101;  % Number of connectivities

Amax=100;  %Maximum antibiotic concentration in drug gradient
Rmax=1;    %Initial resource concentration
B0=1e6;  %Initial bacterial density (per phenotype)

params=setParams();
params.T=0; %tmp
params.N=N;
params.Amax=Amax;
params.Rmax=Rmax;

CT=cbrewer('seq', 'Greys', ns+2);


%% DIFFERENT Ts

for iT=1:length(Ts)
    T=Ts(iT);

    sigmasA=linspace(0,1.,ns);
    all_nodes={};
    for s=1:ns

        params=setParams();
        params.T=T;
        params.N=N;
        params.Amax=Amax;
        params.channel_width = sigmasA(s);  %Distance between nodes


        %Define initial conditions (R,A,Bs,Br)
        x0=zeros(N,4);
        x0(:,1)=Rmax*ones(1,N)';
        x0(:,2)=zeros(1,N);  % linspace(0,Amax,N)';
        x0(1,2)=Amax;  %Use antibiotic only on first node
        x0(:,3)=0; %Pre-inoculation
        x0(:,4)=0; %Pre-inoculation

        nodes0=simulateLinearArray(x0, params);
        R0=zeros(1,N);
        A0=zeros(1,N);
        for n=1:N
            R0(n)=nodes0{n}.y(end,1);
            A0(n)=nodes0{n}.y(end,2);
        end


        %Define initial conditions (R,A,Bs,Br)
        x0=zeros(N,4);
        x0(:,1)=R0;
        x0(:,2)=A0;
        x0(:,3)=B0*ones(1,N)';
        x0(:,4)=B0*ones(1,N)';

        nodes=simulateLinearArray(x0, params);

        all_nodes{s}=nodes;

    end

    % Plot Relative Fitness/Density (area)

    fig=figure(1);
    clf('reset');  set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white');
    set(fig,'Position',[360 278 480 480])
    subaxis(1,1,1,'MarginLeft',.2,'MarginBottom',.2);
    
    cc = bipolar_brazil(201,0);
    
    plotArea(all_nodes, cc);
    
    set(gca,'FontSize',30)
    
    ylabel('\sigma', 'FontSize',36);
    xlabel('d', 'FontSize',36);
    
    yticks([0 ns/2 ns]);
    yticklabels({0 .5 1})
    export_fig(['../../figures/src/figure3_relFitness_sigma_position_area_T',num2str(T),'.pdf'])
    close();
    
    
end

%%

 % Plot Relative Fitness/Density (colormap/circles)

    fig=figure(1);
    clf('reset');  set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white');
    set(fig,'Position',[360 278 480 480])
    subaxis(1,1,1,'MarginLeft',.2,'MarginBottom',.2);
    
    cc = bipolar_brazil(201,0);
    
    plotArea(all_nodes, cc);
    
    set(gca,'FontSize',30)
    
    ylabel('Connectivity', 'FontSize',36);
    xlabel('Distance', 'FontSize',36);
    
    yticks([0 ns/2 ns]);
    yticklabels({0 .5 1})
   % export_fig(['../../figures/src/figure3_relFitness_sigma_position_area_T',num2str(T),'.pdf'])
   % close();
