
%% 	LOAD WclGby

DATA=importdata([dataDir,fileName]);

data_CFP=DATA.data(1:4,2:end);
data_OD630=DATA.data(5:8,2:end);
data_YFP=DATA.data(9:12,2:end);

minCFP=min(max(data_CFP));
maxCFP=max(max(data_CFP));
minYFP=min(max(data_YFP));
maxYFP=max(max(data_YFP));

nodrug_CFP=DATA.data(1:4,1);
nodrug_OD630=DATA.data(5:8,1);
nodrug_YFP=DATA.data(9:12,1);

rel_CFP=(data_CFP-minCFP)./(maxCFP-minCFP);
rel_YFP=(data_YFP-minYFP)./(maxYFP-minYFP);

rel_nodrug_CFP=(nodrug_CFP-minCFP)./(maxCFP-minCFP);
rel_nodrug_YFP=(nodrug_YFP-minYFP)./(maxYFP-minYFP);

meanOD=mean(data_OD630);

%% LOAD Wcl

DATA_Wcl=importdata([dataDir,fileName_Wcl]);

data_CFP_Wcl=DATA_Wcl.data(1:4,2:end);
data_OD630_Wcl=DATA_Wcl.data(5:8,2:end);
data_YFP_Wcl=DATA_Wcl.data(9:12,2:end);

minCFP_Wcl=min(max(data_CFP_Wcl));
maxCFP_Wcl=max(max(data_CFP_Wcl));
minYFP_Wcl=min(max(data_YFP_Wcl));
maxYFP_Wcl=max(max(data_YFP_Wcl));

nodrug_CFP_Wcl=DATA_Wcl.data(1:4,1);
nodrug_OD630_Wcl=DATA_Wcl.data(5:8,1);
nodrug_YFP_Wcl=DATA_Wcl.data(9:12,1);

rel_CFP_Wcl=(data_CFP_Wcl-minCFP_Wcl)./(maxCFP_Wcl-minCFP_Wcl);
rel_YFP_Wcl=(data_YFP_Wcl-minYFP_Wcl)./(maxYFP_Wcl-minYFP_Wcl);

rel_nodrug_CFP_Wcl=(nodrug_CFP_Wcl-minCFP_Wcl)./(maxCFP_Wcl-minCFP_Wcl);
rel_nodrug_YFP_Wcl=(nodrug_YFP_Wcl-minYFP_Wcl)./(maxYFP_Wcl-minYFP_Wcl);


%% LOAD Gby

DATA_Gby=importdata([dataDir,fileName_Gby]);


data_CFP_Gby=DATA_Gby.data(1:4,2:end);
data_OD630_Gby=DATA_Gby.data(5:8,2:end);
data_YFP_Gby=DATA_Gby.data(9:12,2:end);

minCFP_Gby=min(max(data_CFP_Gby));
maxCFP_Gby=max(max(data_CFP_Gby));
minYFP_Gby=min(max(data_YFP_Gby));
maxYFP_Gby=max(max(data_YFP_Gby));

nodrug_CFP_Gby=DATA_Gby.data(1:4,1);
nodrug_OD630_Gby=DATA_Gby.data(5:8,1);
nodrug_YFP_Gby=DATA_Gby.data(9:12,1);

rel_CFP_Gby=(data_CFP_Gby-minCFP_Gby)./(maxCFP_Gby-minCFP_Gby);
rel_YFP_Gby=(data_YFP_Gby-minYFP_Gby)./(maxYFP_Gby-minYFP_Gby);

rel_nodrug_CFP_Gby=(nodrug_CFP_Gby-minCFP_Gby)./(maxCFP_Gby-minCFP_Gby);
rel_nodrug_YFP_Gby=(nodrug_YFP_Gby-minYFP_Gby)./(maxYFP_Gby-minYFP_Gby);


%%

prop_nodrug_YFP=mean(rel_nodrug_YFP)./(mean(rel_nodrug_YFP)+mean(rel_nodrug_CFP));
prop_nodrug_CFP=mean(rel_nodrug_CFP)./(mean(rel_nodrug_YFP)+mean(rel_nodrug_CFP));
