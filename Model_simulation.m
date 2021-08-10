clear
%close all

%% SET UP

% cond 1 = 7.50 vs 2.50 learning test
% cond 2 = 7.50 vs 2.50 learning test
% cond 3 = 0.75 vs 0.25 learning test
% cond 4 = 0.75 vs 0.25 learning test
% cond 5 = 7.50 vs 0.75 transfer test
% cond 6 = 2.50 vs 0.25 transfer test
% cond 7 = 7.50 vs 0.25 transfer test
% cond 8 = 2.50 vs 0.75 transfer test

model_sim = listdlg('PromptString','Select a model',...
    'SelectionMode','single',...
    'ListString',{'ABSOLUTE','RANGE', 'HABIT','UTILITY'}) ;

% Matrix initialization

ntrial = 30;
sessions = 1;

% parameters for the post test
load('Optimization');
parameters = parameters(subjects,:,model_sim);

% matrices for simulated choices
cond1=zeros(ntrial,numel(subjects));
cond2=zeros(ntrial,numel(subjects));
cond3=zeros(ntrial,numel(subjects));
cond4=zeros(ntrial,numel(subjects));
cond5=zeros(ntrial,numel(subjects));
cond6=zeros(ntrial,numel(subjects));
cond7=zeros(ntrial,numel(subjects));
cond8=zeros(ntrial,numel(subjects));

% matrices for simulated rewards
reward1=zeros(ntrial,numel(subjects));
reward2=zeros(ntrial,numel(subjects));
reward3=zeros(ntrial,numel(subjects));
reward4=zeros(ntrial,numel(subjects));
reward5=zeros(ntrial,numel(subjects));
reward6=zeros(ntrial,numel(subjects));
reward7=zeros(ntrial,numel(subjects));
reward8=zeros(ntrial,numel(subjects));

%% Simulations

repet=100;

