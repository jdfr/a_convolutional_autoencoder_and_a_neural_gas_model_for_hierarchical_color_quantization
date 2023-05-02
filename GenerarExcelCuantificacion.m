clear

Modelo = 'GNG';
Nombres = {'Baboon','Lake','Lena','House','Milk','Pepper','Plane','Tiffany'};
NumDataSets = length(Nombres);
Campos={'MSE','PSNR','SSIM','AD','MD','NAE','NCC','SC','TiempoEntrenamiento'};
NumCampos = length(Campos);
MaxNeurons = [10 20 30 40 50]; % Maximum number of neurons in each graph
NumMaxNeurons = length(MaxNeurons);
NumEntrenamientos = 10;

EvaluacionesGlobal = cell(NumEntrenamientos,NumMaxNeurons,NumDataSets);
ResultadosGlobal = cell(NumMaxNeurons,NumDataSets);
ModelosGlobal = cell(NumMaxNeurons,NumDataSets);
NomFichResultados = ['ResultadosCuantificacion' Modelo];
NomFichEvaluaciones = ['EvaluacionesCuantificacion' Modelo];
NomFichModelos = ['ModelosCuantificacion' Modelo];

load(NomFichResultados,'Resultados');

%% Obtenemos los datos formateados
DatosForm = cell(NumDataSets,NumCampos,NumMaxNeurons);
    
for NdxDataset=1:NumDataSets,
    for NdxMaxNeurons=1:NumMaxNeurons,               
        for NdxCampo=1:NumCampos,            
            MiCampo = getfield(Resultados{NdxMaxNeurons,NdxDataset},Campos{NdxCampo});
            DatosForm{NdxDataset,NdxCampo,NdxMaxNeurons} = sprintf('%6.4f (%.2f)',MiCampo.Media,MiCampo.DesvTip);        
        end
    end % NdxTau 
end % dataset    

%% Escribimos los resultados en Excel
for NdxMaxNeurons=1:NumMaxNeurons,
    xlswrite([NomFichResultados '.xlsx'],[[{''} Campos]; [Nombres' DatosForm(:,:,NdxMaxNeurons)]],num2str(MaxNeurons(NdxMaxNeurons)));       
end