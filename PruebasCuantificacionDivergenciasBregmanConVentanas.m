% Pruebas Cuantificación de Imágenes para el GNF
clear all
basetimer = tic;

NumEpocas = 2;
NumEntrenamientos = 1;%10;
MaxNeurons = 50; % Maximum number of neurons in each graph
NomFichResultados = 'ResultadosCuantificacionDivergenciasBregman';
NomFichEvaluaciones = 'EvaluacionesCuantificacionDivergenciasBregman';
NomFichModelos = 'ModelosCuantificacionDivergenciasBregman';
RutaImagenes = 'onlybaboon3/';%'C:\smartechic\images\';
RutaImagenes = 'onlyejemplo4k/';
%RutaImagenes = 'onlyejemploreduced/';

Tau = 0.1;
Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Leemos las imágenes del directorio en formato matriz
%d = dir([RutaImagenes '*.tiff']);
d = dir([RutaImagenes '*.png']);
% fprintf('Arrancando...\n')
% fprintf('RutaImagenes: %s\n', RutaImagenes)
% fprintf('Longitud: %d\n', length(d))
% IMAGEN
Handle=zeros(1,numel(Divergences));
for NdxDataset=1:length(d)
    fprintf('Dentro...\n')
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
    NumPasos = size(Muestras,2)*NumEpocas;
    
    for NdxDivergence=1:length(Divergences),
        MyDivergence = Divergences{NdxDivergence};
        fprintf('\nBREGMAN DIVERGENCE: %s\n',MyDivergence);
        
        MiFichero = [RutaImagenes NomFichResultados '.mat'];
        if exist(['./' MiFichero],'file')
            % Cargamos los resultados ya hechos
            load(MiFichero,'Resultados');            
        else
            Resultados = cell(length(Divergences),length(d));
        end

        MiFichero = [RutaImagenes NomFichEvaluaciones '.mat'];
        if exist(['./' MiFichero],'file')
            % Cargamos los evaluaciones ya hechas
            load(MiFichero,'Evaluaciones');
        else
            Evaluaciones = cell(NumEntrenamientos,length(Divergences),length(d));
        end

        MiFichero = [RutaImagenes NomFichModelos '.mat'];
        if exist(['./' MiFichero],'file')
            % Cargamos los modelos ya entrenados
            load(MiFichero,'Modelos');
        else
            Modelos = cell(length(Divergences),length(d));
        end

        MejorModelo = [];
        for NdxRepeticion=1:NumEntrenamientos,

            fprintf('\t\tENTRENAMIENTO %d\n',NdxRepeticion);
            if ~isempty(Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}),
                disp('Evitando repetir un entrenamiento')
                Modelo = Modelos{NdxDivergence,NdxDataset};
                EntrenamientoOk = 1;
                CpuTime = -1;
            else                
                EntrenamientoOk=1;
                Hecho=0;
                Intentos=0;
                while Hecho==0
                    try
                        innertimer = tic;
                         [Modelo] = TrainGHBNG(Muestras,NumEpocas,MyDivergence,MaxNeurons,Tau,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,1);
                        %[Modelo] = TrainGNF(Muestras,MyMaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
                        CpuTime = toc(innertimer);
                        fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',CpuTime);
                        Hecho=1;
                        if isempty(Modelo),
                            EntrenamientoOk = 0;
                            fprintf('\t\t\tEntrenamiento No OK\n');
                        end
                    catch e
                        disp('Error en Bregman')
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
            
            if EntrenamientoOk,
                % Evaluamos la compresión hecha
                if CpuTime >= 0, % si el entrenamiento fue realizado (no cargado)
                    innertimer = tic;
                    % Obtenemos la imagen de los prototipos
                    %Centroids = Modelo.Means;
                    Centroids = GetCentroidsGHBNG(Modelo);
                    %[Winners,Errors] = TestGNG(Modelo,Modelo.Samples); 
                    Winners = TestGHBNG(Centroids,Modelo.Samples,MyDivergence);
                    Modelo.Winners = Winners;
                    ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
                    Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset} = evaluarCompresionImagen(ImgOriginal,ImgProt);
                    Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.TiempoEntrenamiento = CpuTime;
                    namefile = [RutaImagenes NomFichEvaluaciones '.mat'];
                    save(namefile,'Evaluaciones');
                    morecputime = toc(innertimer);
                    fprintf('Tiempo tardado en crear %s: %g segundos\n', namefile, morecputime);
                end                

                % Obtenemos el mejor modelo (el de máximo PSNR)
                innertimer = tic;
                if isempty(MejorModelo),
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                elseif Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.PSNR > MaximoPSNR,
                    MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.PSNR;
                    MejorModelo = Modelo;
                end
                morecputime = toc(innertimer);
                fprintf('Tiempo tardado en encontrar el mejor modelo %s: %g segundos\n', namefile, morecputime);
            end
        end % for NdxRepeticion

        % Realizamos la validación cruzada
        innertimer = tic;
        Resultados{NdxDivergence,NdxDataset} = ValidacionCruzadaCompresion(Evaluaciones(:,NdxDivergence,NdxDataset)');
        save([RutaImagenes NomFichResultados '.mat'],'Resultados');
        Modelos{NdxDivergence,NdxDataset} = MejorModelo;
        save([RutaImagenes NomFichModelos '.mat'],'Modelos');
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en realizar la validacion cruzada: %g segundos\n', morecputime);

        % Guardamos la imagen del mejor modelo
        %Centroids = MejorModelo.Means;
        innertimer = tic;
        Centroids = GetCentroidsGHBNG(MejorModelo);
        %Winners = MejorModelo.Winners;
        Winners = TestGHBNG(Centroids,MejorModelo.Samples,MyDivergence);
        ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en testear el modelo: %g segundos\n', morecputime);
        fig = figure;
        set(fig,'name',['Bregman ' MyDivergence ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        imshow(ImgProt);
        saveas(gcf,[RutaImagenes 'Bregman_' MyDivergence '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
        
        % Guardamos la imagen de diferencias ampliada 20 veces
        fig = figure;
        set(fig,'name',['Bregman ' MyDivergence ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        ImgDif = abs(ImgDoubleNormalizada-ImgProt);
        imshow(ImgDif);  
        saveas(gcf,[RutaImagenes 'Bregman_Diff_' MyDivergence '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
        
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
tiempoDeEjecicionDelPrograma = toc(basetimer);
fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',tiempoDeEjecicionDelPrograma);
fprintf('fin del programa.\n')
