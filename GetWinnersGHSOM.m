function [Winners,NeuroCount] = GetWinnersGHSOM(Model,Samples,NeuroCount)
% Get the winners of the GHSOM model
% Input:
%   Model = GHSOM Model 
%	Samples = Test samples (one sample per column)
%   NeuroCount = Counter of the number of neurons visited (0 at the
%   begining)
% Output:
%   Winners = Vector with the indexes of the winning neurons associated to 
%   each input sample
%   NeuroCount = Counter of the number of neurons visited

% Distances = Model.Dists;
Distances = GetDistancesMapGHSOM(Model.Prototypes,Samples);
NumNeurons = size(Model.TopolDist,1);
[~,Winners] = min(Distances);
NewWinners = Winners + NeuroCount;

for NdxNeuro=1:NumNeurons,        
    if ~isempty(Model.Child{NdxNeuro}), 
        InputNdx = Winners == NdxNeuro; 
        NeuroCountAnt = NeuroCount;
        [NewWinners(InputNdx),NeuroCount] = GetWinnersGHSOM(Model.Child{NdxNeuro},Samples(:,InputNdx),NeuroCount); 
        InputNdx = Winners > NdxNeuro;
        NewWinners(InputNdx) = NewWinners(InputNdx) + (NeuroCount - NeuroCountAnt - 1); 
    else
        NeuroCount = NeuroCount+1;
    end    
end
Winners = NewWinners;
