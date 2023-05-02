% Pruebas Cuantificación de Imágenes de varios Modelos Competidores
% Ejecutar dentro de subcarpeta 'Pruebas Cuantifcación'
% E.J. Palomo, Junio 2020
clear all

NumEpocas = 2;
NumEntrenamientos = 10;
MaxNeurons = 50; % Maximum number of neurons in each graph
% Models = {'GHNG','GHSOM','GNG','SOM','k-means'};
Models = {'GHNG','GHSOM','GNG','SOM'};
NomFichResultados = 'ResultadosCuantificacion';
NomFichEvaluaciones = 'EvaluacionesCuantificacion';
NomFichModelos = 'ModelosCuantificacion';
RutaImagenes = './images/';

MiTau = 0.1;
MiTau1 = 0.001; % GHSOM
MiTau2 = 0.0001; % GHSOM
ErrorType='abs'; % GHSOM
% Este parámetros lo hemos sacado del número de neuronas obtenidos por el
% GHBNG para cada dataset (la divergencia escogida es la del máximo PSNR)
MaxNeuronsGNG = [12883 11073 10151 11678]; % GNG, k-means

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Leemos las imágenes del directorio en formato matriz
d = dir([RutaImagenes '*.tiff']);

Handle=zeros(1,numel(Models));

MiFichero = [NomFichResultados '.mat'];
if exist(['./' MiFichero],'file')
    % Cargamos los resultados ya hechos
    load(MiFichero,'Resultados');            
else
    Resultados = cell(length(Models),length(d));
end

MiFichero = [NomFichEvaluaciones '.mat'];
if exist(['./' MiFichero],'file')
    % Cargamos los evaluaciones ya hechas
    load(MiFichero,'Evaluaciones');
else
    Evaluaciones = cell(NumEntrenamientos,length(Models),length(d));
end

% MiFichero = [NomFichModelos '.mat'];
% if exist(['./' MiFichero],'file')
%     % Cargamos los modelos ya entrenados
%     load(MiFichero,'Modelos');
% else
%     Modelos = cell(length(Models),length(d));
% end

for NdxDataset=1:4
    % Generate data from image
    ImgOriginal = imread([RutaImagenes d(NdxDataset).name]);
    ImgDoubleNormalizada = double(ImgOriginal)/255;
    Muestras = reshape(shiftdim(ImgDoubleNormalizada,2),3,[]);
%     % Cargamos la imagen original
    ind = strfind(d(NdxDataset).name,'.');
    NomFich = d(NdxDataset).name(1:ind-1);
%     fprintf('\nIMAGEN: %s\n',NomFich);
%     load([RutaImagenes d(NdxDataset).name],'s');
%     ImgOriginal = s.frame;
%     Muestras = s.m;
    NumMuestras = size(Muestras,2);
    
    % Número de neuronas para los modelos planos
    MiMaxNeurons = MaxNeuronsGNG(NdxDataset);
    NumRowsMap = double(floor(sqrt(MiMaxNeurons)));
    NumColsMap = NumRowsMap;
    if (NumRowsMap*(NumColsMap+1) <= MiMaxNeurons)
        NumColsMap = NumColsMap + 1;
    end
    
    for NdxModelo=1:length(Models)
        MiModelo = Models{NdxModelo};                                          
        fprintf('\nIMAGEN: %s\n',d(NdxDataset).name);
        fprintf('\nMODELO: %s\n',MiModelo);    
        Modelo = [];
        
        if ~isempty(Resultados{NdxModelo,NdxDataset})
            fprintf('\tEvitando repetir los 10 entrenamientos\n');            
        else
            MejorModelo = [];
            for NdxRepeticion=1:NumEntrenamientos                
                fprintf('\tENTRENAMIENTO %d\n',NdxRepeticion);            
                if ~isempty(Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset})
                    fprintf('\t\tEvitando repetir un entrenamiento\n');
