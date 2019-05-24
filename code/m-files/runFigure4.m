clc;
clear all;
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% Load data

dirData='../data/data_cytometry/';
fileName='flow_cytometry.txt';
data=tdfread([dirData,fileName]);
samples=cellstr(data.sample);
%%

num_counts=10000; %total number of counts
N=5; %num wells
ns=4;  % Number of connectivities

B0=1e6;
CFP=1e9;

freqYFP=(data.yellow/num_counts);
freqCFP=(data.blue/num_counts);

cellsYFP=CFP.*freqYFP;
cellsCFP=CFP.*freqCFP;
YFP=cbrewer('seq', 'Greys', ns+2);

%% Compute relative fitness

phis=zeros(1,length(cellsYFP));
relFreqs=zeros(1,length(cellsYFP));
sumCells=zeros(1,length(cellsYFP));
for i=1:length(cellsYFP)
    %phis(i)=relFitnessT([B0/2 cellsYFP(i)],[B0/2 cellsCFP(i)]);
    phis(i)=phiR(cellsCFP(i),cellsYFP(i));
    %relFreqs(i)=cellsCFP(i)/(cellsCFP(i)+cellsYFP(i));   %relFreqT(cellsYFP(i),cellsCFP(i));
    relFreqs(i)=cellsYFP(i)/(cellsCFP(i));   %relFreqT(cellsYFP(i),cellsCFP(i));
    sumCells(i)=cellsYFP(i)+(cellsCFP(i));
    
    disp([samples{i}, ':   ',num2str(cellsYFP(i)), '   ',num2str(cellsCFP(i)), '  phi=',num2str(phis(i))])
    
end

labels_channel0={'501','503','503','504','505'};
labels_channel1={'s11','s12','s13','s14','s15'};
labels_channel3={'s31','s32','s33','s34','s35'};
labels_channel5={'s51','s52','s53','s54','s55'};

all_phis=zeros(ns,N);
all_relFreqs=zeros(ns,N);
for i=1:N
    index0 = find(strcmp(samples, labels_channel0{i}));
    all_phis(1,i)=phis(index0);
    all_relFreqs(1,i)=relFreqs(index0);
    all_sumCells(1,i)=sumCells(index0);
    
    index1 = find(strcmp(samples, labels_channel1{i}));
    all_phis(2,i)=phis(index1);
    all_relFreqs(2,i)=relFreqs(index1);
    all_sumCells(2,i)=sumCells(index1);

    index3 = find(strcmp(samples, labels_channel3{i}));
    all_phis(3,i)=phis(index3);
    all_relFreqs(3,i)=relFreqs(index3);
    all_sumCells(3,i)=sumCells(index3);

    index5 = find(strcmp(samples, labels_channel5{i}));
    all_phis(4,i)=phis(index5);
    all_relFreqs(4,i)=relFreqs(index5);
    all_sumCells(4,i)=sumCells(index5);
end

%%

figure(7);clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');


plot([0 N], [1 1],':','Color',[.5 .5 .5]); hold on;
p0=plot([0,1,2,4], all_relFreqs(1,[1,2,3,5]),'--k','LineWidth',1); hold on;
p1=plot(0:N-1, all_relFreqs(2,:),'-','LineWidth',1,'Color',YFP(4,:)); hold on;
p3=plot(0:N-1, all_relFreqs(3,:),'-','LineWidth',3,'Color',YFP(5,:)); hold on;
p5=plot(0:N-1, all_relFreqs(4,:),'-','LineWidth',5,'Color',YFP(6,:)); hold on;

plot([0,1,2,4], all_relFreqs(1,[1,2,3,5]),'o','LineWidth',1,'Color','k','MarkerFaceColor','k','MarkerSize',10); hold on;
plot(0:N-1, all_relFreqs(2,:),'o','LineWidth',1,'Color',YFP(4,:),'MarkerFaceColor',YFP(4,:),'MarkerSize',10); hold on;
plot(0:N-1, all_relFreqs(3,:),'o','LineWidth',1,'Color',YFP(5,:),'MarkerFaceColor',YFP(5,:),'MarkerSize',10); hold on;
plot(0:N-1, all_relFreqs(4,:),'o','LineWidth',1,'Color',YFP(6,:),'MarkerFaceColor',YFP(6,:),'MarkerSize',10); hold on;


xlabel('Distance from drug source','FontSize',24)
ylabel('Relative frequency  (Wyl/Gbc)','FontSize',24)
axis([-.02, N-.4 0 1.4])
set(gca,'FontSize',20);

hLegend=legend([p0,p1,p3,p5],{'None','Low','Medium','High'},'Location','SouthEast');
hTitle = get(hLegend,'title');
set(hTitle, 'String',['Degree of',newline,'connectivity:'],  'FontSize',18);
legend boxoff

export_fig '../figures/src/figure4_position_relFreq.pdf'

%%

figure(9);clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');


plot([0 N-1], [1 1],':','Color',[.5 .5 .5]); hold on;
p0=plot([0,1,2,4], all_phis(1,[1,2,3,5]),'-k','LineWidth',1); hold on;
p1=plot(0:N-1, all_phis(2,:),'-','LineWidth',1,'Color',YFP(4,:)); hold on;
p3=plot(0:N-1, all_phis(3,:),'-','LineWidth',3,'Color',YFP(5,:)); hold on;
p5=plot(0:N-1, all_phis(4,:),'-','LineWidth',5,'Color',YFP(6,:)); hold on;

plot([0,1,2,4], all_phis(1,[1,2,3,5]),'o','LineWidth',1,'Color','k','MarkerFaceColor','k','MarkerSize',10); hold on;
plot(0:N-1, all_phis(2,:),'o','LineWidth',1,'Color',YFP(4,:),'MarkerFaceColor',YFP(4,:),'MarkerSize',10); hold on;
plot(0:N-1, all_phis(3,:),'o','LineWidth',1,'Color',YFP(5,:),'MarkerFaceColor',YFP(5,:),'MarkerSize',10); hold on;
plot(0:N-1, all_phis(4,:),'o','LineWidth',1,'Color',YFP(6,:),'MarkerFaceColor',YFP(6,:),'MarkerSize',10); hold on;


xlabel('Distance from drug source','FontSize',24)
ylabel('\phi_r','FontSize',24)
%axis([-.02, N-.8 0 1.4])
set(gca,'FontSize',20);

hLegend=legend([p0,p1,p3,p5],{'None','Low','Medium','High'},'Location','NorthEast');
hTitle = get(hLegend,'title');
set(hTitle, 'String',['Degree of',newline,'connectivity:'],  'FontSize',18);
legend boxoff
