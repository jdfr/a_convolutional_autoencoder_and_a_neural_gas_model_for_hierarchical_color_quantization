% Pruebas Cuantificación de Imágenes para el GNF
clear all

NumEpocas = 2;
NumEntrenamientos = 10;
MaxNeurons = [10 20 30 40 50]; % Maximum number of neurons in each graph
NomFichResultados = 'ResultadosCuantificacionGNF';
NomFichEvaluaciones = 'EvaluacionesCuantificacionGNF';
NomFichModelos = 'ModelosCuantificacionGNF';
RutaImagenes = './images/';

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 19;
EpsilonB = 0.1;
EpsilonN = 0.007;
Alpha = 0.1;
AMax = 48;
D = 0.987;

% Leemos las imágenes del directorio en formato matriz
d = dir([RutaImagenes '*.tiff']);

% IMAGEN
for NdxDataset=1:length(d),
    
    % Generate data from image
    ImgOriginal = imread(d(NdxDataset).name);
    ImgDoubleNormalizada = double(ImgOriginal)/255;
    Muestras = reshape(shiftdim(ImgDoubleNormalizada,2),3,[]);
%     % Cargamos la imagen original
    ind = strfind(d(NdxDataset).name,'.');
    NomFich = d(NdxDataset).name(1:ind-1);
%     fprintf('\nIMAGEN: %s\n',NomFich);
%     load([RutaImagenes d(NdxDataset).name],'s');
%     ImgOriginal = s.frame;
%     Muestras = s.m;
    NumPasos = size(Muestras,2)*NumEpocas;
    
    for NdxMaxNeurons=1:length(MaxNeurons),
        MyMaxNeurons = MaxNeurons(NdxMaxNeurons);
        fprintf('\tNUM NEURONS: %d\n',MyMaxNeurons);
        
        MiFichero = [NomFichResultados '.mat'];
        if exist(['./' MiFichero],'file')
            % Cargamos los resultados ya hechos
            load(MiFichero,'Resultados');            
        else
            Resultados = cell(length(MaxNeurons),length(d));
        end

        MiFichero = [NomFichEvaluaciones '.mat'];
        if exist(['./' MiFichero],'file')
            % Cargamos los evaluaciones ya hechas
            load(MiFichero,'Evaluaciones');
        else
            Evaluaciones = cell(NumEntrenamientos,length(MaxNeurons),length(d));
        end

        MiFichero = [NomFichModelos '.mat'];
        if exist(['./' MiFichero],'file')
            % Cargamos los modelos ya entrenados
            load(MiFichero,'Modelos');
        else
            Modelos = cell(length(MaxNeurons),length(d));
        end

        MejorModelo = [];
        for NdxRepeticion=1:NumEntrenamientos,

            fprintf('\t\tENTRENAMIENTO %d\n',NdxRepeticion);
            if ~isempty(Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}),
                disp('Evitando repetir un entrenamiento')
                Modelo = Modelos{NdxMaxNeurons,NdxDataset};
                EntrenamientoOk = 1;
                CpuTime = -1;
            else                
                EntrenamientoOk=1;
                Hecho=0;
                Intentos=0;
                while Hecho==0
                    try
                        tic;
                        [Modelo] = TrainGNF(Muestras,MyMaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
                        CpuTime = toc;
                        fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',CpuTime);
                        Hecho=1;
                        if isempty(Modelo),
                            EntrenamientoOk = 0;
                            fprintf('\t\t\tEntrenamiento No OK\n');
                        end
                    catch
                        disp('Error en GNF')
                        lasterror.message
                        lasterror.stack
                        Intentos=Intentos+1;
                        clear functions
                    end
                    Hecho=Hecho | (Intentos>9);
                    if (Intentos>9)
                        EntrenamientoOk=0;
                    end
                end % while
            end
            
            if EntrenamientoOk,
                
                % Evaluamos la compresión hecha
                if CpuTime >= 0, % si el entrenamiento fue realizado (no cargado)
                    % Obtenemos la imagen de los prototipos
                    Centroids = Modelo.Means;
                    [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);  
                    Modelo.Winners = Winners;
                    ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
                    Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset} = evaluarCompresionImagen(ImgOriginal,ImgProt);
                    Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.TiempoEntrenamiento = CpuTime;
                    save([NomFichEvaluaciones '.mat'],'Evaluaciones');
                end                

                % Obtenemos el mejor modelo (el de máximo PSNR)
                if isempty(MejorModelo),
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                elseif Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.PSNR > MaximoPSNR,
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                end
            end
        end % for NdxRepeticion

        % Realizamos la validación cruzada
        Resultados{NdxMaxNeurons,NdxDataset} = ValidacionCruzadaCompresion(Evaluaciones(:,NdxMaxNeurons,NdxDataset)');
        save([NomFichResultados '.mat'],'Resultados');
        Modelos{NdxMaxNeurons,NdxDataset} = MejorModelo;
        save([NomFichModelos '.mat'],'Modelos');

        % Guardamos la imagen del mejor modelo
        Centroids = MejorModelo.Means;
        Winners = MejorModelo.Winners;
        ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
        fig = figure;
        set(fig,'name',['GNF ' num2str(MyMaxNeurons) ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        imshow(ImgProt);
        saveas(gcf,['GNF_' num2str(MyMaxNeurons) '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
        
        % Guardamos la imagen de diferencias ampliada 20 veces
        fig = figure;
        set(fig,'name',['GNF ' num2str(MyMaxNeurons) ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        ImgDif = abs(ImgDoubleNormalizada-ImgProt);
        imshow(ImgDif);  
        saveas(gcf,['GNF_Diff_' num2str(MyMaxNeurons) '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
        
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

