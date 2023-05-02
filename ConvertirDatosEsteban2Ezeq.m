function Datos = ConvertirDatosEsteban2Ezeq(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descripción:
%   Función que convierte un conjunto de datos en formato Esteban a
%   formato Ezequiel
% Entrada:
%   - X: conjunto de datos en formato Esteban (columnas=patrones y
%     filas=atributos)
% Salida:
%   - Datos: conjunto de datos en formato Ezequiel (agrupados por clases)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Etiquetas = X(end,:);
Datos.NumClases = max(Etiquetas);

for i=1:Datos.NumClases,
    
    ind = find(Etiquetas == i);
    Datos.Muestras{i} = X(1:end-1,ind);       
end