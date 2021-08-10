function [Nbar,Nsub] = skylineplot_model(DataCell,Model_DataCell1,Colors,Yinf,Ysup,Font,Title,LabelX,LabelY,varargin)

% Sophie Bavard - December 2018
% Creates a violin plot with mean, error bars, confidence interval, kernel density.
% Warning: the function can accept any number of arguments > 9.
% After the Title, LabelX, LabelY : varargin for bar names under X-axis

% transforms the Data matrix into cell format if needed
if iscell(DataCell)==0
    DataCell = num2cell(DataCell,2);
end
if iscell(Model_DataCell1)==0
    Model_DataCell1 = num2cell(Model_DataCell1', 1)';
end

% number of factors/groups/conditions
Nbar = size(DataCell,1);
% bar size
Wbar = 0.75;

% confidence interval
ConfInter = 0.95;

% color of the box + error bar
trace = [0.5 0.5 0.5];

for n = 1:Nbar
    
    clear DataMatrix
    clear jitter jitterstrength
    DataMatrix = DataCell{n,:}';
    
    % number of subjects
    Nsub = length(DataMatrix(~isnan(DataMatrix)));
    
    curve = nanmean(DataMatrix);
    sem   = nanstd(DataMatrix')'/sqrt(Nsub);
    conf  = tinv(1 - 0.5*(1-ConfInter),Nsub);
    
    
    % PLOT THE VIOLINS
    
    % calculate kernel density estimation for the violin
    [density, value] = ksdensity(DataMatrix, 'Bandwidth', 0.9 * min(std(DataMatrix), iqr(DataMatrix)/1.34) * Nsub^(-1/5)); % change Bandwidth for violin shape. Default MATLAB: std(DataMatrix)*(4/(3*Nsub))^(1/5)
    density = density(value >= min(DataMatrix) & value <= max(DataMatrix));
    value = value(value >= min(DataMatrix) & value <= max(DataMatrix));
    value(1) = min(DataMatrix);
    value(end) = max(DataMatrix);
    
    % all data is identical
    if min(DataMatrix) == max(DataMatrix)
        density = 1; value = 1;
    end
    width = Wbar/2/max(density);
    
    % plot the violin
    fill([n n+density*width n],...
        [value(1) value value(end)],...
        Colors(n,:),...
        'EdgeColor', 'none',...%trace,...
        'FaceAlpha',0.2);
    hold on
    
    % CONFIDENCE INTERVAL    
    inter = unique(DataMatrix(DataMatrix<curve+sem*conf & DataMatrix>curve-sem*conf),'stable')';
    if length(density) > 1
        d = interp1(value, density*width, [curve-sem*conf sort(inter) curve+sem*conf]);
    else % all data is identical
        d = repmat(density*width,1,2);
    end 
    fill([n n+d n],...
        [curve-sem*conf curve-sem*conf sort(inter) curve+sem*conf curve+sem*conf],...
        Colors(n,:),...
        'EdgeColor', 'none',...%trace,...
        'FaceAlpha',0.4);
    hold on
    
    % INDIVIDUAL DOTS
    if length(density) > 1
        jitterstrength = interp1(value, density*width, DataMatrix);
    else % all data is identical
        jitterstrength = density*width;
    end
%     for i=1:length(jitterstrength)
%         jitter(i,1)=nansum(jitterstrength(1:i)==jitterstrength(i))-1;
%     end
%     if max(jitter) ~= 0
%         jitter = jitter./max(jitter);
%     end

    jitter=abs(zscore(1:length(DataMatrix))'/max(zscore(1:length(DataMatrix))'));
    
	scatter(n - Wbar/10 - jitter.*(Wbar/2- Wbar/10), DataMatrix, 10,...
        Colors(n,:),'filled',...
        'marker','o',...
        'MarkerFaceAlpha',0.4);
    hold on
    
    % MEAN HORIZONTAL BAR
%     if length(density)>1
%         xM = interp1(value, density*width, curve);
%     else
%         xM = density*width;
%     end
    xMean = [n ; n + Wbar/2];
    yMean = [curve; curve];
    plot(xMean,yMean,'-','LineWidth',1,'Color','k');
    hold on
    
    % ERROR BARS
    errorbar(n+Wbar/4,curve,sem,...
        'Color','k',...Colors(n,:),...
        'LineStyle','none',...  'CapSize',3,...
        'LineWidth',1);
    hold on    
        
    % CONFIDENCE INTERVAL RECTANGLE
    rectangle('Position',[n, curve - sem*conf, Wbar/2, sem*conf*2],...
        'EdgeColor',Colors(n,:),...
        'LineWidth',1);
    hold on
    
    % PLOT THE MODEL SIMULATIONS    
    errorbar(n+Wbar/2,nanmean(Model_DataCell1{n,:}'),NaN,...%std(Model_DataCell1{n,:}')'/sqrt(Nsub),...
        'Color',[0 0 0],...
        'LineWidth',1,...
        'LineStyle','none',...
        'Marker','o',...
        'MarkerFaceColor',[0 0 0],...[1 0.5 0],...
        'MarkerSize',8);
    hold on 
    
end

% axes and stuff
ylim([Yinf Ysup]);
set(gca,'FontSize',Font,...
    'XLim',[0 Nbar+1],...
    'XTick',1:Nbar,...
    'XTickLabel',varargin);
yline(0);

title(Title);
xlabel(LabelX);
ylabel(LabelY);













