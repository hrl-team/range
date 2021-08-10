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

[fit, ok] = listdlg('PromptString','Select a model',...
    'SelectionMode','single',...
    'ListString',{'fit','cross validation'}) ;

whichmodel = 2;

% 1 ABSOLUTE
% 2 RANGE
% 3 HABIT
% 4 UTILITY

%% DATA EXTRACTION

load('data');

subjects = 1:800;

sub=0;
for nsub = subjects
    
    sub=sub+1;
        
    contexts{sub}  = data(data(:,1)==nsub & data(:,2)~=0,4);
    choices{sub}   = data(data(:,1)==nsub & data(:,2)~=0,8)+1;
    outcomes{sub}  = data(data(:,1)==nsub & data(:,2)~=0,9);   
    coutcomes{sub} = data(data(:,1)==nsub & data(:,2)~=0,10);   
    experiment{sub}= data(data(:,1)==nsub & data(:,2)~=0,14); 
    
end

%% OPTIMIZATION

options = optimset('Algorithm', 'interior-point', 'Display', 'off', 'MaxIter', 10000,'MaxFunEval',10000);
% The option Display is set to off, which means that the optimization algorithm will run silently, without showing the output of each iteration.
% The option MaxIter is set to 10000, which means that the algorithm will perform a maximum of 10,000 iterations.

sub=0;
init = [1 .5 .5 .5 .5];

for nsub = subjects
    
    sub=sub+1;
    f=waitbar(sub/numel(subjects)); % display progress
    
    for model = whichmodel
        
        % whether or not there is feedback: 0=none, 1=partial, 2=complete
        learning_fb = round((mod(experiment{sub}(1)-1,4)+1)/2);
        transfer_fb = (mod(experiment{sub}(1)-1,4)+1)*0*(mod(experiment{sub}(1),2)==1)+(mod(experiment{sub}(1)-1,4)+1)*1/2*(mod(experiment{sub}(1),2)==0);
        
        if fit == 1 % fitting on the learning phase choices
            
            [parameters(sub,:,model),ll(sub,model),~,~,~,~,hessian(:,:,sub,model)]=fmincon(@(x) ...
                function_model_fitting_simulations(x,contexts{sub},choices{sub},outcomes{sub},coutcomes{sub},learning_fb,transfer_fb,model,1),init,[],[],[],[],[0 0 0 0 0],[Inf 1 1 1 1],[], options);
            
        elseif fit == 2 % corss validation: half of the choices
                          
            [parameters(sub,:,model),ll(sub,model),~,~,~,~,hessian(:,:,sub,model)]=fmincon(@(x) ...
                function_model_fitting_simulations(x,contexts{sub},choices{sub},outcomes{sub},coutcomes{sub},learning_fb,transfer_fb,model,3),init,[],[],[],[],[0 0 0 0 0],[Inf 1 1 1 1],[], options);
            
        end
        
        % log posterior probability (with priors) and log-likelihood
        [logpp(sub,model),~,~,~,~, loglik(sub,model)] = function_model_fitting_simulations(parameters(sub,:,model),contexts{sub},choices{sub},outcomes{sub},coutcomes{sub},learning_fb,transfer_fb,model,1);
        
    end
end

delete(f); % delete the progress display


%% SAVE OPTIMIZATION

if fit == 1
    save Optimization
elseif fit == 2
    save cross_validation
end