%                     Modelo = Modelos{NdxModelo,NdxDataset};                                        
                    if isempty(Modelo)
                        % Cargamos el último modelo guardado
                        load(['Modelo' MiModelo '_' d(NdxDataset).name '.mat'],'Modelo');
                    end
                    EntrenamientoOk = 1;                    
                    CpuTime = -1;
                else
                    EntrenamientoOk=1;
                    Hecho=0;
                    Intentos=0;
                    while Hecho==0
                        try
                            if strcmp(MiModelo,'GHNG')
                                fprintf('\t\tTau: %g\n',MiTau);
                                tic;
                                [Modelo] = TrainGHNG3(Muestras,NumEpocas,MaxNeurons,MiTau,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,1);
                                CpuTime = toc;
                            elseif strcmp(MiModelo,'GHSOM')
                                fprintf('\t\tTau1: %g / Tau2: %g\n',MiTau1,MiTau2);
                                % Compute the mean of the samples (initial weight vector)
                                IniWeight = full(nansum(Muestras,2)/NumMuestras);

                                % Compute the initial Bregman quantization errror (qe0)
                                IniQE = QuantizationError(IniWeight,Muestras,ErrorType);
                                tic;
                                [Modelo] = TrainGHSOM(Muestras,(1:NumMuestras),NumEpocas,MiTau1,MiTau2,ErrorType,IniQE,IniQE,[],1);
                                CpuTime = toc;
                                Modelo.Samples = Muestras;
                            elseif strcmp(MiModelo,'GNG')                            
                                fprintf('\t\tNúmero Neuronas: %d\n',MiMaxNeurons);
                                tic;
                                [Modelo] = TrainGNG(Muestras,MiMaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumMuestras*NumEpocas);
                                CpuTime = toc;
                            elseif strcmp(MiModelo,'SOM')
                                fprintf('\t\tTamaño: %dx%d\n',NumRowsMap,NumColsMap);
                                tic;
                                [Modelo] = TrainKohonenSOM(Muestras,NumRowsMap,NumColsMap,NumMuestras*NumEpocas);
                                CpuTime = toc;
                                Modelo.Samples = Muestras;
                            elseif strcmp(MiModelo,'k-means')
                                fprintf('\t\tNúmero Neuronas: %d\n',MiMaxNeurons);
                                tic;
                                [W,ganadoras,err] = som_kmeans('seq',Muestras',MiMaxNeurons,NumEpocas);                                                   
                                CpuTime = toc;
                                Modelo = [];
                                Modelo.Means = W';
                                Modelo.Samples = Muestras;                            
                            end
                            fprintf('\t\tEntrenamiento Finalizado en %g segundos\n',CpuTime);
                            Hecho=1;
                            if isempty(Modelo),
                                EntrenamientoOk = 0;
                                fprintf('\t\tEntrenamiento No OK\n');
                            end
                        catch e
                            fprintf('\t\tError en entrenamiento\n');
                            e.message
                            e.stack
                            Intentos=Intentos+1;
                            clear functions
                        end
                        Hecho=Hecho | (Intentos>9);
                        if (Intentos>9)
                            EntrenamientoOk=0;
                        end
                    end % while
                end

                if EntrenamientoOk && isempty(Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset})

                    % Evaluamos la compresión hecha
                    if CpuTime >= 0, % si el entrenamiento fue realizado (no cargado) 
                        % Obtenemos los centroides
                        if strcmp(MiModelo,'GHNG')
                            Centroids = GetCentroidsGHNG(Modelo);                        
                        elseif strcmp(MiModelo,'GHSOM')
                            Centroids = GetCentroidsGHSOM(Modelo);                        
                        else
                            Centroids = Modelo.Means;                        
                        end
                        % Obtenemos las ganadaras
                        [Winners,Errors] = TestGHNG(Centroids,Modelo.Samples);
                        Modelo.Winners = Winners;

                       % Obtenemos la imagen de los prototipos                                        
                        ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
                        Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset} = evaluarCompresionImagenCompleto(ImgOriginal,ImgProt);                    
                        Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.TiempoEntrenamiento = CpuTime;
                        if strcmp(MiModelo,'GHNG')                        
                            [~,Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.NumNeurons] = GetNumberNeuronsGHNF(Modelo);
                        elseif strcmp(MiModelo,'GHSOM')
                            [~,Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.NumNeurons] = GetNumberNeuronsGHSOM(Modelo);
                        elseif strcmp(MiModelo,'SOM')
                            Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.NumNeurons = NumRowsMap*NumColsMap;
                        else
                            Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.NumNeurons = MiMaxNeurons;
                        end
                        save([NomFichEvaluaciones '.mat'],'Evaluaciones');
                        fprintf('\t\tNumber of Neurons: %d\n',Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.NumNeurons);                                        
                    end                                
                end

                % Obtenemos el mejor modelo (el de máximo PSNR)
                % NOTA: si diera un fallo antes de guardar el mejor modelo,
                % hay que borrar la última evaluación hecha
                if isempty(MejorModelo)
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                elseif Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.PSNR > MaximoPSNR
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxModelo,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                end
                
                % Guardamos el mejor modelo
                Modelo = MejorModelo;
                save(['Modelo' MiModelo '_' d(NdxDataset).name '.mat'],'Modelo','-v7.3');
            end % for NdxRepeticion
        
            % Realizamos la validación cruzada
            Resultados{NdxModelo,NdxDataset} = ValidacionCruzadaCompresionCompleto(Evaluaciones(:,NdxModelo,NdxDataset)');
            save([NomFichResultados '.mat'],'Resultados');            
        end
              
%         % Guardamos la imagen del mejor modelo
%         if strcmp(MiModelo,'GHNG')
%             Centroids = GetCentroidsGHNG(MejorModelo);                        
%         elseif strcmp(MiModelo,'GHSOM')
%             Centroids = GetCentroidsGHSOM(MejorModelo);                        
%         else
%             Centroids = MejorModelo.Means;                        
%         end
%         % Obtenemos las ganadaras
%         [Winners,Errors] = TestGHNG(Centroids,MejorModelo.Samples);
%         
%         ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
%         fig = figure;
%         set(fig,'name',['Modelo ' MiModelo '_' NomFich]);
%         set(fig,'NumberTitle','off');
%         imshow(ImgProt);
%         saveas(gcf,['Modelo ' MiModelo '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
%         
%         % Guardamos la imagen de diferencias ampliada 20 veces
%         fig = figure;
%         set(fig,'name',['Modelo ' MiModelo '_' NomFich]);
%         set(fig,'NumberTitle','off');
%         ImgDif = abs(ImgDoubleNormalizada-ImgProt);
%         imshow(ImgDif);  
%         saveas(gcf,['Modelo_Diff_' MiModelo '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
        
        % if imagewn es lena
        % for 1 to 3
        % prune
        %test ghbng
        %ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
        %ImgDif = abs(ImgDoubleNormalizada-ImgProt);
%         imshow(ImgDif);  
%         saveas(gcf,['GNF_Diff_' num2str(MyMaxNeurons) '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
    end % for MaxNeruons
    close all
    
end % for dataset

% Mostramos los resultados finales y rellenamos la matriz de resultados
% dejando hueco para los resultados del GHBNG
MatrizResultados = zeros(length(Models)+1,4,4);
for NdxMedida=1:4
    for NdxDataset=1:4
        fprintf('\nIMAGEN: %s\n',d(NdxDataset).name);
        for NdxModelo=1:4
            MiModelo = Models{NdxModelo};                                          
            fprintf('MODELO: %s\n',MiModelo);             
            fprintf('MSE=%g / PSNR=%g / SSIM=%g / NCC=%g\n',Resultados{NdxModelo,NdxDataset}.MSE.Media,Resultados{NdxModelo,NdxDataset}.PSNR.Media,Resultados{NdxModelo,NdxDataset}.SSIM.Media,Resultados{NdxModelo,NdxDataset}.NCC.Media);            
            if NdxMedida==1 % MSE
                MatrizResultados(NdxModelo+1,NdxDataset,NdxMedida) = Resultados{NdxModelo,NdxDataset}.MSE.Media;
            elseif NdxMedida==2 % PSNR
                MatrizResultados(NdxModelo+1,NdxDataset,NdxMedida) = Resultados{NdxModelo,NdxDataset}.PSNR.Media;
            elseif NdxMedida==3 % SSIM
                MatrizResultados(NdxModelo+1,NdxDataset,NdxMedida) = Resultados{NdxModelo,NdxDataset}.SSIM.Media;
            elseif NdxMedida==4 % NCC
                MatrizResultados(NdxModelo+1,NdxDataset,NdxMedida) = Resultados{NdxModelo,NdxDataset}.NCC.Media;
            end
        end
    end
end

% Obtenemos los mejores resultados del GHBNG y los metemos en la matriz de
% resultados con los resultados del resto de modelos
load('ResultadosCuantificacionDivergenciasBregman.mat','ResultadosGHBNG');
Medidas = {'MSE','PSNR','SSIM','NCC'};
for NdxMedida=1:numel(Medidas)
    for NdxDataset=1:4
        NdxMejorDivergencia = 1;
        for NdxDivergencia=2:size(ResultadosGHBNG,1)       
            if NdxMedida==1 % MSE
                if ResultadosGHBNG{NdxDivergencia,NdxDataset}.MSE.Media < ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.MSE.Media 
                   NdxMejorDivergencia = NdxDivergencia;
               end
            elseif NdxMedida==2 % PSNR
                if ResultadosGHBNG{NdxDivergencia,NdxDataset}.PSNR.Media > ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.PSNR.Media 
                   NdxMejorDivergencia = NdxDivergencia;
               end
            elseif NdxMedida==3 % SSIM
                if ResultadosGHBNG{NdxDivergencia,NdxDataset}.SSIM.Media > ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.SSIM.Media 
                   NdxMejorDivergencia = NdxDivergencia;
               end
            elseif NdxMedida==4 % NCC
                if ResultadosGHBNG{NdxDivergencia,NdxDataset}.NCC.Media > ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.NCC.Media 
                   NdxMejorDivergencia = NdxDivergencia;
               end
            end           
        end
        if NdxMedida==1 % MSE
            MatrizResultados(1,NdxDataset,NdxMedida) = ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.MSE.Media ;
        elseif NdxMedida==2 % PSNR
            MatrizResultados(1,NdxDataset,NdxMedida) = ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.PSNR.Media ;
        elseif NdxMedida==3 % SSIM
            MatrizResultados(1,NdxDataset,NdxMedida) = ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.SSIM.Media ;
        elseif NdxMedida==4 % NCC
            MatrizResultados(1,NdxDataset,NdxMedida) = ResultadosGHBNG{NdxMejorDivergencia,NdxDataset}.NCC.Media ;
        end    
    end
end

% Calculamos los rank sums
% Models = {'GHBNG','GHNG','GHSOM','GNG','SOM'};
Models = {'GHBNG','GHNG','GHSOM'};
for NdxMedida=1:numel(Medidas)
    fprintf('\nMEDIDA: %s\n',Medidas{NdxMedida});  
    if NdxMedida==1
        R = tiedrank(MatrizResultados(1:3,:,NdxMedida));
    else
        R = tiedrank(-MatrizResultados(1:3,:,NdxMedida));
    end
    RankSums = sum(R,2);
    fprintf('RANK SUMS\n');
    for NdxModelo=1:length(Models)
        fprintf('\t%s: %g\n',Models{NdxModelo},RankSums(NdxModelo));
    end
end
        