function [NewCentroids] = GetCentroidsGHBNG(Model)
% Get recursively the centroids of the GHBNG model
% E.J. Palomo
% Inputs:
%   Model=GHBNG model
% Output:
%   NewCentroids=Planar prototypes of the GHBNG model

NdxValidNeurons = find(isfinite(Model.Means(1,:)));
NewCentroids = [];

for NdxNeuro=NdxValidNeurons       
    if ~isempty(Model.Child{NdxNeuro})     
        ChildCentroids = GetCentroidsGHBNG(Model.Child{NdxNeuro}); 
        NewCentroids = [NewCentroids ChildCentroids];
    else
        NewCentroids = [NewCentroids Model.Means(:,NdxNeuro)];
    end    
end
