

clc
clear all
close all

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%%  CONTROL

control_blue_row1=[11.679, 13.382, 14.454, 14.016];
control_blue_row2=[5.021, 6.155, 6.251, 6.175];
control_blue_row3=[1.094, 1.27, 1.419, 1.512];

control_yellow_row1=[3.264, 4.68, 5.853, 6.438];
control_yellow_row2=[6.326, 8.198, 9.612, 10.633];
control_yellow_row3=[7.037, 9.119, 12.252, 13.705];


control_max_blue=max([max(control_blue_row1), max(control_blue_row2), max(control_blue_row3)]);
control_max_yellow=max([max(control_yellow_row1), max(control_yellow_row2), min(control_yellow_row3)]);
control_min_blue=min([min(control_blue_row1), min(control_blue_row2), min(control_blue_row3)]);
control_min_yellow=min([min(control_yellow_row1), min(control_yellow_row2), min(control_yellow_row3)]);


control_norm_blue_row1=(control_blue_row1-min(control_blue_row1))./(max(control_blue_row1)-min(control_blue_row1));
control_norm_blue_row2=(control_blue_row2-min(control_blue_row2))./(max(control_blue_row2)-min(control_blue_row2));
control_norm_blue_row3=(control_blue_row3-min(control_blue_row3))./(max(control_blue_row3)-min(control_blue_row3));

control_norm_yellow_row1=(control_yellow_row1-min(control_yellow_row1))./(max(control_yellow_row1)-min(control_yellow_row1));
control_norm_yellow_row2=(control_yellow_row2-min(control_yellow_row2))./(max(control_yellow_row2)-min(control_yellow_row2));
control_norm_yellow_row3=(control_yellow_row3-min(control_yellow_row3))./(max(control_yellow_row3)-min(control_yellow_row3));

control_normIntensity_row1=[control_norm_blue_row1; control_norm_yellow_row1]';
control_relIntensity_row1=control_normIntensity_row1./sum(control_normIntensity_row1,2);

control_normIntensity_row2=[control_norm_blue_row2; control_norm_yellow_row2]';
control_relIntensity_row2=control_normIntensity_row2./sum(control_normIntensity_row2,2);

control_normIntensity_row3=[control_norm_blue_row3; control_norm_yellow_row3]';
control_relIntensity_row3=control_normIntensity_row3./sum(control_normIntensity_row3,2);


%%

blue_row1=fliplr([6.741, 8.326, 13.048, 14.429, 13.563]);
blue_row2=fliplr([6.847, 7.324, 9.773, 14.609, 15.525]);
blue_row3=fliplr([5.575, 6.571, 7.098, 7.535, 11.79]);

yellow_row1=fliplr([5.471, 5.753, 1.984, 1.864, 1.658]);
yellow_row2=fliplr([4.801, 4.726, 3.691, 1.732, 1.581]);
yellow_row3=fliplr([4.27, 4.809, 4.57, 4.476, 1.268]);

xs=[0,1,2,3,4];
xs_labels={'drug', '1', '2', '3', '4'};


max_blue=max([max(blue_row1), max(blue_row2), max(blue_row3)]);
max_yellow=max([max(yellow_row1), max(yellow_row2), min(yellow_row3)]);
min_blue=min([min(blue_row1), min(blue_row2), min(blue_row3)]);
min_yellow=min([min(yellow_row1), min(yellow_row2), min(yellow_row3)]);

norm_blue_row1=(blue_row1-min(blue_row1))./(max(blue_row1)-min(blue_row1));
norm_blue_row2=(blue_row2-min(blue_row2))./(max(blue_row2)-min(blue_row2));
norm_blue_row3=(blue_row3-min(blue_row3))./(max(blue_row3)-min(blue_row3));

norm_yellow_row1=(yellow_row1-min(yellow_row1))./(max(yellow_row1)-min(yellow_row1));
norm_yellow_row2=(yellow_row2-min(yellow_row2))./(max(yellow_row2)-min(yellow_row2));
norm_yellow_row3=(yellow_row3-min(yellow_row3))./(max(yellow_row3)-min(yellow_row3));

normIntensity_row1=[norm_blue_row1; norm_yellow_row1]';
relIntensity_row1=normIntensity_row1./sum(normIntensity_row1,2);

normIntensity_row2=[norm_blue_row2; norm_yellow_row2]';
relIntensity_row2=normIntensity_row2./sum(normIntensity_row2,2);

normIntensity_row3=[norm_blue_row3; norm_yellow_row3]';
relIntensity_row3=normIntensity_row3./sum(normIntensity_row3,2);

%%


figure(1); clf('reset');set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white'); hold all

