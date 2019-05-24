
clc;
clear all;
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% PARAMETERS

MSC=.72; %Computed from single-node experiment

T=24;  % Duration of the experiment

N=11;   % Number of microenvironments
ns=101;  % Number of connectivities

Amax=100;  %Maximum antibiotic concentration in drug gradient
Rmax=1;    %Initial resource concentration
B0=1e6;  %Initial bacterial density (per phenotype)

params=setParams();
params.T=T;
params.N=N;
params.Amax=Amax;
params.Rmax=Rmax;

CT=cbrewer('seq', 'Greys', ns+2);


%% EXPERIMENT WITH INCREASING SIGMAS

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

%% Plot Relative Fitness/Density (colormap/circles)

fig=figure(1);
clf('reset');  set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white');
set(fig,'Position',[360 278 2*560 2*420])

cc = bipolar_brazil(201,0);

plotNodes(all_nodes, cc);
set(gca,'FontSize',16)
axis equal;
axis off;
hlab=text(-0.75,(ns+1)/2,'Degree of connectivity','FontSize',24,'VerticalAlignment','bottom','HorizontalAlignment','center');
set(hlab,'Rotation',90)

text((N+1)/2,-0.05,'Distance from drug source','FontSize',24,'HorizontalAlignment','center','VerticalAlignment','top');

for s=1:ns
    text(0,s,num2str(sigmasA(s)),'FontSize',20,'VerticalAlignment','middle','HorizontalAlignment','right');
end
plot([0.25 0.25],[0.5 ns+.5],'k-');

%export_fig('../figures/src/figure3_relFitness_sigma_position.pdf')




%% Total density per degree of connectivity

sigma_sumODT=zeros(ns,1);
sigma_freqBr=zeros(ns,1);
sigma_freqBs=zeros(ns,1);
for s=1:ns
    this_nodes=all_nodes{s};
    sumODT=0;
    sumBr=0;
    sumBs=0;
    for n=1:N
        thisODT=this_nodes{n}.y(end,3)+this_nodes{n}.y(end,4);
        
        sumODT=sumODT+thisODT;
        sumBr=sumBr+this_nodes{n}.y(end,4);
        sumBs=sumBr+this_nodes{n}.y(end,3);
    end
    sigma_sumODT(s)=sumODT;
    
    sigma_freqBr(s)=sumBr/sumODT;
    sigma_freqBs(s)=sumBs/sumODT;
end

fig=figure(1);clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
subaxis(1,1,1,'Padding',0.1);
left_color = [0 0 0]; right_color = [0 1 1]; set(fig,'defaultAxesColorOrder',[left_color; right_color]); 
%bar(sigmasA, sigma_sumODT,'c'); hold on;
%bar(sigmasA, sigma_sumODT.*sigma_freqBr,'y'); hold on;

%plot(sigmasA, sigma_freqBr,'c'); hold on;
%plot(sigmasA, sigma_freqBs,'y'); hold on;

%yyaxis left
%plot(sigmasA, sigma_sumODT,'k'); hold on;
ylabel('Total bacterial density','FontSize',18);

[haxes,hline1,hline2]=plotyy(sigmasA, sigma_sumODT,sigmasA, 100*sigma_freqBr);
set(haxes,'FontSize',26)
ylabel(haxes(2), 'Fraction of resistance (%)','FontSize',30,'Color','k');
ylabel(haxes(1), 'Total bacterial density','FontSize',30,'Color','k');
set(hline1,'LineWidth',4);
set(hline2,'LineWidth',4);

%yyaxis right
%plot(sigmasA, 100*sigma_freqBr,'c'); hold on;
%ylabel('Fraction of resistant cells (%)','FontSize',24);


xlabel('Degree of connectivity','FontSize',30);
export_fig('../figures/src/figure3_sigma_density_fracRes.pdf')



%% D-score per degree of connectivity
ns=11;
dscores=zeros(ns,1);
for s=1:ns
    this_nodes=all_nodes{s};
    for n=1:N
        thisPhiAll=phiR(this_nodes{n}.y(:,3), this_nodes{n}.y(:,4));
        thisPhi=thisPhiAll(end);
        
        if thisPhi<1
           dscores(s)=dscores(s)+1; 
        end
    end
end

figure(5);clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
bar(sigmasA, dscores,'FaceColor',[.9, .9, .9],'EdgeColor','k')
xlabel('Degree of connectivity','FontSize',30);
ylabel('# compartments where \phi_r>1','FontSize',30);
set(gca,'FontSize',26)
xlim([0 1]);
axis([-.05 sigmasA(2)/2+sigmasA(end) 0 N+.5])

export_fig('../figures/src/figure3_sigma_dscore.pdf')

%% TIME TO REACH A*

figure();clf('reset');  set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white');

Tstar=zeros(ns,N);
ns=6;
sigmasA=linspace(0,1.,ns);
str_leg={};
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
    for n=1:N
        istar=find(nodes0{n}.y(:,2)>MSC);
        if isempty(istar)
            istar=[length(nodes0{n}.time)];
        end
        Tstar(s,n)=nodes0{n}.time(istar(1));
    end
    
    %istar=find(Tstar(s,:)<T);
    %if ~isempty(find(Tstar(s,istar)>0, 1))
    %    plot(istar-1,Tstar(s,istar),'-','LineWidth',s,'Color',CT(s+2,:)); hold on;
    %    str_leg{length(str_leg)+1}=num2str(sigmasA(s));
    %end
    plot(0:N-1,params.T-Tstar(s,:),'-','LineWidth',s+1,'Color',CT(s+2,:)); hold on;
    str_leg{length(str_leg)+1}=num2str(sigmasA(s));
end
axis([0 N-1 0 T]);
xticks(0:N-1);

hLegend=legend(str_leg,'Location','NorthEast');
hTitle = get(hLegend,'title');
set(hTitle, 'String',['Degree of',newline,'connectivity:'],  'FontSize',22);
legend boxoff

set(gca,'FontSize',26)
xlabel('Distance from drug source','FontSize',30);
%ylabel('Time elapsed before A(t) > MSC','FontSize',18);
ylabel('Time spent inside MSW','FontSize',30);

export_fig('../figures/src/figure3_position_MSW.pdf')
