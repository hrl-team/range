%% Simulations for magnitude task, by Sophie Bavard, March 2018

clear
close all

data = 1;
model1 = 1;
model2 = 3;
% model3 = 1;

sim_data = load(strcat('simulation_model',num2str(data)));
sim_mod1 = load(strcat('simulation_model',num2str(model1)));
sim_mod2 = load(strcat('simulation_model',num2str(model2)));
% sim_mod3 = load(strcat('simulation_model',num2str(model3)));

bonus = load('data_figures');
bonus = bonus.bonus;

big    = sim_data.big;
big_m1 = sim_mod1.mbig;
big_m2 = sim_mod2.mbig;

small    = sim_data.small;
small_m1 = sim_mod1.msmall;
small_m2 = sim_mod2.msmall;

gains     = bonus(1,:)/200;
gains_m1  = sim_mod1.gains;
gains_m2  = sim_mod2.gains;
% gains_m3  = sim_mod3.gains;
gainsLT     = bonus(3,:);
gainsLT_m1  = sim_mod1.gainsLT;
gainsLT_m2  = sim_mod2.gainsLT;
% gainsLT_m3  = sim_mod3.gainsLT;
gainsPT     = bonus(4,:);
gainsPT_m1  = sim_mod1.gainsPT;
gainsPT_m2  = sim_mod2.gainsPT;
% gainsPT_m3  = sim_mod3.gainsPT;

Gb = sim_data.choice7;
Gg = sim_data.choice5;
Bb = sim_data.choice6;
Bg = sim_data.choice8;

perfPT    = [mean(sim_data.choice7); mean(sim_data.choice5); mean(sim_data.choice6); mean(sim_data.choice8)];
perfPT_m1 = [mean(sim_mod1.cond7); mean(sim_mod1.cond5); mean(sim_mod1.cond6); mean(sim_mod1.cond8)];
perfPT_m2 = [mean(sim_mod2.cond7); mean(sim_mod2.cond5); mean(sim_mod2.cond6); mean(sim_mod2.cond8)];

%%

Colors(1,:)=[0.12 0.29 0.36];
Colors(2,:)=[0.24 0.41 0.12];
Colors(3,:)=[0.43 0.52 0.10];
Colors(4,:)=[0.62 0.75 0.13];

% figure;
% subplot(1,2,1)
% SurfaceCurvePlotSmooth(big,[0.25 0.5 0.75],Colors(1,:),1,0.25,0,1,12,'','','');
% hold on
% SurfaceCurvePlotSmooth(small,[0.25 0.5 0.75],Colors(4,:),1,0.25,0,1,12,'','','');
% subplot(1,2,2)
% skylineplot_model2([mean(big);mean(small)],[mean(big_m1);mean(small_m1)],[mean(big_m2);mean(small_m2)],Colors([1 4],:),0,1,12,'','','');
% line([0 5],[0.5 0.5],'Color','k','LineStyle','--')
% 
% figure;
% subplot(1,2,1)
% SurfaceCurvePlotSmooth(Gb,[0.25 0.5 0.75],Colors(1,:),1,0.25,0,1,12,'','','');
% hold on
% SurfaceCurvePlotSmooth(Gg,[0.25 0.5 0.75],Colors(2,:),1,0.25,0,1,12,'','','');
% hold on
% SurfaceCurvePlotSmooth(Bb,[0.25 0.5 0.75],Colors(3,:),1,0.25,0,1,12,'','','');
% hold on
% SurfaceCurvePlotSmooth(Bg,[0.25 0.5 0.75],Colors(4,:),1,0.25,0,1,12,'','','');
% subplot(1,2,2)
% skylineplot_model2(perfPT,perfPT_m1,perfPT_m2,Colors,0,1,12,'','','');
% line([0 10],[0.5 0.5],'Color','k','LineStyle','--')

%%

ColorsBonus(1,:) = [24 59 240]/255;
ColorsBonus(2,:) = [154 7 148]/255;
ColorsBonus(3,:) = [90 24 201]/255;

