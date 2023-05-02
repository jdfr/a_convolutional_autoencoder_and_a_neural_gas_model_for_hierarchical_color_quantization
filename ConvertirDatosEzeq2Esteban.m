function X = ConvertirDatosEzeq2Esteban(Datos)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descripción:
%   Función que convierte un conjunto de datos en formato Ezequiel a
%   formato Esteban
% Entrada:
%   - Datos: conjunto de datos en formato Ezequiel
% Salida:
%   - X: conjunto de datos en formato Esteban
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = [];

for i=1:Datos.NumClases,
    
    etiq(1:size(Datos.Muestras{i},2)) = i;
    X = [X [Datos.Muestras{i};etiq]];
    
    clear etiq;
end