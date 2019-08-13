clc;
clear all;
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% load data

dirData='../../data/data_growthcurves/';
fileName_OD600='GrowthCurves_OD600.csv';
fileName_CFP='GrowthCurves_CFP.csv';
fileName_YFP='GrowthCurves_YFP.csv';

data_OD600 = readtable([dirData,fileName_OD600], 'HeaderLines',1); 
data_CFP = readtable([dirData,fileName_CFP], 'HeaderLines',1); 
data_YFP = readtable([dirData,fileName_YFP], 'HeaderLines',1); 

maxCFP=max(max(table2array(data_CFP(:,2:end))));
minCFP=min(min(table2array(data_CFP(:,2:end))));

maxYFP=max(max(table2array(data_YFP(:,2:end))));
minYFP=min(min(table2array(data_YFP(:,2:end))));

maxOD600=max(max(table2array(data_OD600(:,2:end))));
minOD600=min(min(table2array(data_OD600(:,2:end))));

norm_CFP=(table2array(data_CFP(:,2:end)) - minCFP)./(maxCFP-minCFP);
norm_YFP=(table2array(data_YFP(:,2:end)) - minYFP)./(maxYFP-minYFP);

noBG_OD600=table2array(data_OD600(:,2:end))-minOD600;

%relFreq=norm_YFP./norm_CFP;
%frac_CFP=


prop_YFP=(norm_YFP)./((norm_YFP)+(norm_CFP));
prop_CFP=(norm_CFP)./((norm_YFP)+(norm_CFP));

%% Plot growth curves

times=(0:20:20*(height(data_OD600(:,1))-1))./60;

As=[0,10,100,1000];
nreps=6;

figure(1);clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
set(gcf,'Units','Pixels','Position',[100         100         600         240])


for iA=1:length(As)
    subaxis(1,length(As), iA, 'SpacingHoriz',.01,'MarginBottom',0.2,'MarginLeft',0.15);
   
    
    %area(times, mean(noBG_OD600(:,reps_A0),2).*mean(prop_YFP(:,reps_A0),2), 'k-','LineWidth',2); hold all;
    
    
    %OD600
    reps_A0=nreps*(iA-1)+(1:nreps);
    
    p1=area(times, mean(noBG_OD600(:,reps_A0),2), 'FaceColor','c'); hold all;
    p2=area(times, mean(noBG_OD600(:,reps_A0),2).*mean(prop_YFP(:,reps_A0),2), 'FaceColor','y'); hold all;
    
    
    for r=1:length(reps_A0)
        plot(times, noBG_OD600(:,reps_A0(r)), '-','LineWidth',1,'Color',[.6 .6 .6]); hold all;

        plot(times, noBG_OD600(:,reps_A0).*prop_YFP(:,reps_A0), 'k-','LineWidth',1); hold all;
    
        %plot(times, table2array(data_CFP(:,reps_A0(r))).*(table2array(data_OD600(:,reps_A0(r)))), '-','Color',[.8 .8 .8]); hold all;
    end
    plot(times, mean(noBG_OD600(:,reps_A0),2), 'k-','LineWidth',2); hold all;
    p3=plot(times, mean(noBG_OD600(:,reps_A0),2)/2, 'r--','LineWidth',2); hold all;
    
    %plot(times, mean(norm_CFP(:,reps_A0),2), 'c-','LineWidth',2); hold all;
    %plot(times, mean(norm_YFP(:,reps_A0),2), 'y-','LineWidth',2); hold all;
    
    plot(times, mean(noBG_OD600(:,reps_A0),2).*mean(prop_YFP(:,reps_A0),2), 'k-','LineWidth',2); hold all;
    %plot(times, mean(noBG_OD600(:,reps_A0),2).*mean(prop_CFP(:,reps_A0),2), 'k-','LineWidth',1); hold all;
    
    %plot(times, mean(noBG_OD600(:,reps_A0),2).*(mean(prop_YFP(:,reps_A0),2)+std(prop_YFP(:,reps_A0),0,2)/sqrt(nreps)), 'k-','LineWidth',1); hold all;
    %plot(times, mean(noBG_OD600(:,reps_A0),2).*(mean(prop_YFP(:,reps_A0),2)-std(prop_YFP(:,reps_A0),0,2)/sqrt(nreps)), 'k-','LineWidth',1); hold all;
    
    
    %plot(times, mean(noBG_OD600(:,reps_A0),2).*mean(prop_CFP(:,reps_A0),2), 'c-','LineWidth',2); hold all;
    
    
    %plot(times, .5*mean(noBG_OD600(:,reps_A0),2).*mean(relFreq(:,reps_A0),2), 'k--','LineWidth',2); hold all;
    
    set(gca,'fontsize',16);
    
    %plot(times, mean(norm_CFP(:,reps_A0),2), '-','Color','c'); hold all;
    %plot(times, mean(norm_YFP(:,reps_A0),2), '-','Color','y'); hold all;
    title(['',num2str(As(iA)),'\mug/mL'],'FontSize',18);
    axis([0 times(end) 0 .65]);
    
    if iA==1
       ylabel('OD_{600}','FontSize',18); 
    else
        yticks([]);
    end
    xticks(0:6:24)
    
    if iA==length(As)
        legend([p2,p1,p3],{'Gby','Wcl','\phi_r=1'},'FontSize',16)
    end
    
    xlabel('Time (h)','FontSize',18);
end


export_fig('../../figures/src/figure1_growthCurves.pdf')
