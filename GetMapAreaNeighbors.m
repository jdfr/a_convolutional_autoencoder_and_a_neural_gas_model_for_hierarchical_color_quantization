function NdxAreaNeighbors = GetMapAreaNeighbors(P,NdxNeuron,Area)
% *************************************************************************
% Descripción: función que halla una Area de las neuronas vecinas a partir
%              de una neurona de referencia. Cada Area la constituyen 3
%              neuronas sin contar con la de referencia.
% Entrada:
%   P:           matriz de posiciones con los índices absolutos de las
%                neuronas
%   NdxNeuron: neurona de referencia (índice absoluto)
%   Area:        1 Area arriba izda / 2 Area arriba derecha / 3 Area abajo
%                izda / 4 Area abajo derecha
% Salida:
%   v_zona: vector de índices de las neuronas vecinas en una Area de la 
%           NdxNeuron
% *************************************************************************

NdxAreaNeighbors = [];
[RefRow,RefCol] = find(P == NdxNeuron);

if (Area == 1),
    R1 = RefRow-1;
    R2 = RefRow;
    C1 = RefCol-1;
    C2 = RefCol;
                
elseif (Area == 2),
    R1 = RefRow-1;
    R2 = RefRow;
    C1 = RefCol;
    C2 = RefCol+1;
    
elseif (Area == 3),
    R1 = RefRow;
    R2 = RefRow+1;
    C1 = RefCol-1;
    C2 = RefCol;
        
elseif (Area == 4),
    R1 = RefRow;
    R2 = RefRow+1;
    C1 = RefCol;
    C2 = RefCol+1;       
end

for i=R1:R2,
    for j=C1:C2,
        if (i > 0) && (i <= size(P,1)) && (j > 0) && (j <= size(P,2)) && ...
                ((i~=RefRow) || (j~=RefCol)), % no incluimos a la neurona de referencia
            NdxAreaNeighbors = [NdxAreaNeighbors P(i,j)];
        end
    end
end 