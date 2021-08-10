function [lik, a, r, c, Q, ll] = function_model_fitting_simulations(params,s,A,R,C,learning_fb,transfer_fb,model,optsim)

% Model parameters

beta    = params(1); % choice temperature
alphaQf = params(2); % alpha update Q-values
alphaQc = params(3); % alpha update Q-values
alphaV  = params(4); % alpha update context value
n       = params(5); % curvature of the value function (0<m<1)

% Initialization of the internal variables

% Value matrices: 8 contexts with 2 options (index 1 = worst option, 2 = best option)
Q  = zeros(8,2) ;   % Q-values (all models)
H  = zeros(8,2) ;   % Habitual component (HABIT model)
P  = zeros(8,2) ;   % Q-values to replace the arbiter (HABIT model)

Rmin = zeros(8,1);  % Maximum value per context (RANGE model)
Rmax = zeros(8,1);  % Minimum value per context (RANGE model)

lik = 0;            % log-likelihood optimized for fitting
ll  = 0;            % out-of-sample likelihood calculated for simulations

r = zeros(length(s),1);     % simulated rewards
c = zeros(length(s),1);     % simulated counterfactual rewards
r2 = zeros(length(s),1);    % transformed rewards (RANGE and UTILITY)
c2 = zeros(length(s),1);    % transformed counterfactual rewards (RANGE and UTILITY)

