
%% Generating the matrix with all the data and the model fits
% function [a]=structure_matrix_to_plotmatrix(structure_matrix,whichcondition,conditions,subjects,sessions,trials);
% 
% a=zeros(trials,subjects);
% 
% for n=1:subjects;
%     
%     for m=1:sessions;
%         
%         data=conditions{n,m};
%         
%         vari=structure_matrix{n,m};
%         
%         a(:,ncol)=a(:,ncol)+(vari(data==whichcondition,1))/sessions;
% 
%     end
% end

function [a]=structure_matrix_to_plotmatrix(structure_matrix,whichcondition,conditions,subjects,sessions,trials,adjust);
%              (structure_matrix_to_plotmatrix(hyperP1,         1,            hyperCon,  20,   1,20,0))/repet;
a=zeros(trials,subjects);

for n=1:subjects
   
    for m=1:sessions
        
        data=conditions{n,m};
        
        vari=structure_matrix{n,m};
        vari=vari+adjust;
        
%         size(a(:,n))
%         size(vari(data==whichcondition,1))
%         size(whichcondition)
%         size(sessions)
        
        a(:,n)=a(:,n)+(vari(data==whichcondition,1))/sessions;

    end
end