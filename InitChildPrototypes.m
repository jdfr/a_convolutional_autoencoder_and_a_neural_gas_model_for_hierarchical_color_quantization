function ChildPrototypes = InitChildPrototypes(Prototypes,NdxParent)

% Parent Map Initialization
[Dimension,NumParentMapRows,NumParentMapCols] = size(Prototypes);
NumParentNeurons = NumParentMapRows*NumParentMapCols;
ParentPos = zeros(NumParentMapRows,NumParentMapCols);
ParentPos((1:NumParentNeurons)) = (1:NumParentNeurons);
[PRow,PCol] = find(ParentPos == NdxParent);
ParentW  = reshape(Prototypes,Dimension,NumParentNeurons);

% Child Map Initialization
NumChildMapRows = 2;
NumChildMapCols = 2;
NumChildNeurons = NumChildMapRows*NumChildMapCols;
ChildPrototypes = zeros(Dimension,NumChildMapRows,NumChildMapCols);
ChildPos = zeros(NumChildMapRows,NumChildMapCols);
ChildPos((1:NumChildNeurons)) = (1:NumChildNeurons);

%% Child Weight Vectors Initialization
for NdxNeuro=1:NumChildNeurons,    
    
    % Get parent's neighbors in an area
    NdxParentNeigbors = GetMapAreaNeighbors(ParentPos',NdxParent,NdxNeuro);

    if isempty(NdxParentNeigbors),
        WeightVector = Prototypes(:,PRow,PCol);
    else
%         [R,C]=ind2sub(size(ParentPos),NdxParentNeigbors);
        NumParentNeigbors = length(NdxParentNeigbors);
        WeightVector = sum(ParentW(:,NdxParentNeigbors) - repmat(Prototypes(:,PRow,PCol),1,NumParentNeigbors),2);
        WeightVector = WeightVector/NumParentNeigbors + Prototypes(:,PRow,PCol);
    end    
    [CRow,CCol] = find(ChildPos == NdxNeuro);
    ChildPrototypes(:,CRow,CCol) = WeightVector;    
end