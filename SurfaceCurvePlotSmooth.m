function [curve, sem] = SurfaceCurvePlotSmooth(DataMatrix,Chance,Color,Line,Alpha,Yinf,Ysup,Font,Title,LabelX,LabelY)

[Ntrial, Nsub]=size(DataMatrix);

curve= nanmean(DataMatrix,2);
sem  = nanstd(DataMatrix')'/sqrt(Nsub);

curveSup = (curve+sem);
curveInf = (curve-sem);

for n=1:Ntrial
    for i = 1:length(Chance)
        chance(n,i)=Chance(i);
    end
end
% plot(smooth(curveSup),...
%     'Color',Color,...
%     'LineWidth',Line);
% hold on
% plot(smooth(curveInf),...
%     'Color',Color,...
%     'LineWidth',Line);
% hold on
plot(smooth(curve),...
    'Color',Color,....
    'LineWidth',Line*2);
hold on
fill([1:Ntrial flipud([1:Ntrial]')'],[smooth(curveSup)' smooth(flipud(curveInf))'],'k',...
    'LineWidth',1,...
    'LineStyle','none',...
    'FaceColor',Color,...
    'FaceAlpha',Alpha);
plot(chance,'k:',...
   'LineWidth',Line/4);
axis([0 Ntrial+1 Yinf Ysup]);
% xticks(0:10:Ntrial);
set(gca,'Fontsize',Font);
title(Title);
xlabel(LabelX);
ylabel(LabelY);
box ON