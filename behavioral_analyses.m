clear
close all

%% SET UP

% cond 1 = 7.50 vs 2.50 learning test
% cond 2 = 7.50 vs 2.50 learning test
% cond 3 = 0.75 vs 0.25 learning test
% cond 4 = 0.75 vs 0.25 learning test
% cond 5 = 7.50 vs 0.75 transfer test
% cond 6 = 2.50 vs 0.25 transfer test
% cond 7 = 7.50 vs 0.25 transfer test
% cond 8 = 2.50 vs 0.75 transfer test

% expe 1 = partial  / no feedback
% expe 2 = partial  / partial feedback
% expe 3 = complete / no feedback
% expe 4 = complete / complete feedback

load('data');
load('demog');

subjects = 1:800;

%% EXTRACT THE DATA

sub=0;
for nsub = subjects
    
    sub=sub+1;
    
    design(1,sub) = unique(data(data(:,1)==nsub, 14));
    
    age_sex(1,sub) = age(find(subj==min(data(data(:,1)==nsub,13))));
    age_sex(2,sub) = sex(find(subj==min(data(data(:,1)==nsub,13)))); 
    
    cond1(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==1,8);
    cond2(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==2,8);
    cond3(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==3,8);
    cond4(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==4,8);
    
    cond5(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==5,8);
    cond6(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==6,8);
    cond7(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==7,8);
    cond8(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==8,8);
     
    reac1(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==1,11)/1000;
    reac2(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==2,11)/1000;
    reac3(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==3,11)/1000;
    reac4(:,sub) = data(data(:,1)==nsub & data(:,2)==1 & data(:,4)==4,11)/1000;
    
    reac5(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==5,11)/1000;
    reac6(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==6,11)/1000;
    reac7(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==7,11)/1000;
    reac8(:,sub) = data(data(:,1)==nsub & data(:,2)==2 & data(:,4)==8,11)/1000;
    
    bonus(1,sub) = max(data(data(:,1)==nsub,12));
    bonus(2,sub) = max(data(data(:,1)==nsub,12))/200-2.5;
    bonus(3,sub) = max(data(data(:,1)==nsub & data(:,2)==1,12))/200;
    bonus(4,sub) = max(data(data(:,1)==nsub & data(:,2)==2,12))/200 - bonus(3,sub);

end

money = bonus(2,:)+2.5;

Colors(1,:)=[0.12 0.29 0.36];
Colors(2,:)=[0.24 0.41 0.12];
Colors(3,:)=[0.43 0.52 0.10];
Colors(4,:)=[0.62 0.75 0.13];

%% PERFORMANCE

perfLT = (cond1+cond2+cond3+cond4)/4;
perfPT = (cond5+cond6+cond7+cond8)/4;

big = (cond1+cond2)/2;
small = (cond3+cond4)/2;

%% SAVE THE DATA

save data_figures

