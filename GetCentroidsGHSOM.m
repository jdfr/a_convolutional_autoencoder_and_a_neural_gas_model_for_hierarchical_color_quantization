function [NewCentroids] = GetCentroidsGHSOM(Model)
% Get recursively the centroids of the GHSOM model

NdxValidNeurons = find(isfinite(Model.Prototypes(1,:,:)));
NewCentroids = [];

for NdxNeuro=1:length(NdxValidNeurons),        
    if ~isempty(Model.Child{NdxNeuro}),        
        ChildCentroids = GetCentroidsGHSOM(Model.Child{NdxNeuro}); 
        NewCentroids = [NewCentroids ChildCentroids];
    else
        NewCentroids = [NewCentroids Model.Prototypes(:,NdxNeuro)];
    end    
end