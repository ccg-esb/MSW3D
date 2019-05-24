

clc
clear all
close all

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

dataDir='../data/data_synergy/';
fileName='DR_data.txt';
fileName_Gby='Gby_data.txt';
fileName_Wcl='Wcl_data.txt';

MIC=10;
nreps=4; %Replicates

%% Define dilutions

N=19;
minDose=-1;
maxDose=2;

Ds=MIC*logspace(minDose,maxDose,N);

loadData;

%%

figure(1); clf('reset'); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 

semilogx(Ds, rel_CFP,'o:','Color','cyan','MarkerFaceColor','cyan','MarkerSize',4,'LineWidth',1);hold on;
pC=semilogx(Ds, mean(rel_CFP),'-','Color','k','LineWidth',2);hold on;
%[xFit_CFP,yFit_CFP]=fitDR(Ds(1:end), mean(rel_CFP(:,1:end)));
%yFitOD=interp1(Ds, meanOD, xFit);
%semilogx(xFit_CFP,yFit_CFP,'--','Color','k','LineWidth',2)

semilogx(Ds, rel_YFP,':o','Color','yellow','MarkerFaceColor','yellow'); hold on;
filter_indx=[1:19];
pY=semilogx(Ds(filter_indx), mean(rel_YFP(:,filter_indx)),'--','Color','k','LineWidth',2);hold on;
%[xFit_YFP,yFit_YFP]=fitDR(Ds(filter_indx), mean(rel_YFP([2,3,4],filter_indx)));
%yFitOD=interp1(Ds, meanOD, xFit);
%semilogx([xFit_YFP], [yFit_YFP],'k','Color','k','LineWidth',2)

%semilogx(Ds, mean(rel_CFP),'-k','LineWidth',2)
%semilogx(Ds, mean(rel_YFP),'--k','LineWidth',2)

 set(gca,'fontsize',14); 
xlabel('Kanamycin (\mug/mL)','FontSize',18)
ylabel('Normalized Fluorescent Intensity','FontSize',18)

%plot(Ds, data_OD630,'Color','k'); 
ylim([0, 1]);

legend([pC,pY],{'Resistant','Susceptible'},'FontSize',18)


export_fig '../Figures/src/figure1_drug_v_relInt.pdf'

%%
%{
figure(2); clf('reset'); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 

semilogx(Ds, meanOD,'-','Color','k','MarkerFaceColor','k','LineWidth',4); hold on;
area(Ds,  meanOD.*(prop_meanYFP+prop_meanCFP),'FaceColor','cyan'); hold on;
area(Ds,  meanOD.*(prop_meanYFP),'FaceColor','yellow'); hold on;
semilogx(Ds, meanOD,'-','Color','k','MarkerFaceColor','k','LineWidth',4); hold on;

%semilogx(Ds, data_OD630,'-','Color',[.7 .7 .7],'MarkerFaceColor',[.7 .7 .7]); hold on;
%


 set(gca,'fontsize',14); 
xlabel('Kanamycin (\mug/mL)','FontSize',18)
ylabel('Optical density (630nm)','FontSize',18)

%plot(Ds, data_OD630,'Color','k'); 
export_fig '../figures/src/figure1_drug_v_ODarea.pdf'
%}
%%

figure(3); clf('reset'); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 

prop_meanYFP=mean(rel_YFP)./(mean(rel_YFP)+mean(rel_CFP));
prop_meanCFP=mean(rel_CFP)./(mean(rel_YFP)+mean(rel_CFP));

prop_YFP=(rel_YFP)./((rel_YFP)+(rel_CFP));
prop_CFP=(rel_CFP)./((rel_YFP)+(rel_CFP));

xzoom=1:4;
%Replicates
%for i=1:nreps
%    this_phi=phiR(meanOD(xzoom).*prop_YFP(i,xzoom),meanOD(xzoom).*prop_CFP(i,xzoom));
%    plot(Ds(xzoom), this_phi,'-o','Color',[.7 .7 .7],'MarkerFaceColor',[.7 .7 .7],'LineWidth',1); hold on;
%    ylim([0,2]);
%end

phiMean=phiR(prop_YFP,prop_CFP);

plot([-.2 .8*Ds(xzoom(end))],[1 1],':k','LineWidth',2); hold on
plot([0 Ds], phiR([prop_nodrug_YFP prop_meanYFP],[prop_nodrug_CFP prop_meanCFP]),'-o','Color','k','MarkerFaceColor','k','LineWidth',2,'MarkerSize',10); hold on;
ylim([0 2]); hold on;
xlim([-.2 .8*Ds(xzoom(end))]);
set(gca,'fontsize',14*2); 
xlabel('Kanamycin (\mug/mL)','FontSize',18*2)
ylabel('Relative fitness (\phi_r)','FontSize',18*2)


