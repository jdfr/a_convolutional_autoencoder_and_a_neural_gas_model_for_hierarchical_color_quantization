clear

Modelo = 'DivergenciasBregman';
%Nombres = {'Baboon','Lake','Lena','House','Milk','Pepper','Plane','Tiffany'};
Nombres = {'Baboon','Lake','Lena','House'};
NumDataSets = length(Nombres);
Campos={'MSE','PSNR','SSIM','AD','MD','NAE','NCC','SC','TiempoEntrenamiento'};
NumCampos = length(Campos);
%MaxNeurons = [10 20 30 40 50]; % Maximum number of neurons in each graph
Divergences = {'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};
%NumMaxNeurons = length(MaxNeurons);
NumDivergences = length(Divergences);
NumEntrenamientos = 10;

EvaluacionesGlobal = cell(NumEntrenamientos,NumDivergences,NumDataSets);
ResultadosGlobal = cell(NumDivergences,NumDataSets);
ModelosGlobal = cell(NumDivergences,NumDataSets);
NomFichResultados = ['ResultadosCuantificacion' Modelo];
NomFichEvaluaciones = ['EvaluacionesCuantificacion' Modelo];
NomFichModelos = ['ModelosCuantificacion' Modelo];

load(NomFichResultados,'Resultados');

%% Obtenemos los datos formateados
DatosForm = cell(NumDataSets,NumCampos,NumDivergences);
    
for NdxDataset=1:NumDataSets,
    for NdxDivergences=1:NumDivergences,               
        for NdxCampo=1:NumCampos,            
            MiCampo = getfield(Resultados{NdxDivergences,NdxDataset},Campos{NdxCampo});
            DatosForm{NdxDataset,NdxCampo,NdxDivergences} = sprintf('%6.4f (%.2f)',MiCampo.Media,MiCampo.DesvTip);        
        end
    end % NdxTau 
end % dataset    

%% Escribimos los resultados en Excel
for NdxDivergences=1:NumDivergences,
    xlswrite([NomFichResultados '.xlsx'],[[{''} Campos]; [Nombres' DatosForm(:,:,NdxDivergences)]],num2str(Divergences{NdxDivergences}));       
end