figure;
subplot(1,2,1)
skylineplot_model2(gains,gains_m1,gains_m2,[0.25 0 0.75],2,6,12,'','','');
subplot(1,2,2)
skylineplot_model2([gainsLT;gainsPT],[gainsLT_m1;gainsPT_m1],[gainsLT_m2;gainsPT_m2],[0 0 0.5; 0.5 0 0.5],0,4,12,'','','');

%%

% figure;
% subplot(1,2,1)
% skylineplot_model(gains,gains_m1,ColorsBonus(3,:),2,6,12,'','','');
% subplot(1,2,2)
% skylineplot_model([gainsLT;gainsPT],[gainsLT_m1;gainsPT_m1],ColorsBonus,1,4,12,'','','');

%%

subjects = 1:800;

load llCV
load llPT

ll = llCV + llPT;

for i = subjects
%     freq(i,:) = double(ll(i,[1 3])==max(ll(i,[1 3])));
    freq(i,:) = double(llPT(i,[1 3])==max(llPT(i,[1 3])));
end

lldiff = llPT(:,3) - llPT(:,1);

abso = freq(:,1)'==1;
rela = freq(:,2)'==1;

perf    = [nanmean(sim_data.choice1); nanmean(sim_data.choice2); nanmean(sim_data.choice3); nanmean(sim_data.choice4);...
    nanmean(sim_data.choice7); nanmean(sim_data.choice5); nanmean(sim_data.choice6); nanmean(sim_data.choice8)];

% figure;
% subplot(1,2,1)
% skylineplot(perf(:,abso),repmat([0.25 0 0.75],8,1),0,1,12,'','','');
% subplot(1,2,2)
% skylineplot(perf(:,rela),repmat([0.25 0 0.75],8,1),0,1,12,'','','');

figure;
subplot(1,2,1)
skylineplot({mean(perf(1:4,abso));mean(perf(1:4,rela))},[0 0 0.5;0 0 0.5],0,1,12,'','','');
subplot(1,2,2)
skylineplot({mean(perf(5:8,abso));mean(perf(5:8,rela))},[0.5 0 0.5;0.5 0 0.5],0,1,12,'','','');


% figure;
% subplot(1,2,1)
% skylineplot({mean(perf(1:4,lldiff<=median(lldiff)));mean(perf(1:4,lldiff>median(lldiff)))},[0 0 0.5;0 0 0.5],0,1,12,'','','');
% subplot(1,2,2)
% skylineplot({mean(perf(5:8,lldiff<=median(lldiff)));mean(perf(5:8,lldiff>median(lldiff)))},[0.5 0 0.5;0.5 0 0.5],0,1,12,'','','');

%%

crt = load('correlations.mat');

q_crt_c = sum(crt.quest_CRT_cor);
q_crt_i = sum(crt.quest_CRT_int);
sub_crt = crt.subjectsCRT;

figure;
subplot(1,2,1)
skylineplot({q_crt_c(:,abso(sub_crt)); q_crt_c(:,rela(sub_crt))},[0 0 0.5;0 0 0.5],0,7,12,'','','');
subplot(1,2,2)
skylineplot({q_crt_i(:,abso(sub_crt)); q_crt_i(:,rela(sub_crt))},[0.5 0 0.5;0.5 0 0.5],0,7,12,'','','');

% figure;
% subplot(1,2,1)
% skylineplot({(q_crt_c(:,lldiff(sub_crt)<=median(lldiff(sub_crt))));(q_crt_c(:,lldiff(sub_crt)>median(lldiff(sub_crt))))},[0 0 0.5;0 0 0.5],0,1,12,'','','');
% subplot(1,2,2)
% skylineplot({(q_crt_i(:,lldiff(sub_crt)<=median(lldiff(sub_crt))));(q_crt_i(:,lldiff(sub_crt)>median(lldiff(sub_crt))))},[0.5 0 0.5;0.5 0 0.5],0,1,12,'','','');

%%

