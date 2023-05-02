function Model = TestGHSOM(Samples,Model)
    
% Initialization
[Dimension,NumSamples] = size(Samples);
NumNeurons = length(Model.TopolDist);
Centroids  = reshape(Model.Prototypes,Dimension,NumNeurons);
Distances = zeros(NumNeurons,NumSamples);

for NdxNeuro=1:NumNeurons,
    
    % Compute Squared Distances to Centroid
    MyCentroid = Centroids(:,NdxNeuro);
    RepCentroid = repmat(MyCentroid,1,size(Samples,2));
    Distances(NdxNeuro,:) = sum((Samples-RepCentroid).^2,1);
end

% Reeplace the distances to training samples by the distances to test samples
Model.Dists = Distances;
Model.Samples = Samples;
[~,Winners] = min(Distances);

for NdxNeuro=1:NumNeurons,        
    if ~isempty(Model.Child{NdxNeuro}),        
        InputNdx = Winners == NdxNeuro;
        Model.Child{NdxNeuro} = TestGHSOM(Samples(:,InputNdx),Model.Child{NdxNeuro});         
    end    
end