for i = 1:length(s) % trial by trial
    
    if i == length(s)/2 +1 % first trial of the transfer phase
        
        % start the transfer phase with the final values of the learning phase (see Figure 1)
        Q(5,:) = [Q(3,2),Q(1,2)];
        Q(6,:) = [Q(3,1),Q(1,1)];
        Q(7,:) = [Q(4,1),Q(2,2)];
        Q(8,:) = [Q(4,2),Q(2,1)];
        
        H(5,:) = [H(3,2),H(1,2)];
        H(6,:) = [H(3,1),H(1,1)];
        H(7,:) = [H(4,1),H(2,2)];
        H(8,:) = [H(4,2),H(2,1)];
        
        P(5,:) = [P(3,2),P(1,2)];
        P(6,:) = [P(3,1),P(1,1)];
        P(7,:) = [P(4,1),P(2,2)];
        P(8,:) = [P(4,2),P(2,1)];
        
    end
    
    if optsim == 1 % optimization / fitting
        
        a(i) = A(i);    % participants' choice
        
        if s(i)<5   % fit learning test only
            
            % avoid the problem of the softmax overflow
            if ~isnan(a(i))
                x = max(0, beta * (Q(s(i),3-a(i))-Q(s(i),a(i))));
                lik = lik - x - log(exp(-x)+exp(beta * (Q(s(i),3-a(i))-Q(s(i),a(i)))-x)); % fit likelihood
            end
            
        end
        
    elseif optsim == 3  % cross validation
        
        a(i) = A(i);    % participants' choice
        
        if s(i)==1 || s(i)==3   % fit conditions 1pt and 10pt only
            
            % avoid the problem of the softmax overflow
            if ~isnan(a(i))
                x = max(0, beta * (Q(s(i),3-a(i))-Q(s(i),a(i))));
                lik = lik - x - log(exp(-x)+exp(beta * (Q(s(i),3-a(i))-Q(s(i),a(i)))-x));
            end
        end
        
    elseif optsim == 2 % simulations
        
        % calculate probability of choosing the best option at each trial ("option 2")
        Pc(i)=1/(1+exp((Q(s(i),1)-Q(s(i),2))*(beta)));
        
        choice = [1 2];              % symbols
        proba  = [1-Pc(i) Pc(i)];    % probas
        
        % chooses a symbole with softmax rule
        a(i) = choice(find(rand<cumsum(proba),1,'first'));
        
    end
    
    
    if ~isnan(a(i))
        
        if s(i)<5 % learning phase
            
            if optsim ~= 2 % fitting or cross validation
                
                r(i) = R(i)+9*(s(i)<3 & (R(i)==1)); % factual reward
                c(i) = C(i)+9*(s(i)<3 & (C(i)==1)); % counterfactual reward
                
            elseif optsim == 2 % simulations
                
                % reward probability = 0.75 if good option, 0.25 if bad option
                p_reward  = 0.25+(a(i)-1)*0.50;
                
                if s(i) < 3 % big magnitude
                    if rand <= p_reward ;  r(i)=10; end
                    if rand <= 1-p_reward ;  c(i)=10; end
                elseif s(i) > 2 % small magnitude
                    if rand <= p_reward ;  r(i)=1; end
                    if rand <= 1-p_reward ;  c(i)=1; end
                end
            end
            
        elseif s(i)>4 % transfer phase
            
            if optsim ~= 2 % fitting or cross validation
                
                r(i) = R(i)+(a(i)-1)*9*(R(i)==1);   % factual reward
                c(i) = C(i)+(3-a(i)-1)*9*(C(i)==1); % counterfactual reward
                
            elseif optsim == 2 % simulations
                
                % for the transfer phase, we do context by context because
                % magnitude and probabilities change for each pair of options
                if s(i) == 5
                    p_reward  = 0.75;
                    if rand <= p_reward ;  r(i)=1+(a(i)-1)*9; end
                    if rand <= p_reward ;  c(i)=10-(a(i)-1)*9; end
                elseif s(i) == 6
                    p_reward  = 0.25;
                    if rand <= p_reward ;  r(i)=1+(a(i)-1)*9; end
                    if rand <= p_reward ;  c(i)=10-(a(i)-1)*9; end
                elseif s(i) == 7
                    p_reward  = 0.25+(a(i)-1)*0.50;
                    if rand <= p_reward ;  r(i)=1+(a(i)-1)*9; end
                    if rand <= 1-p_reward ;  c(i)=10-(a(i)-1)*9; end
                elseif s(i) == 8
                    p_reward  = 0.75-(a(i)-1)*0.50;
                    if rand <= p_reward ;  r(i)=1+(a(i)-1)*9; end
                    if rand <= 1-p_reward ;  c(i)=10-(a(i)-1)*9; end
                end
            end
        end
        
        if model==1 % ABSOLUTE model (Qlearning)
            
            if s(i) < 5 || transfer_fb ~= 0 % learning phase or transfer phase with feedback
                
                % Q-value update with prediction error
                deltaR(i) = r(i) - Q(s(i),a(i)) ;
                Q(s(i),a(i)) =  Q(s(i),a(i))   + alphaQf * deltaR(i);
                
                if learning_fb == 2 || transfer_fb == 2 % complete feedback: update of the unchosen option
                    
                    deltaC(i) = c(i) - Q(s(i),3-a(i)) ;
                    Q(s(i),3-a(i)) =  Q(s(i),3-a(i))   + alphaQc * deltaC(i);
                    
                end
            end
            
            
        elseif model==2 % RANGE model
            
            
            if s(i) < 5 || transfer_fb ~= 0 % learning phase or transfer phase with feedback
                
                if learning_fb == 2 || transfer_fb == 2 % complete feedback: take both outcomes into account
                    
                    % updtate maximum
                    if max([r(i),c(i)]) > Rmax(s(i))
                        Rmax(s(i)) = Rmax(s(i)) + alphaV * (max([r(i),c(i)]) - Rmax(s(i)));
                    end
                    
                    % update minimum (never done in our task design)
                    if min([r(i),c(i)]) < Rmin(s(i))
                        Rmin(s(i)) = Rmin(s(i)) + alphaV * (min([r(i),c(i)]) - Rmin(s(i)));
                    end
                    
                else % partial feedback: take only the factual reward into account
                    
                    % updtate maximum
                    if r(i)> Rmax(s(i))
                        Rmax(s(i)) = Rmax(s(i)) + alphaV * (r(i) - Rmax(s(i)));
                    end
                    
                    % update minimum (never done in our task design)
                    if r(i)< Rmin(s(i))
                        Rmin(s(i)) = Rmin(s(i)) + alphaV * (r(i) - Rmin(s(i)));
                    end
                    
                end
                
                % normalized reward using range-adaptation
                r2(i) = (r(i)-Rmin(s(i)))/(1+Rmax(s(i))-Rmin(s(i)));
                
                % Q-value update with prediction error
                deltaR(i) =  r2(i) - Q(s(i),a(i)) ;
                Q(s(i),a(i))   = Q(s(i),a(i))   + alphaQf * deltaR(i);
                
                if learning_fb == 2 || transfer_fb == 2 % complete feedback: update of the unchosen option
                    
                    c2(i) = (c(i)-Rmin(s(i)))/(1+Rmax(s(i))-Rmin(s(i)));
                    
                    deltaC(i) =  c2(i) - Q(s(i),3-a(i)) ;
                    Q(s(i),3-a(i))   = Q(s(i),3-a(i))   + alphaQc * deltaC(i);
                    
                end
            end
            
        elseif model == 3 % HABIT model
            
            % In this script, we note A the Qvalue matrix and Q the arbiter
            % (noted D in the methods) because the softmax is performed
            % with the matrix Q.
            % Parameter alphaV represents habitual learning rate.
            % Parameter n represents the weight w from the methods.
            
            if s(i) < 5 || transfer_fb ~= 0 % learning phase or transfer phase with feedback
                
                % Q-matrix update with prediction error
                deltaR(i) = r(i) - P(s(i),a(i)) ;
                P(s(i),a(i)) =  P(s(i),a(i))   + alphaQf * deltaR(i);
                
                if learning_fb == 2 || transfer_fb == 2 % complete feedback: update of the unchosen option
                    
                    deltaC(i) = c(i) - P(s(i),3-a(i)) ;
                    P(s(i),3-a(i)) =  P(s(i),3-a(i))   + alphaQc * deltaC(i);
                    
                end
                
                % Habitual controller
                if a(i) == 1 % choose option 1
                    a_t = [1 0];
                elseif a(i) == 2 % choose option 2
                    a_t = [0 1];
                end
                
                % Habitual component
                H(s(i),:)   = H(s(i),:) + alphaV * (a_t - H(s(i),:));
                
                % Arbiter
                Q(s(i),:)   = n * H(s(i),:)  +  (1-n) * P(s(i),:) ;
                
            end
            
            
        elseif model == 4 % UTILITY model
            
            if s(i) < 5 || transfer_fb ~= 0 % learning phase or transfer phase with feedback
                
                % Utility reward
                r2(i) = r(i)^n;
                
                % Q-value update
                deltaR(i) = r2(i) - Q(s(i),a(i)) ;
                Q(s(i),a(i)) =  Q(s(i),a(i))   + alphaQf * deltaR(i);
                
                if learning_fb == 2 || transfer_fb == 2  % complete feedback: update of the unchosen option
                    
                    c2(i) = c(i)^n;
                    
                    deltaC(i) = c2(i) - Q(s(i),3-a(i)) ;
                    Q(s(i),3-a(i)) =  Q(s(i),3-a(i))   + alphaQc * deltaC(i);
                    
                end
                
            end
            
        end
        
    end
    