export_fig '../figures/src/figure1_drug_v_phi.pdf'

%%

figure(4); clf('reset'); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
bar([1,2],[mean(rel_nodrug_CFP), mean(rel_nodrug_YFP)]);


%%

figure(5); clf('reset'); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 

color1=[0 0 0];
stdOD=std(data_OD630)/2;
meanOD=mean(data_OD630);
p1=semilogx(Ds, meanOD,':o','Color',color1,'MarkerFaceColor',color1,'MarkerSize',6,'LineWidth',1);hold on;

for i=1:length(Ds)
    plot([Ds(i) Ds(i)], [meanOD(i)-stdOD(i) meanOD(i)+stdOD(i)],'Color',color1,'LineWidth',1);
end

%semilogx(Ds, data_OD630,':o','Color',[.7 .7 .7],'MarkerFaceColor',[.7 .7 .7],'MarkerSize',4,'LineWidth',1);hold on;
%p1=semilogx(Ds, mean(data_OD630),'o','Color',[.7 .7 .7],'LineWidth',2);hold on;
[xFit_CFP,yFit_CFP]=fitDR(Ds(1:end), mean(data_OD630(:,1:end)));
%yFitOD=interp1(Ds, meanOD, xFit);
p2=semilogx(xFit_CFP,yFit_CFP,'-','Color','k','LineWidth',2);

legend([p1,p2],{'Mean density','Logistic fit'},'FontSize',18);

 set(gca,'fontsize',14); 
xlabel('Kanamycin (\mug/mL)','FontSize',18)
ylabel('Optical density (OD_{630})','FontSize',18)


export_fig '../figures/src/figure1_drug_v_OD630.pdf'


%plot(Ds, data_OD630,'Color','k'); 

%% COMPARE WITH MONOCULTURES



figure(6); clf('reset'); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); hold on;
set(gcf,'Units','Pixels','Position',[1000         918         560*.75         480])

wbar=.7;
colorGby='y';
bar(1,mean(nodrug_OD630_Gby),wbar,'FaceColor',colorGby);
plot([1, 1],[mean(nodrug_OD630_Gby)-std(nodrug_OD630_Gby)/sqrt(nreps),mean(nodrug_OD630_Gby)+std(nodrug_OD630_Gby)/sqrt(nreps)],'k','LineWidth',1);
plot(1,mean(nodrug_OD630_Gby),'ko','Color','k','MarkerFaceColor','k','MarkerSize',6,'LineWidth',1)
%plot(1,nodrug_OD630_Gby,'ko','Color','k','MarkerFaceColor','k','MarkerSize',6,'LineWidth',1)

colorWcl='c';
bar(2,mean(nodrug_OD630_Wcl),wbar,'FaceColor',colorWcl);
plot([2, 2],[mean(nodrug_OD630_Wcl)-std(nodrug_OD630_Wcl)/sqrt(nreps),mean(nodrug_OD630_Wcl)+std(nodrug_OD630_Wcl)/sqrt(nreps)],'k','LineWidth',1);
plot(2,mean(nodrug_OD630_Wcl),'ko','Color','k','MarkerFaceColor','k','MarkerSize',6,'LineWidth',1)
%plot(2,nodrug_OD630_Wcl,'ko','Color','k','MarkerFaceColor','k','MarkerSize',6,'LineWidth',1)


colorAll=[.75 .75 .75];
bar(3,mean(nodrug_OD630),wbar,'FaceColor',colorWcl);
bar(3,mean(nodrug_OD630)*prop_nodrug_YFP,wbar,'FaceColor',colorGby);
plot([3, 3],[mean(nodrug_OD630)-std(nodrug_OD630)/sqrt(nreps),mean(nodrug_OD630)+std(nodrug_OD630)/sqrt(nreps)],'k','LineWidth',1);
plot(3,mean(nodrug_OD630),'ko','Color','k','MarkerFaceColor','k','MarkerSize',6,'LineWidth',1)
plot([3-wbar/2,3+wbar/2],[mean(nodrug_OD630)/2 mean(nodrug_OD630)/2],'k:','LineWidth',2);
%plot(3,nodrug_OD630,'ko','Color',colorAll,'MarkerFaceColor',colorAll,'MarkerSize',6,'LineWidth',1)

ylim([0 1.2]);
set(gca,'fontsize',14);
set(gca,'Xtick',1:3);
set(gca,'Xticklabels',{'','',''},'FontSize',18*2)
xlim([.25 3.75]);
xlabel('','FontSize',18)
ylabel('OD_{630} ','FontSize',18*2)


export_fig '../figures/src/figure1_strains_v_OD630.pdf'