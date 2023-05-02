function Model = PruneGHBNG(Model,Level)
% Prune the GHBNG model untill the indicated level
% Input:
%   Model = GHBNG model 
%   Level = number of levels to keep in the GHBNG
% Output:
%   Model = GHBNG model pruned untill the indicated level

if ~isempty(Model) && (Level > 0)
    Model = PruneGHBNGRec(Model,Level,1);
end

end

function Model = PruneGHBNGRec(Model,MaxLevel,Level)

NdxValidNeurons = find(isfinite(Model.Means(1,:)));

for NdxNeuro=NdxValidNeurons  
    if ~isempty(Model.Child{NdxNeuro})          
        if  (Level < MaxLevel)
            Model.Child{NdxNeuro} = PruneGHBNGRec(Model.Child{NdxNeuro},MaxLevel,Level+1);    
        else
            Model.Child{NdxNeuro} = [];
        end 
    end    
end


end