clear

% Modelo = 'DivergenciasBregman';
% %Nombres = {'Baboon','Lake','Lena','House','Milk','Pepper','Plane','Tiffany'};
Modelos = {'GHNG', 'GHSOM', 'GNG', 'SOM'};
NumModelos = length(Modelos);
Imagenes = {'Baboon','House', 'Lake','Lena'};
NumImagenes = length(Imagenes);
MedidasRendimiento={'MSE','PSNR','SSIM','AD','MD','NAE','NCC','SC','TiempoEntrenamiento', 'NumNeurons'};
NumMedidasRendimiento = length(MedidasRendimiento);
% %MaxNeurons = [10 20 30 40 50]; % Maximum number of neurons in each graph
% Divergences = {'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};
% %NumMaxNeurons = length(MaxNeurons);
% NumDivergences = length(Divergences);
% NumEntrenamientos = 10;
% 
% EvaluacionesGlobal = cell(NumEntrenamientos,NumDivergences,NumDataSets);
% ResultadosGlobal = cell(NumDivergences,NumDataSets);
% ModelosGlobal = cell(NumDivergences,NumDataSets);
% NomFichResultados = ['ResultadosCuantificacion' Modelo];
NomFichResultados = 'ResultadosCuantificacion';
% % NomFichEvaluaciones = ['EvaluacionesCuantificacion' Modelo];
% % NomFichModelos = ['ModelosCuantificacion' Modelo];

load(NomFichResultados,'Resultados');


%Resultados{1,1}.MSE.Media


%% Obtenemos los datos formateados
DatosForm = cell(NumMedidasRendimiento, NumImagenes,NumModelos);
    
for NdxModelo=1:NumModelos,
    for NdxImagen=1:NumImagenes,               
        for NdxMedidasRendimiento=1:NumMedidasRendimiento,            
            MiCampo = getfield(Resultados{NdxModelo,NdxImagen},MedidasRendimiento{NdxMedidasRendimiento});
            DatosForm{NdxMedidasRendimiento,NdxImagen,NdxModelo} = sprintf('%6.4f (%.2f)',MiCampo.Media,MiCampo.DesvTip);        
        end
    end % NdxTau 
end % dataset    

%% Escribimos los resultados en Excel
for NdxModelo=1:NumModelos,
    xlswrite([NomFichResultados 'Competidores' '.xlsx'],[[{''} Imagenes]; [MedidasRendimiento' DatosForm(:,:,NdxModelo)]],num2str(Modelos{NdxModelo}));       
end