subaxis(3,1,1,'SpacingVert',0.05,'MarginBottom',0.2,'PaddingLeft',0.1);
area(xs, norm_blue_row1,'FaceColor','c','LineWidth',1,'FaceAlpha',.3,'EdgeAlpha',1); hold on;
area(xs, norm_yellow_row1, 'FaceColor','y','LineWidth',1,'FaceAlpha',.3,'EdgeAlpha',1); hold on;
%bar(xs, relIntensity_row1,0.9,'stacked');
xticks([]);
set(gca,'FontSize',24); 
ylim([0,1]);

subaxis(3,1,2,'SpacingVert',0.05);
area(xs, norm_blue_row2,'FaceColor','c','LineWidth',1,'FaceAlpha',.3,'EdgeAlpha',1); hold on;
area(xs, norm_yellow_row2, 'FaceColor','y','LineWidth',1,'FaceAlpha',.3,'EdgeAlpha',1); hold on;
%bar(xs, [norm_blue_row2; norm_yellow_row2]',0.9,'stacked');
xticks([]);
ylim([0,1]);

set(gca,'FontSize',24); 
ylabel('Relative fluorescent intensity','FontSize',26);

subaxis(3,1,3,'SpacingVert',0.05);
area(xs, norm_blue_row3,'FaceColor','c','LineWidth',1,'FaceAlpha',.3,'EdgeAlpha',1); hold on;
area(xs, norm_yellow_row3, 'FaceColor','y','LineWidth',1,'FaceAlpha',.3,'EdgeAlpha',1); hold on;
%bar(xs, [norm_blue_row3; norm_yellow_row3]',0.9,'stacked');
ylim([0,1]);

xticks(xs);
%xticklabels({'drug', '1', '2', '3', '4'});

set(gca,'FontSize',24); 
xlabel('Distance from drug source','FontSize',26);


%export_fig '../../figures/src/figure5_ImageProcessing_RelFreq.png'
%%



figure(2); clf('reset');set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white'); hold all

errorbar(1-.2, mean(control_blue_row1),std(control_blue_row1),'k','LineWidth',2); hold on;
errorbar(1.2, mean(control_yellow_row1),std(control_yellow_row1),'k','LineWidth',2); hold on;
%plot(1-.2, mean(control_blue_row1),'ko','MarkerFaceColor','c','MarkerSize',10); hold on;
%plot(1-.2, mean(control_yellow_row1),'ko','MarkerFaceColor','y','MarkerSize',10); hold on;
p1=bar(1-.2, mean(control_blue_row1),.4,'FaceColor','c','LineWidth',2); hold on;
p2=bar(1.2, mean(control_yellow_row1),.4,'FaceColor','y','LineWidth',2); hold on;

errorbar(2-.2, mean(control_blue_row2),std(control_blue_row2),'k','LineWidth',2); hold on;
errorbar(2.2, mean(control_yellow_row2),std(control_yellow_row2),'k','LineWidth',2); hold on;
%plot(2, mean(control_blue_row2),'ko','MarkerFaceColor','c','MarkerSize',10); hold on;
%plot(2, mean(control_yellow_row2),'ko','MarkerFaceColor','y','MarkerSize',10); hold on;
bar(2-.2, mean(control_blue_row2),.4,'FaceColor','c','LineWidth',2); hold on;
bar(2.2, mean(control_yellow_row2),.4,'FaceColor','y','LineWidth',2); hold on;

errorbar(3-.2, mean(control_blue_row3),std(control_blue_row3),'k','LineWidth',2); hold on;
errorbar(3.2, mean(control_yellow_row3),std(control_yellow_row3),'k','LineWidth',2); hold on;
%plot(3, mean(control_blue_row3),'ko','MarkerFaceColor','c','MarkerSize',10); hold on;
%plot(3, mean(control_yellow_row3),'ko','MarkerFaceColor','y','MarkerSize',10); hold on;
bar(3-.2, mean(control_blue_row3),.4,'FaceColor','c','LineWidth',2); hold on;
bar(3.2, mean(control_yellow_row3),.4,'FaceColor','y','LineWidth',2); hold on;

legend boxoff

xticks(1:3);
set(gca,'FontSize',20); 

legend([p1,p2],{'434nm/479nm','479nm/535nm'},'Location','NorthEastOutside','FontSize',24);
set(gca,'xticklabel',{'Wcl','Wcl+Gby','Gby'},'FontSize',24);

%bar(xs, relIntensity_row1,0.9,'stacked');

xlim([0.5,3.5]);

ylabel('Fluorescence (a.u.)','FontSize',28);

%export_fig '../../figures/src/figure5_ImageProcessing_RelFreq_control.pdf'
