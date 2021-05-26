clear
close all

%% LOAD DATA
load data_figures

%% SPLIT BY EXPERIMENT
expe1 = subjects(design==1);
expe2 = subjects(design==2);
expe3 = subjects(design==3);
expe4 = subjects(design==4);
expe5 = subjects(design==5);
expe6 = subjects(design==6);
expe7 = subjects(design==7);
expe8 = subjects(design==8);

%% LEARNING PHASE COLORS
Colors10(1,:) = [0 0 0.5];
Colors10(2,:) = [0 0 0.5];
Colors10(3,:) = [0 0 0.5];
Colors10(4,:) = [0 0 0.5];
Colors10(5,:) = [0 0 0];
Colors10(6:9,:) = Colors10(1:4,:);
Colors10(10,:) = [0 0 0];
Colors10(11,:) = [237 123 047]/255;

%% TRANSFER PHASE COLORS
Colors10a(1,:) = [0.5 0 0.5];
Colors10a(2,:) = [0.5 0 0.5];
Colors10a(3,:) = [0.5 0 0.5];
Colors10a(4,:) = [0.5 0 0.5];
Colors10a(5,:) = [0 0 0];
Colors10a(6:9,:) = Colors10a(1:4,:);
Colors10a(10,:) = [0 0 0];
Colors10a(11,:) = [237 123 047]/255;

%% SPLIT THE DATA BY EXPERIMENTS

% learning performance
perfbyexpeLT = {nanmean(perfLT(:,expe1));nanmean(perfLT(:,expe2));nanmean(perfLT(:,expe3));nanmean(perfLT(:,expe4));[2.99999 2.99998];...
    nanmean( perfLT(:,expe5));nanmean(perfLT(:,expe6));nanmean(perfLT(:,expe7));nanmean(perfLT(:,expe8));[2.99999 2.99998]};
meanLT=[nanmean(nanmean(perfLT(:,expe1)));nanmean(nanmean(perfLT(:,expe2)));nanmean(nanmean(perfLT(:,expe3)));nanmean(nanmean(perfLT(:,expe4)));...
    nanmean(nanmean(perfLT(:,expe5)));nanmean(nanmean(perfLT(:,expe6)));nanmean(nanmean(perfLT(:,expe7)));nanmean(nanmean(perfLT(:,expe8)))]';

% transfer performance
perfbyexpePT = {nanmean(perfPT(:,expe1));nanmean(perfPT(:,expe2));nanmean(perfPT(:,expe3));nanmean(perfPT(:,expe4));[2.99998 2.99999];...
    nanmean( perfPT(:,expe5));nanmean(perfPT(:,expe6));nanmean(perfPT(:,expe7));nanmean(perfPT(:,expe8));[2.99999 2.99998]};
meanPT=[nanmean(nanmean(perfPT(:,expe1)));nanmean(nanmean(perfPT(:,expe2)));nanmean(nanmean(perfPT(:,expe3)));nanmean(nanmean(perfPT(:,expe4)));...
    nanmean(nanmean(perfPT(:,expe5)));nanmean(nanmean(perfPT(:,expe6)));nanmean(nanmean(perfPT(:,expe7)));nanmean(nanmean(perfPT(:,expe8)))]';

% magnitude difference
mag_diff = big-small;
magbyexpe = {nanmean(mag_diff(:,expe1));nanmean(mag_diff(:,expe2));nanmean(mag_diff(:,expe3));nanmean(mag_diff(:,expe4));[2.99998 2.99999];...
    nanmean( mag_diff(:,expe5));nanmean(mag_diff(:,expe6));nanmean(mag_diff(:,expe7));nanmean(mag_diff(:,expe8));[2.99999 2.99998]};
meanmag=[nanmean(nanmean(mag_diff(:,expe1)));nanmean(nanmean(mag_diff(:,expe2)));nanmean(nanmean(mag_diff(:,expe3)));nanmean(nanmean(mag_diff(:,expe4)));...
    nanmean(nanmean(mag_diff(:,expe5)));nanmean(nanmean(mag_diff(:,expe6)));nanmean(nanmean(mag_diff(:,expe7)));nanmean(nanmean(mag_diff(:,expe8)))]';

% deltaEV(1.75) only
cond8byexpe = {nanmean(cond8(:,expe1));nanmean(cond8(:,expe2));nanmean(cond8(:,expe3));nanmean(cond8(:,expe4));[2.99998 2.99999];...
    nanmean( cond8(:,expe5));nanmean(cond8(:,expe6));nanmean(cond8(:,expe7));nanmean(cond8(:,expe8));[2.99999 2.99998]};