end

if optsim ~= 2 % fitting or cross validation
    
    ll  = -lik;
    lik = -lik;
    
    % Prior penalization
    
    beta    = params(1); % choice temperature
    alphaQf = params(2); % alpha update Q-values
    alphaQc = params(3); % alpha update Q-values
    alphaV  = params(4); % alpha update context value
    n       = params(5); % weight
    
    % the parameters are distrubution with mean + variance (different shapes)
    pbeta       = log(gampdf(beta,1.2,5));
    palphaQf    = log(betapdf(alphaQf,1.1,1.1));
    palphaQc    = log(betapdf(alphaQc,1.1,1.1));
    palphaV     = log(betapdf(alphaV,1.1,1.1));
    pn          = log(betapdf(n,1.1,1.1));
    
    if learning_fb == 1 % partial feedback
        
        if model == 1       % ABSOLUTE
            p = [pbeta palphaQf];
        elseif model == 2   % RANGE
            p = [pbeta palphaQf palphaV];
        elseif model == 3 % HABIT
            p = [pbeta palphaQf palphaV pn];
        elseif model == 4   % UTILITY
            p = [pbeta palphaQf pn];
        end
        
    elseif learning_fb == 2 % complete feedback
        
        if model == 1       % ABSOLUTE
            p = [pbeta palphaQf palphaQc];
        elseif model == 2   % RANGE
            p = [pbeta palphaQf palphaQc palphaV];
        elseif model == 3 % HABIT
            p = [pbeta palphaQf palphaQc palphaV pn];
        elseif model == 4   % UTILITY
            p = [pbeta palphaQf palphaQc pn];
        end
        
    end
    
    % penalize the likelihood with the priors
    p = -sum(p);
    lik = p + lik;
    
end
end