figure;
scatterCorr(lldiff(sub_crt),q_crt_c',1);

%%
[~,r] = sort(lldiff(sub_crt), 'Descend');
rankll = 1:786;
rankll(r) = rankll;
[~,r] = sort(q_crt_c, 'Descend');
rankLT = 1:786;
rankLT(r)=rankLT;
[~,r] = sort(q_crt_i, 'Descend');
rankPT = 1:786;
rankPT(r)=rankPT;

figure;

subplot(1,2,1)
scatter(rankll', rankLT', 10, [163 102 163]/255, 'filled');

P = polyfit(rankll',rankLT',1);
Yf = polyval(P,rankll);
hold on
plot(rankll,Yf,'Color',[127 178 41]/255, 'LineWidth',3);

subplot(1,2,2)
scatter(rankll', rankPT', 10, [163 102 163]/255, 'filled');

P = polyfit(rankll',rankPT',1);
Yf = polyval(P,rankll);
hold on
plot(rankll,Yf,'Color',[127 178 41]/255, 'LineWidth',3);

%%

% figure;
% subplot(1,2,1)
% scatterCorr(lldiff, mean(perf(1:4,:))', 1);
% subplot(1,2,2)
% scatterCorr(lldiff, mean(perf(5:8,:))', 1);

%%

[~,r] = sort(lldiff, 'Descend');
rankll = 1:800;
rankll(r) = rankll;
[~,r] = sort(mean(perf(1:4,:)), 'Descend');
rankLT = 1:800;
rankLT(r)=rankLT;
[~,r] = sort(mean(perf(5:8,:)), 'Descend');
rankPT = 1:800;
rankPT(r)=rankPT;

figure;

subplot(1,2,1)
scatter(rankll', rankLT', 10, [163 102 163]/255, 'filled');

P = polyfit(rankll',rankLT',1);
Yf = polyval(P,rankll);
hold on
plot(rankll,Yf,'Color',[127 178 41]/255, 'LineWidth',3);

subplot(1,2,2)
scatter(rankll', rankPT', 10, [163 102 163]/255, 'filled');

P = polyfit(rankll',rankPT',1);
Yf = polyval(P,rankll);
hold on
plot(rankll,Yf,'Color',[127 178 41]/255, 'LineWidth',3);


%%

per = [nanmean(perf(1:4,:))'; nanmean(perf(5:8,:))'];
sub = repmat(1:800,1,2)';
Abs = double([abso abso]')+1;
Rel = double([rela rela]')+1;
pha = [ones(800,1); ones(800,1)+1];

AnovaMatrix = [per sub Rel pha];

% cd Anova
% csvwrite('Anova_bonus.csv',AnovaMatrix);
% cd ..

%%

% figure;
% skylineplot({gains(:,abso);gains(:,rela)},[0.25 0 0.75; 0.25 0 0.75],2,6,12,'','','');



%%

% subjects = 1:800;
% 
% load('freq');
% abs = freq2(:,1)'==1;
% rel = freq2(:,3)'==1;
% random = freq2(:,2)'==1;
% 
% figure;
% subplot(1,2,1)
% skylineplot_model2(gains(:,abs),gains_m1(:,abs),gains_m2(:,abs),[0.25 0 0.75],2,6,12,'','','');
% subplot(1,2,2)
% skylineplot_model2([gainsLT(:,abs);gainsPT(:,abs)],[gainsLT_m1(:,abs);gainsPT_m1(:,abs)],[gainsLT_m2(:,abs);gainsPT_m2(:,abs)],[0 0 0.5; 0.5 0 0.5],0,4,12,'','','');
% 
% 
% figure;
% subplot(1,2,1)
% skylineplot_model2(gains(:,rel),gains_m1(:,rel),gains_m2(:,rel),[0.25 0 0.75],2,6,12,'','','');
% subplot(1,2,2)
% skylineplot_model2([gainsLT(:,rel);gainsPT(:,rel)],[gainsLT_m1(:,rel);gainsPT_m1(:,rel)],[gainsLT_m2(:,rel);gainsPT_m2(:,rel)],[0 0 0.5; 0.5 0 0.5],0,4,12,'','','');
% 

% figure;
% subplot(1,2,1)
% skylineplot_model2(gains(:,random),gains_m1(:,random),gains_m2(:,random),[0.25 0 0.75],2,6,12,'','','');
% subplot(1,2,2)
% skylineplot_model2([gainsLT(:,random);gainsPT(:,random)],[gainsLT_m1(:,random);gainsPT_m1(:,random)],[gainsLT_m2(:,random);gainsPT_m2(:,random)],[0 0 0.5; 0.5 0 0.5],0,4,12,'','','');






