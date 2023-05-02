function NewW = InsertNeuronsMap(W,P,NdxNeuron1,NdxNeuron2)
% *************************************************************************
% Descripción: función que inserta una fila o columna de nueronas en el
%              mapa entre la neurona de error 'e' y las más disimilar 'd',
%              haciendo crecer el mapa
% Entrada:
%   W:          prototypes matrix of DxNxM (D=Dimensions,N=Rows and M=Cols)
%   P:          matriz de posiciones de las neuronas en el mapa
%   NdxNeuron1: índice de la nuerona de error del mapa 'e'
%   NdxNeuron2: índice de la nuerona de error del mapa 'e'
% Salida:
%   NewW:          matriz de pesos de las neuronas del mapa resultante
% *************************************************************************

% Get the row and column of the neurons
[R(1),C(1)] = find(P == NdxNeuron1);
[R(2),C(2)] = find(P == NdxNeuron2);   
[Dimension,NumMapRows,NumMapCols] = size(W);

if (abs(R(1) - R(2)) > 0),    
    %% Insert a Row     
    fprintf('\nAdding a row (%d neurons)\n',NumMapCols);       
    
    WeightVectors = zeros(Dimension,1,NumMapCols);
    for NdxCol=1:NumMapCols,
        WeightVectors(:,1,NdxCol) = mean([W(:,R(1),NdxCol) W(:,R(2),NdxCol)],2);        
    end   
    R = sort(R);
    NewW = zeros(Dimension,NumMapRows+1,NumMapCols);    
    NewW(:,1:R(1),:) = W(:,1:R(1),:);
    NewW(:,R(1)+1,:) = WeightVectors;
    NewW(:,R(1)+2:end,:) = W(:,R(1)+1:end,:);        
else
    %% Insert a Column
    fprintf('\nAdding a column (%d neurons)\n',NumMapRows);       

    WeightVectors = zeros(Dimension,NumMapRows,1);
    for NdxRow=1:NumMapRows,
        WeightVectors(:,NdxRow,1) = mean([W(:,NdxRow,C(1)) W(:,NdxRow,C(2))],2);        
    end
    C = sort(C);
    NewW = zeros(Dimension,NumMapRows,NumMapCols+1);  
    NewW(:,:,1:C(1)) = W(:,:,1:C(1));
    NewW(:,:,C(1)+1) = WeightVectors;
    NewW(:,:,C(1)+2:end) = W(:,:,C(1)+1:end);      
end