clc;
clear all;
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% PARAMETERS

T=24;  % Duration of the experiment


Amax=1e3;  %Maximum antibiotic concentration in drug gradient
Rmax=1;    %Initial resource concentration
B0=1e6;  %Initial bacterial density (per phenotype)

params=setParams();
params.T=T;
params.N=1;
params.Amax=Amax;
params.Rmax=Rmax;

%%  RUN GROWTH CURVE
%{
    
figure(1);clf('reset');  set(gcf,'DefaultLineLineWidth',4); set(gcf, 'color', 'white');

subaxis(1,2,1,'PaddingBottom',.05,'SpacingHoriz',0.01);

A=1;
x0=[Rmax, A, B0, B0];
ysim=simulateNode(x0, params);

plot(ysim.time, ysim.y(:,3),'y'); hold on;
plot(ysim.time, ysim.y(:,4),'c');

xlabel('Time (hours)','FontSize',18);
ylabel('Bacterial density','FontSize',18);
ylim([0 1.e8]);
xlim([0, 12]);
set(gca,'FontSize',16);
legend({'B_s','B_r'},'Location','NorthWest','FontSize',18);



subaxis(1,2,2,'PaddingBottom',.05,'SpacingHoriz',0.01);
A=5;
x0=[Rmax, A, B0, B0];
ysim=simulateNode(x0, params);

plot(ysim.time, ysim.y(:,3),'y'); hold on;
plot(ysim.time, ysim.y(:,4),'c');


xlabel('Time (hours)','FontSize',18);
ylabel('');
yticks([]);
ylim([0 1.e8]);
xlim([0, 12]);
set(gca,'FontSize',16);



%export_fig('../figures/src/figure2_growthA.pdf')


%}

%% DOSE-RESPONSE (w/growth curves)


figure(3);clf('reset');  set(gcf,'DefaultLineLineWidth',3); set(gcf, 'color', 'white');
set(gcf,'Units','Pixels','Position',[1000         918         1200         320])

As=[0 1 2 4 8 16 32 64 128 256] ;
na=length(As);
maxY=1.5e8;

for iA=1:na

    %Define initial conditions (R,A,Bs,Br)
    x0=zeros(1,4);
    x0(:,1)=Rmax; %From pre-inoculation
    x0(:,2)=As(iA);  %From pre-inoculation
    x0(:,3)=B0;
    x0(:,4)=B0;
    
    ysim=simulateNode(x0, params);
    
    subaxis(1,na,iA,'PaddingBottom',.05,'SpacingHoriz',0.01);

    pr=area(ysim.time, ysim.y(:,3)+ysim.y(:,4),'FaceColor','c'); hold on;
    ps=area(ysim.time, ysim.y(:,3),'FaceColor','y'); hold on;
    ptot=plot(ysim.time, ysim.y(:,3)+ysim.y(:,4),'k','LineWidth',3); hold on;

    text(6, .95*maxY,['A=',num2str(As(iA))],'FontSize',16,'HorizontalAlignment','center');
    
    if iA>1
        ylabel('');
        yticks([]);
        xticks(0:6:12);
    else
        ylabel('Bacterial density');
        xticks(0:6:12);
    end
    ylim([0 maxY]);
    xlim([0, 14]);
    set(gca,'FontSize',16);
    
    if iA==ceil(na/2)
        xlabel('Time (hours)');
    end
    
    if iA==na
       legend([ps,pr,ptot],{'B_s','B_r','Total'},'Location','East'); 
    end
    
end

export_fig('../figures/src/figure2_DR-area.pdf')


%% RUN DOSE-RESPONSE


na=21;
minDose=-1;
maxDose=3;
As=getLogDilutions(minDose, maxDose, na);


%As=linspace(0,Amax,na);
sim_dose={};
BrTs=zeros(1,na);
BsTs=zeros(1,na);
phiTs=zeros(1,na);
for iA=1:na

    %Define initial conditions (R,A,Bs,Br)
    x0=zeros(1,4);
    x0(:,1)=Rmax; %From pre-inoculation
    x0(:,2)=As(iA);  %From pre-inoculation
    x0(:,3)=B0;
    x0(:,4)=B0;
    
    ysim=simulateNode(x0, params);
    
    BsTs(iA)=ysim.y(end,3);
    BrTs(iA)=ysim.y(end,4);
    
    
    thisPhi=0; %relFitness([B0 BsTs(iA)],[B0 BrTs(iA)]);
    phiTs(iA)=thisPhi(end);
    
    %sim_dose{iA}=this_dose;
end

sumBT=BsTs+BrTs;

%iMSC=find(phiTs>1);
%MSC=As(iMSC(end));
%disp(['MSC=',num2str(MSC)]);

%%

figure(3);clf('reset');  set(gcf,'DefaultLineLineWidth',3); set(gcf, 'color', 'white');
%h=axes;
%set(h,'xscale','log')

%plotShaded(As(2:end),[zeros(1,na); BrTs+BsTs],[0 1 1],1); hold on;
%plotShaded(As(2:end),[zeros(1,na); BsTs],[1 1 0],1); hold on;

bar(1:na, BrTs+BsTs, 'FaceColor',[0 1 1]); hold on;
bar(1:na, BsTs, 'FaceColor',[1 1 0]);
%semilogx(As(2:end), sumBT, 'k-','LineWidth',3); hold on;
%legend('B_s','B_r','Bacterial density')

%semilogx(As(2:end), BsTs, '-','Color','yellow'); hold on;
%semilogx(As(2:end), BrTs, '-','Color','cyan'); hold on;
xlabel('Antibiotic concentration','FontSize',18);
ylabel('Bacterial density (T=24h)','FontSize',18);
ix=[2 7 12 17 22];
set(gca,'Xtick',ix); %// adjust manually; values in log scale
set(gca,'Xticklabel',{ '10^{-1}', '10^{0}', '10^{1}', '10^{2}', '10^{3}'}); %// use labels with linear values
%ylim([0 1.5e8]);
%xlim([1e0, 1e3]);
set(gca,'FontSize',16);

%export_fig('../figures/src/figure2_DR-bar.pdf')

%%

figure();clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');

plotShaded(As(iMSC),[ones(1,length(iMSC)); phiTs(iMSC)],[1 1 0],1); hold on;
plotShaded(As(iMSC(end):end),[ones(1,length(As(iMSC(end):end))); phiTs(iMSC(end):end)],[0 1 1],1); hold on;

set(gca,'FontSize',16)
plot(As, phiTs, 'k-'); hold on;
plot([0 Amax],[1 1],'k:');
xlabel('Antibiotic concentration','FontSize',18);
ylabel('Relative fitness (\phi)','FontSize',18);
%axis([0 Amax .6 1.1]);

%export_fig('figures/figure1_dose-phi.pdf')