for n = 1:repet
    
    f=waitbar(n/repet); % display progress
    
    for sub = 1:numel(subjects)
        
        % whether or not there is feedback: 0=none, 1=partial, 2=complete
        learning_fb(sub) = round((mod(experiment{sub}(1)-1,4)+1)/2);
        transfer_fb(sub) = (mod(experiment{sub}(1)-1,4)+1)*0*(mod(experiment{sub}(1),2)==1)+(mod(experiment{sub}(1)-1,4)+1)*1/2*(mod(experiment{sub}(1),2)==0);
        
        [~, simchoices{sub,1}, simrew{sub,1}] = function_model_fitting_simulations(parameters(sub,:),contexts{sub},choices{sub},outcomes{sub},coutcomes{sub},learning_fb(sub),transfer_fb(sub),model_sim,2);
        
        realcontext{sub,1} = contexts{sub}';
        realchoices{sub,1} = choices{sub};
        simchoices{sub,1} = simchoices{sub,1}'-1;
        
    end
    
    % Arrange choice/rewards matrices as a function of the context
    
    % Simulated choices
    
    cond1 = cond1 + (structure_matrix_to_plotmatrix(simchoices,1,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    cond2 = cond2 + (structure_matrix_to_plotmatrix(simchoices,2,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    cond3 = cond3 + (structure_matrix_to_plotmatrix(simchoices,3,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    cond4 = cond4 + (structure_matrix_to_plotmatrix(simchoices,4,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    
    cond5 = cond5 + (structure_matrix_to_plotmatrix(simchoices,5,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    cond6 = cond6 + (structure_matrix_to_plotmatrix(simchoices,6,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    cond7 = cond7 + (structure_matrix_to_plotmatrix(simchoices,7,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    cond8 = cond8 + (structure_matrix_to_plotmatrix(simchoices,8,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    
    % Simulated rewards
    
    reward1 = reward1 + (structure_matrix_to_plotmatrix(simrew,1,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    reward2 = reward2 + (structure_matrix_to_plotmatrix(simrew,2,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    reward3 = reward3 + (structure_matrix_to_plotmatrix(simrew,3,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    reward4 = reward4 + (structure_matrix_to_plotmatrix(simrew,4,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    
    reward5 = reward5 + (structure_matrix_to_plotmatrix(simrew,5,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    reward6 = reward6 + (structure_matrix_to_plotmatrix(simrew,6,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    reward7 = reward7 + (structure_matrix_to_plotmatrix(simrew,7,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    reward8 = reward8 + (structure_matrix_to_plotmatrix(simrew,8,realcontext,numel(subjects),numel(sessions),ntrial,0))/repet;
    
    % Behavioral choices
    
    choice1 = structure_matrix_to_plotmatrix(realchoices,1,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    choice2 = structure_matrix_to_plotmatrix(realchoices,2,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    choice3 = structure_matrix_to_plotmatrix(realchoices,3,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    choice4 = structure_matrix_to_plotmatrix(realchoices,4,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    
    choice5 = structure_matrix_to_plotmatrix(realchoices,5,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    choice6 = structure_matrix_to_plotmatrix(realchoices,6,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    choice7 = structure_matrix_to_plotmatrix(realchoices,7,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    choice8 = structure_matrix_to_plotmatrix(realchoices,8,realcontext,numel(subjects),numel(sessions),ntrial,-1);
    
end

delete(f); % delete the progress display

%% Calculate the simulated gains

gainsLT = sum(reward1+reward2+reward3+reward4)/200;
gainsPT = sum(reward5+reward6+reward7+reward8)/200;
gains = sum(reward1+reward2+reward3+reward4+reward5+reward6+reward7+reward8)/200;


%% Plot the simulations

mbig = (cond1+cond2)/2;
msmall = (cond3+cond4)/2;

big = (choice1+choice2)/2;
small = (choice3+choice4)/2;

mperfPT = (cond5+cond6+cond7+cond8)/4;
perfPT = (choice5+choice6+choice7+choice8)/4;

%%

Colors(1,:)=[0.12 0.29 0.36];
Colors(2,:)=[0.24 0.41 0.12];
Colors(3,:)=[0.43 0.52 0.10];
Colors(4,:)=[0.62 0.75 0.13];

figure;
subplot(1,2,1)
SurfaceCurvePlotSmooth(big,[0.25 0.5 0.75],Colors(1,:),1,0.25,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(small,[0.25 0.5 0.75],Colors(4,:),1,0.25,0,1,12,'','','');
subplot(1,2,2)
skylineplot_model([nanmean(choice1);nanmean(choice3);nanmean(choice2);nanmean(choice4)],[nanmean(cond1);nanmean(cond3);nanmean(cond2);nanmean(cond4)],Colors([1 4 1 4],:),0,1,12,'','','');
hold on
line([0 10],[0.5 0.5],'Color','k','LineStyle',':')

%%

transfer = [nanmean(choice7);nanmean(choice5);nanmean(choice6);nanmean(choice8)];
mtransfer = [nanmean(cond7);nanmean(cond5);nanmean(cond6);nanmean(cond8)];

figure;
subplot(1,2,1)
SurfaceCurvePlotSmooth(choice7,[0.25 0.5 0.75],Colors(1,:),1,0.25,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(choice5,[0.25 0.5 0.75],Colors(2,:),1,0.25,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(choice6,[0.25 0.5 0.75],Colors(3,:),1,0.25,0,1,12,'','','');
hold on
SurfaceCurvePlotSmooth(choice8,[0.25 0.5 0.75],Colors(4,:),1,0.25,0,1,12,'','','');
subplot(1,2,2)
skylineplot_model(transfer,mtransfer,Colors,0,1,12,'','','');
hold on
line([0 10],[0.5 0.5],'Color','k','LineStyle',':')

%%

save(strcat('simulation_model',num2str(model_sim)));







