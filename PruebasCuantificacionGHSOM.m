% Pruebas Cuantificaci�n de Im�genes para el GHSOM
clear all

NumEpocas = 2;
NumEntrenamientos = 10;
MaxNeurons = [10 20 30 40 50]; % Maximum number of neurons in each graph
NomFichResultados = 'ResultadosCuantificacionGHSOM';
NomFichEvaluaciones = 'EvaluacionesCuantificacionGHSOM';
NomFichModelos = 'ModelosCuantificacionGHSOM';
RutaImagenes = './images/';

% GHSOM Parameters
Tau1=0.1;
Tau2=0.1;

% Leemos las im�genes del directorio en formato matriz
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

        % Compute the mean of the samples (initial weight vector)
        IniWeight = full(nansum(Muestras,2)/size(Muestras,2));
        
        % Compute the initial Bregman quantization errror (qe0)
        IniQE = QuantizationError(IniWeight,Muestras,'abs');

        MejorModelo = [];
        for NdxRepeticion=1:NumEntrenamientos,

            fprintf('\t\tENTRENAMIENTO %d\n',NdxRepeticion);
            if ~isempty(Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}),
                fprintf('\t\t\tEvitando repetir un entrenamiento\n')
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
                        [Modelo] = TrainGHSOM(Muestras,(1:size(Muestras,2)),NumEpocas,Tau1,Tau2,'abs',IniQE,IniQE,[],1);
                        CpuTime = toc;
                        fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',CpuTime);
                        Hecho=1;
                        if isempty(Modelo),
                            EntrenamientoOk = 0;
                            fprintf('\t\t\tEntrenamiento No OK\n');
                        end
                    catch
                        disp('Error en GHSOM')
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
                
                % Evaluamos la compresi�n hecha
                if CpuTime >= 0, % si el entrenamiento fue realizado (no cargado)
                    % Obtenemos la imagen de los prototipos
%                     Centroids = Modelo.Means;
                    Centroids = GetCentroidsGHSOM(Modelo);
                    [Modelo] = TestGHSOM(Muestras,Modelo);
                    [Winners] = GetWinnersGHSOM(Modelo,Muestras,0);
                    Modelo.Winners = Winners;
                    ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
                    Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset} = evaluarCompresionImagen(ImgOriginal,ImgProt);
                    Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.TiempoEntrenamiento = CpuTime;
                    save([NomFichEvaluaciones '.mat'],'Evaluaciones');
                end                

                % Obtenemos el mejor modelo (el de m�ximo PSNR)
                if isempty(MejorModelo),
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                elseif Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.PSNR > MaximoPSNR,
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxMaxNeurons,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                end
            end
        end % for NdxRepeticion

        % Realizamos la validaci�n cruzada
        Resultados{NdxMaxNeurons,NdxDataset} = ValidacionCruzadaCompresion(Evaluaciones(:,NdxMaxNeurons,NdxDataset)');
        save([NomFichResultados '.mat'],'Resultados');
        Modelos{NdxMaxNeurons,NdxDataset} = MejorModelo;
        save([NomFichModelos '.mat'],'Modelos');

        % Guardamos la imagen del mejor modelo
        Centroids = GetCentroidsGHSOM(MejorModelo);
%         Centroids = MejorModelo.Means;
        Winners = MejorModelo.Winners;
        ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
        fig = figure;
        set(fig,'name',['GHSOM ' num2str(MyMaxNeurons) ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        imshow(ImgProt);
        saveas(gcf,['GHSOM_' num2str(MyMaxNeurons) '_' strrep(NomFich,'.tiff','') '.fig'],'fig');  
                
        % Guardamos la imagen de diferencias ampliada 20 veces
        fig = figure;
        set(fig,'name',['GHSOM ' num2str(MyMaxNeurons) ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        ImgDif = abs(ImgDoubleNormalizada-ImgProt);
        imshow(ImgDif);  
        saveas(gcf,['GHSOM_Diff_' num2str(MyMaxNeurons) '_' strrep(NomFich,'.tiff','') '.fig'],'fig');
    end % for MaxNeruons
    close all
end % for dataset

