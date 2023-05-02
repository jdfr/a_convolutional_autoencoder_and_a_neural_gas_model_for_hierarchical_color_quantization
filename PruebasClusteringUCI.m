% Pruebas Clustering de data sets de la UCI para los modelos GNF, GNG y SOM
clear all
fprintf('\nClustering UCI Data Sets\n');

NumEpocas = 2;
MaxNeurons = 50; % Maximum number of neurons in each graph
NumRows = 10;
NumCols = 5;
NumRepeticiones = 10;
Metodos = {'GNF','GNG','SOM'};
NumMetodos = length(Metodos);
NomFichModelos = 'Modelos_ClusteringUCI';
NomFichResultados = 'Resultados_ClusteringUCI';

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Leemos los conjuntos de datos del directorio
Datasets = dir('Datos*.mat');
NumDatasets = length(Datasets);
DatasetsValidos = 1:NumDatasets;
Time = zeros(NumDatasets,NumRepeticiones);
MSE = zeros(NumDatasets,NumRepeticiones);
PSNR = zeros(NumDatasets,NumRepeticiones);
DB = zeros(NumDatasets,NumRepeticiones);
CS = zeros(NumDatasets,NumRepeticiones);

for NdxMetodo=1:NumMetodos,
    
    MiMetodo = Metodos{NdxMetodo};
    fprintf('\nMÉTODO=%s\n',MiMetodo);
    
    % Cargamos los modelos
    if exist(['./' NomFichModelos '_' MiMetodo '.mat'],'file')==0,
            Modelos = cell(NumDatasets,NumRepeticiones);
        else
            load(['./' NomFichModelos '_' MiMetodo '.mat'],'Modelos');
    end
        
    for NdxDataset=1:NumDatasets,
        
        MiDataset = strrep(strrep(Datasets(NdxDataset).name,'Datos',''),'.mat','');
        fprintf('\tDATASET=%s\n',MiDataset);
        
        % Cargamos las muestras
        load(Datasets(NdxDataset).name);
        Muestras = ConvertirDatosEzeq2Esteban(Datos);
        Muestras = Muestras(1:end-1,:); % quitamos la etiqueta        
        NumMuestras = size(Muestras,2);
        NumPasos = NumEpocas*NumMuestras;
        Muestras = NormalizeData(Muestras);
                       
        for NdxRepeticion=1:NumRepeticiones,                 

            if isempty(Modelos{NdxDataset,NdxRepeticion}),
                fprintf('\t\t%d - Training %s\n',NdxRepeticion,MiMetodo);                
                switch MiMetodo
                    case 'GNF'
                        tic;
                        [Modelo] = TrainGNF(Muestras,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
                        Time(NdxRepeticion) = toc;
                    case 'GNG'
                        tic;
                        [Modelo] = TrainGNG(Muestras,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
                        Time(NdxRepeticion) = toc;
                    case 'SOM'
                        tic;
                        % SOM Training using the SOM Toolbox        
                        SOMModel = som_make(Muestras','randinit','seq','msize',[NumRows NumCols],...
                            'rect','sheet','gaussian','tracking',0); 
                        Time(NdxRepeticion) = toc;
                        Modelo.Samples = Muestras;
                        Modelo.Means = SOMModel.codebook';
                        [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);        
                        Modelo.Winners = Winners;
                        Modelo.Errors = Errors;
                end
                
                if isempty(Modelo),
                    continue;
                end
                Modelos{NdxDataset,NdxRepeticion} = Modelo; 
                save(['./' NomFichModelos '_' MiMetodo '.mat'],'Modelos');
            else
                fprintf('\t\t%d - Modelo %s Entrenado\n',MiMetodo);        
                Modelo = Modelos{NdxDataset,NdxRepeticion};
            end            
            
            % Calculamos el MSE, PSNR, DB y los Coeficientes de Silueta
            [Winners,Errors] = TestGNG(Modelo,Muestras);
%             NdxNaNUnits = find(isnan(Model.Means(1,:)));
            MSE(NdxDataset,NdxRepeticion) = nanmean(Errors);
            MAX_I = (max(max(Muestras)) - min(min(Muestras)))^2;
            PSNR(NdxDataset,NdxRepeticion) = 10*log10(MAX_I/MSE(NdxDataset,NdxRepeticion));
            DB(NdxDataset,NdxRepeticion) = db_index(Modelo.Samples',Winners,Modelo.Means');
            CS(NdxDataset,NdxRepeticion) = nanmean(silhouetteMEX(Muestras,Winners'-1,max(Winners)));            
        end  
        save(['./' NomFichResultados '_' MiMetodo '.mat'],'MSE','PSNR','DB','CS','Time');
    end    
end  

% pause
clc
% Mostramos los Resultados
for NdxMetodo=1:NumMetodos,
    
    MiMetodo = Metodos{NdxMetodo};
    fprintf('\nMétodo=%s\n',MiMetodo);
    
    % Cargamos los resultados
    load(['./' NomFichResultados '_' MiMetodo '.mat'],'MSE','PSNR','DB','CS','Time');
        
    for NdxDataset=1:NumDatasets,
        MiDataset = strrep(strrep(Datasets(NdxDataset).name,'Datos',''),'.mat','');
        fprintf('\tDataset=%s\n',MiDataset);
                
        MiMSE = MSE(NdxDataset,:);
        MiPSNR = PSNR(NdxDataset,:);
        MiDB = DB(NdxDataset,:);
        MiCS = CS(NdxDataset,:);
        MiTime = Time(NdxDataset,:);
        fprintf('%2.2f (%2.2f) & %2.2f (%2.2f) & %2.2f (%2.2f) & %2.2f (%2.2f) & %2.2f (%2.2f)\n',...
            mean(MiMSE),std(MiMSE),mean(MiPSNR),std(MiPSNR),mean(MiDB),std(MiDB),mean(MiCS),std(MiCS),mean(MiTime),std(MiTime));
    end
end