meancon8=[nanmean(nanmean(cond8(:,expe1)));nanmean(nanmean(cond8(:,expe2)));nanmean(nanmean(cond8(:,expe3)));nanmean(nanmean(cond8(:,expe4)));...
    nanmean(nanmean(cond8(:,expe5)));nanmean(nanmean(cond8(:,expe6)));nanmean(nanmean(cond8(:,expe7)));nanmean(nanmean(cond8(:,expe8)))]';


%% FIGURE 2A
figure;
subplot(1,2,1)
SurfaceCurvePlotSmooth(big,[0.25 0.5 0.75],Colors(1,:),1,0.3,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(small,[0.25 0.5 0.75],Colors(4,:),1,0.3,0,1,12,'','','');
subplot(1,2,2)
skylineplot([nanmean(big);nanmean(small)],[Colors(1,:);Colors(4,:)],0,1,12,'','','','10','1');
hold on
line([0 3],[0.5 0.5],'Color','k','LineStyle',':')

%% FIGURE 2B
figure;
skylineplot([perfbyexpeLT;meanLT],Colors10,0,1,12,'','','',''); line([0 100],[0.5 0.5],'Color','k','LineStyle',':');

%% FIGURE 2C
figure;
skylineplot([magbyexpe;meanmag],Colors10,-0.5,0.5,12,'','','',''); line([0 100],[0.5 0.5],'Color','k','LineStyle',':');

%% FIGURE 2D
figure;
subplot(1,2,1)
SurfaceCurvePlotSmooth(cond5,[0.25 0.5 0.75],Colors(2,:),1,0.3,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(cond6,[0.25 0.5 0.75],Colors(3,:),1,0.3,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(cond7,[0.25 0.5 0.75],Colors(1,:),1,0.3,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(cond8,[0.25 0.5 0.75],Colors(4,:),1,0.3,0,1,12,'','','');
subplot(1,2,2)
skylineplot([nanmean(cond7);nanmean(cond5);nanmean(cond6);nanmean(cond8)],Colors,0,1,12,'','',''); %yline(0.5,'--k')
hold on
line([0 10],[0.5 0.5],'Color','k','LineStyle',':')

%% FIGURE 2E
figure;
skylineplot([perfbyexpePT;meanPT],Colors10a,0,1,12,'','','',''); line([0 100],[0.5 0.5],'Color','k','LineStyle',':');

%% FIGURE 2F
figure;
skylineplot([cond8byexpe;meancon8],Colors10a,0,1,12,'','','',''); line([0 100],[0.5 0.5],'Color','k','LineStyle',':');

%% FIGURE 3A
figure;
subplot(1,2,1)
SurfaceCurvePlotSmooth2([perfLT(:,subjects(ismember(design,[1 3 5 7]))); perfPT(:,subjects(ismember(design,[1 3 5 7])))],[0.25 0.5 0.75],[0.5 0 0.5],1,0.3,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(perfLT(:,subjects(ismember(design,[1 3 5 7]))),[0.25 0.5 0.75],[0 0 0.5],1,0.3,0,1,12,'','',''); axis([0 61 0 1]);
subplot(1,2,2)
skylineplot({mean(perfLT(:,subjects(ismember(design,[1 3 5 7])))); mean(perfPT(:,subjects(ismember(design,[1 3 5 7]))))},[0 0 0.5; 0.5 0 0.5],0,1,12,'','','','');

%% FIGURE 3B
figure;
subplot(1,2,1)
SurfaceCurvePlotSmooth2([perfLT(:,subjects(ismember(design,[2 4 6 8]))); perfPT(:,subjects(ismember(design,[2 4 6 8])))],[0.25 0.5 0.75],[0.5 0 0.5],1,0.3,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(perfLT(:,subjects(ismember(design,[2 4 6 8]))),[0.25 0.5 0.75],[0 0 0.5],1,0.3,0,1,12,'','',''); axis([0 61 0 1]);
subplot(1,2,2)
skylineplot({mean(perfLT(:,subjects(ismember(design,[2 4 6 8])))); mean(perfPT(:,subjects(ismember(design,[2 4 6 8]))))},[0 0 0.5; 0.5 0 0.5],0,1,12,'','','','');

