function Distances = GetDistancesMapGHSOM(Prototypes,Samples)
% Get the distances from the neurons of a map of the GHSOM model to the 
% input samples of the map
% Inputs:
%   Prototypes = Neurons' weight vectors of the map
%	Samples = Test samples (one sample per column)
% Output:
%   Distances = Distances from each neuron of the map to input samples

if isempty(Samples),
    Distances = [];
else       
    NumNeurons = size(Prototypes,2)*size(Prototypes,3);
    NumSamples = size(Samples,2);
    Distances = zeros(NumNeurons,NumSamples);
    
    for NdxNeuro=1:NumNeurons,
%         epsilon = 10^-4;
        [i,j] = ind2sub([size(Prototypes,2) size(Prototypes,3)],NdxNeuro);
        WeightVector = Prototypes(:,i,j);
        RepW = repmat(WeightVector,1,NumSamples);       
        % Euclidean distance (standard Kohonen's SOFM)  
        Distances(NdxNeuro,:) = sqrt(sum((Samples-RepW).^2,1));                
    end
end
