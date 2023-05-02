function [Model]=InitializeGHSOM(Model,Samples,NumRowsMap,NumColsMap,NewPrototypes)
% Initialize a Growing Hierarchical Self-Organizing Map (GHSOM)
% Inputs:
%   Model=GHSOM model
%   Samples=Input samples (one sample per column)
%   NumRowsMap,NumColsMap=Size of the self-organizing map
%   NewPrototypes=Initial prototypes determined by the parent and its
%       neighbors (only for child maps)
% Output:
%   Model=GHSOM model initialized
% See also:
% Rauber et al (2002). The growing hierarchical self-organizing map: 
% Exploratory analysis of high-dimensional data. IEEE Trans. on Neural
% Networks. 13(6):1331–1341.

fprintf('Initializing GHSOM...\n')

[Dimension,NumSamples]=size(Samples);
NumNeuro=NumRowsMap*NumColsMap; 

if isempty(Model),                       
    
    Model.Dimension=Dimension;            

    % Prototypes initialization
    NumPatIni=max([Dimension+1,ceil(NumSamples/(NumRowsMap*NumColsMap))]);
    Model.Prototypes=zeros(Dimension,NumRowsMap,NumColsMap);
    if isempty(NewPrototypes),        
        % Initialize randomly the prototypes            
        for NdxRow=1:NumRowsMap
            for NdxCol=1:NumColsMap
                MySamples=Samples(:,ceil(NumSamples*rand(1,NumPatIni)));
                Model.Prototypes(:,NdxRow,NdxCol)=mean(MySamples,2);                        
            end
        end        
    else        
        % Initialization of the prototypes as the mean of their parent and
        % the parent's neighbors.
        Model.Prototypes = NewPrototypes;
    end    
end

Model.NumColsMap=NumColsMap;
Model.NumRowsMap=NumRowsMap;

% Precompute topological distances
[AllXCoords AllYCoords]=ind2sub([NumRowsMap NumColsMap],1:NumNeuro);
AllCoords(1,:)=AllXCoords;
AllCoords(2,:)=AllYCoords;
TopolDist=cell(NumNeuro,1);
for NdxNeuro=1:NumNeuro    
    TopolDist{NdxNeuro}=sum((repmat(AllCoords(:,NdxNeuro),1,NumNeuro)-AllCoords).^2,1);
end
Model.TopolDist = TopolDist;
    
        
