function NdxNeigbors = GetNeighborsMap(P,NdxNeuron)
% *************************************************************************
% Descripción: función que halla las neuronas vecinas de una neurona de
%              referencia en una cuadrícula, considerando la dist. rectang.
% Entrada:
%   P:              matriz de posiciones de las neuronas en el mapa
%   NdxNeuron:    neurona de referencia
%   tipo_distancia: 'euclidea' distancia euclídea / 'rectangular' distancia
%                   rectangular
% Salida:
%   NdxNeigbours: vector de índices de las neuronas vecinas de neurona_ref
% *************************************************************************

% Compute the row and column of the neuron
[Row,Column] = find(P == NdxNeuron);

if Row > 1,
    R1 = Row-1;
else
    R1 = 1;
end

if Row < size(P,1),
    R2 = Row+1;
else
    R2 = size(P,1);
end

if Column > 1,
    C1 = Column-1;
else
    C1 = 1;
end

if Column < size(P,2),
    C2 = Column+1;
else
    C2 = size(P,2);
end

NdxNeigbors = sort([P(R1:R2,Column)' P(Row,C1:C2)]);
NdxNeigbors(NdxNeigbors == NdxNeuron) = [];