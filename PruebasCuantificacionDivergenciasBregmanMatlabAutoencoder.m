% Pruebas Cuantificación de Imágenes para el GNF
function PruebasCuantificacionDivergenciasBregmanMatlabAutoencoder(imgExt, RutaImagenes, foldingNumber, hiddenLayer, useAutoEncoder, evaluateAutoEncoder, endAfterEvaluatingAutoEncoder)
if false
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 1, 1, false, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 25, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 50, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 75, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 100, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 20, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 15, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 10, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 5, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 3, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 6, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 9, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 1, 1, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 1, 2, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 25, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 50, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 75, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 8, 100, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 20, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 15, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 10, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 4, 5, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 3, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 4, true, true, true);

PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'only2mini/', 1, 1, false, false, false);

PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 1, 1, false, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 25, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 50, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 75, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 100, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 20, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 15, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 10, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 5, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 3, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 4, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 5, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 6, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 9, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 1, 1, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 1, 2, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 25, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 50, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 75, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 100, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 20, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 15, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 10, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 4, 5, true, true, true);

PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 9, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 6, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 5, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 4, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 2, 3, true, true, true);

PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 1, 2, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 1, 1, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'onlybaboonhouselakelena_autoencoder/', 1, 2, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'onlybaboonhouselakelena_autoencoder/', 1, 1, true, true, true);


PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/4k/', 2, 6, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/4k/', 1, 2, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/4k/', 1, 1, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/4k/', 2, 9, true, true, true);

PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/4k/', 1, 2, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/4k/', 1, 1, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/onlybaboonhouselakelena_autoencoder/', 1, 2, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'SOCO2021/onlybaboonhouselakelena_autoencoder/', 1, 1, true, true, true);

PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 100, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 75, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 8, 50, true, true, true);


PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 4, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 5, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 4, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('tiff', 'onlybaboonhouselakelena_autoencoder/', 2, 5, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 1, 1, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', '4k/', 1, 2, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'onlybaboonhouselakelena_autoencoder/', 1, 1, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'onlybaboonhouselakelena_autoencoder/', 1, 2, true, false, false);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'onlybaboonhouselakelena_autoencoder/', 1, 1, true, true, true);
PruebasCuantificacionDivergenciasBregmanAutoencoder('png', 'onlybaboonhouselakelena_autoencoder/', 1, 2, true, true, true);
end
%clear all
basetimer = tic;

NumEpocas = 2;
NumEntrenamientos = 10;
MaxNeurons = 50; % Maximum number of neurons in each graph
NomFichResultados = 'ResultadosCuantificacionDivergenciasBregman';
NomFichEvaluaciones = 'EvaluacionesCuantificacionDivergenciasBregman';
NomFichModelos = 'ModelosCuantificacionDivergenciasBregman';
%RutaImagenes = './'; %COMO MINIMO './'
%RutaImagenes = 'onlybaboon_autoencoder/'; 
%RutaImagenes = 'only2mini/';
%RutaImagenes = 'only2mini_autoencoder/';
%RutaImagenes = 'onlybaboonhouselakelena/';
%RutaImagenes = 'onlybaboonhouselakelena_autoencoder/';
if useAutoEncoder
  subdir=sprintf('_autoencoder_%dx%dx3to%d/', foldingNumber, foldingNumber, hiddenLayer);
else
  subdir='GHBNC_standalone/';
end
RutaSalvar = [RutaImagenes subdir];
mkdir(RutaSalvar);
%imgExt = 'tiff';
%imgExt = 'png';

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
%foldingNumber = 4;
%hiddenLayer=20;
%useAutoEncoder = true;
%evaluateAutoEncoder=true;
%endAfterEvaluatingAutoEncoder=true;

% Leemos las imágenes del directorio en formato matriz
d = dir([RutaImagenes '*.' imgExt]);
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
    foldedImage = folding(ImgDoubleNormalizada, foldingNumber, true);
    MuestrasOrig = reshape(shiftdim(foldedImage,2),size(foldedImage,3),[]);
%     % Cargamos la imagen original
    ind = strfind(d(NdxDataset).name,'.');
    NomFich = d(NdxDataset).name(1:ind-1);
%     fprintf('\nIMAGEN: %s\n',NomFich);
%     load([RutaImagenes d(NdxDataset).name],'s');
%     ImgOriginal = s.frame;
%     Muestras = s.m;
    NumPasos = size(MuestrasOrig,2)*NumEpocas;

    if useAutoEncoder && evaluateAutoEncoder
      innertimer = tic;
      namefile_evaluaciones = [RutaSalvar sprintf('AutoencodersFolding%dLatentDim%03d.Evaluaciones', foldingNumber, hiddenLayer) '.mat'];
      namefile_autoenc = [RutaSalvar sprintf('AutoencodersFolding%dLatentDim%03d.AutoEncoders', foldingNumber, hiddenLayer) '.mat'];
      namefile_resultados = [RutaSalvar sprintf('AutoencodersFolding%dLatentDim%03d.Resultados', foldingNumber, hiddenLayer) '.mat'];
      if NdxDataset==1
        if exist([namefile_evaluaciones],'file')
          % Cargamos los evaluaciones ya hechas
          load(namefile_evaluaciones,'Evaluaciones');
          load(namefile_autoenc,'AutoEncoders');
          load(namefile_resultados, 'Resultados');
        else
          AutoEncoders = cell(NumEntrenamientos,length(d));
          Evaluaciones = cell(NumEntrenamientos,length(d));
          Resultados   = cell(length(d));
        end
      end
      for NdxRepeticion=1:NumEntrenamientos
        fprintf('Autoencoder %d para imagen %d: %s\n', NdxRepeticion, NdxDataset, NomFich);
        if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
          isemptyEvaluaciones = isempty(Evaluaciones{NdxRepeticion});
        else
          isemptyEvaluaciones = isempty(Evaluaciones{NdxRepeticion,NdxDataset});
        end
        if isemptyEvaluaciones
          trainingtimer = tic;
          autoenc = trainAutoencoder(MuestrasOrig, hiddenLayer, 'UseGPU', 1, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1, 'MaxEpochs', 100000, 'ScaleData', 0);
          Muestras = autoenc.encode(MuestrasOrig);
          MuestrasDecoded = autoenc.decode(Muestras);
          ImgProtFolded = reshape(MuestrasDecoded, size(foldedImage, 3), size(foldedImage, 1), size(foldedImage, 2));
          ImgProtFolded = shiftdim(ImgProtFolded,1);
          ImgProt = folding(ImgProtFolded, foldingNumber, false);
          namefile_img = [RutaSalvar sprintf('Imagen%d.Autoencoder%d.Folding%dLatentDim%03d', NdxDataset, NdxRepeticion, foldingNumber, hiddenLayer) '.png'];
          imwrite(ImgProt, namefile_img);
          if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
            AutoEncoders{NdxRepeticion} = autoenc;
            Evaluaciones{NdxRepeticion} = evaluarCompresionImagen(ImgOriginal,ImgProt);
            Evaluaciones{NdxRepeticion}.TiempoEntrenamiento = toc(trainingtimer);
            Evaluaciones{NdxRepeticion}.NomFich = NomFich;
          else
            AutoEncoders{NdxRepeticion,NdxDataset} = autoenc;
            Evaluaciones{NdxRepeticion,NdxDataset} = evaluarCompresionImagen(ImgOriginal,ImgProt);
            Evaluaciones{NdxRepeticion,NdxDataset}.TiempoEntrenamiento = toc(trainingtimer);
            Evaluaciones{NdxRepeticion,NdxDataset}.NomFich = NomFich;
          end
          save(namefile_evaluaciones,'Evaluaciones');
          save(namefile_autoenc,'AutoEncoders');
        end
      end
      morecputime = toc(innertimer);
      fprintf('Tiempo tardado en crear %s: %g segundos\n', namefile_evaluaciones, morecputime);
      % Realizamos la validación cruzada
      innertimer = tic;
      if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
        Resultados{NdxDataset} = ValidacionCruzadaCompresion(Evaluaciones(:)');
      else
        Resultados{NdxDataset} = ValidacionCruzadaCompresion(Evaluaciones(:,NdxDataset)');
      end
      Resultados{NdxDataset}.NomFich = NomFich;
      save(namefile_resultados,'Resultados');
      morecputime = toc(innertimer);
      fprintf('Tiempo tardado en realizar la validacion cruzada: %g segundos\n', morecputime);
      if ~endAfterEvaluatingAutoEncoder
        clear('Evaluaciones', 'AutoEncoders', 'Resultados');
      end
    end

  if ~endAfterEvaluatingAutoEncoder
    if useAutoEncoder    
      MiFichero = [RutaSalvar d(NdxDataset).name '.autoencoder.mat'];
      if exist([MiFichero],'file')
          % Cargamos los resultados ya hechos
          load(MiFichero,'autoenc');            
      else
        innertimer = tic;
        autoenc = trainAutoencoder(MuestrasOrig, hiddenLayer, 'UseGPU', 1, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1, 'MaxEpochs', 100000, 'ScaleData', 0);
        save(MiFichero,'autoenc');
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en entrenar autoencoder: %g segundos\n', morecputime);
      end
      Muestras = autoenc.encode(MuestrasOrig);
      namefile_evaluacion = [RutaSalvar sprintf('Evaluacion.Autoencoder.%s.Folding%dLatentDim%03d', NomFich, foldingNumber, hiddenLayer) '.mat'];
      if evaluateAutoEncoder && ~exist(namefile_evaluacion, 'file')
        MuestrasDecoded = autoenc.decode(Muestras);
        ImgProtFolded = reshape(MuestrasDecoded, size(foldedImage, 3), size(foldedImage, 1), size(foldedImage, 2));
        ImgProtFolded = shiftdim(ImgProtFolded,1);
        ImgProt = folding(ImgProtFolded, foldingNumber, false);
        Evaluacion = evaluarCompresionImagen(ImgOriginal,ImgProt);
        Evaluacion.NomFich = NomFich;
        save(namefile_evaluacion,'Evaluacion');
        clear('Evaluacion');
        if endAfterEvaluatingAutoEncoder
          continue;
        end               
      end
    else
      Muestras = MuestrasOrig;
    end

    for NdxDivergence=1:length(Divergences),
        MyDivergence = Divergences{NdxDivergence};
        fprintf('\nBREGMAN DIVERGENCE: %s\n',MyDivergence);
        
        MiFichero = [RutaSalvar NomFichResultados '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los resultados ya hechos
            load(MiFichero,'Resultados');            
        else
            Resultados = cell(length(Divergences),length(d));
        end

        MiFichero = [RutaSalvar NomFichEvaluaciones '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los evaluaciones ya hechas
            load(MiFichero,'Evaluaciones');
        else
            Evaluaciones = cell(NumEntrenamientos,length(Divergences),length(d));
        end

        MiFichero = [RutaSalvar NomFichModelos '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los modelos ya entrenados
            load(MiFichero,'Modelos');
        else
            Modelos = cell(length(Divergences),length(d));
        end

        MejorModelo = [];
        for NdxRepeticion=1:NumEntrenamientos,

            fprintf('\t\tENTRENAMIENTO %d\n',NdxRepeticion);
            if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
              notisemptyEvaluaciones = ~isempty(Evaluaciones{NdxRepeticion,NdxDivergence});
            else
              notisemptyEvaluaciones = ~isempty(Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset});
            end
            if notisemptyEvaluaciones,
                disp('Evitando repetir un entrenamiento')
                if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
                  Modelo = Modelos{NdxDivergence};
                else
                  Modelo = Modelos{NdxDivergence,NdxDataset};
                end
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
                         if isempty(Modelo)
                           fprintf('PARECE QUE TrainGHBNG se ha salido por donde dice "Prune the graphs with only 2 neurons. This is to simplify the hierarchy", repetimos a ver si hay mas suerte');
                           continue;
                         end
                         Modelo.NomFich = NomFich;
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
                namefile = [RutaSalvar NomFichEvaluaciones '.mat'];
                % Evaluamos la compresión hecha
                if CpuTime >= 0, % si el entrenamiento fue realizado (no cargado)
                    innertimer = tic;
                    % Obtenemos la imagen de los prototipos
                    %Centroids = Modelo.Means;
                    size(Modelo.Means)
                    Centroids = GetCentroidsGHBNG(Modelo);
                    NumNeurons         = size(Centroids,2);
                    %[Winners,Errors] = TestGNG(Modelo,Modelo.Samples); 
                    Winners = TestGHBNG(Centroids,Modelo.Samples,MyDivergence);
                    Modelo.Winners = Winners;
                    if useAutoEncoder
                      Centroids = autoenc.decode(Centroids);
                    end
                    ImgProtFolded = GetPrototypesImg(Centroids,Winners,size(foldedImage));
                    ImgProt = folding(ImgProtFolded, foldingNumber, false);
                    if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
                      Evaluaciones{NdxRepeticion,NdxDivergence} = evaluarCompresionImagen(ImgOriginal,ImgProt);
                      Evaluaciones{NdxRepeticion,NdxDivergence}.NomFich = NomFich;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.TiempoEntrenamiento = CpuTime;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.NumNeurons = NumNeurons;
                    else
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset} = evaluarCompresionImagen(ImgOriginal,ImgProt);
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.NomFich = NomFich;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.TiempoEntrenamiento = CpuTime;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.NumNeurons = NumNeurons;
                    end
                    save(namefile,'Evaluaciones');
                    morecputime = toc(innertimer);
                    fprintf('Tiempo tardado en crear %s: %g segundos\n', namefile, morecputime);
                end                

                % Obtenemos el mejor modelo (el de máximo PSNR)
                innertimer = tic;
                if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
                  if isempty(MejorModelo),
                      MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence}.PSNR;
                      MejorModelo = Modelo;
                  elseif Evaluaciones{NdxRepeticion,NdxDivergence}.PSNR > MaximoPSNR,
                      MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence}.PSNR;
                      MejorModelo = Modelo;
                  end
                else
                  if isempty(MejorModelo),
                      MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.PSNR;
                      MejorModelo = Modelo;
                  elseif Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.PSNR > MaximoPSNR,
                      MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.PSNR;
                      MejorModelo = Modelo;
                  end
                end
                morecputime = toc(innertimer);
                fprintf('Tiempo tardado en encontrar el mejor modelo %s: %g segundos\n', namefile, morecputime);
            end
        end % for NdxRepeticion

        % Realizamos la validación cruzada
        innertimer = tic;
        MejorModelo.NomFich = NomFich;
        if length(d)==1 %fucking retarded matlab removing trailing singleton dimensions :(
          Resultados{NdxDivergence} = ValidacionCruzadaCompresion(Evaluaciones(:,NdxDivergence)');
          Resultados{NdxDivergence}.NomFich = NomFich;
          Modelos{NdxDivergence} = MejorModelo;
        else
          Resultados{NdxDivergence,NdxDataset} = ValidacionCruzadaCompresion(Evaluaciones(:,NdxDivergence,NdxDataset)');
          Resultados{NdxDivergence,NdxDataset}.NomFich = NomFich;
          Modelos{NdxDivergence,NdxDataset} = MejorModelo;
        end
        save([RutaSalvar NomFichResultados '.mat'],'Resultados');
        save([RutaSalvar NomFichModelos '.mat'],'Modelos');
        save([RutaSalvar sprintf('MejorModelo.Divergence%d.Image%02d', NdxDivergence, NdxDataset) '.mat'], 'MejorModelo')
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en realizar la validacion cruzada: %g segundos\n', morecputime);

        % Guardamos la imagen del mejor modelo
        %Centroids = MejorModelo.Means;
        innertimer = tic;
        Centroids = GetCentroidsGHBNG(MejorModelo);
        %Winners = MejorModelo.Winners;
        Winners = TestGHBNG(Centroids,MejorModelo.Samples,MyDivergence);
        if useAutoEncoder
          Centroids = autoenc.decode(Centroids);
        end
        ImgProtFolded = GetPrototypesImg(Centroids,Winners,size(foldedImage));
        ImgProt = folding(ImgProtFolded, foldingNumber, false);
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en testear el modelo: %g segundos\n', morecputime);
        fig = figure;
        set(fig,'name',['Bregman ' MyDivergence ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        imshow(ImgProt);
        saveas(gcf,[RutaSalvar 'Bregman_' MyDivergence '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
        
        % Guardamos la imagen de diferencias ampliada 20 veces
        fig = figure;
        set(fig,'name',['Bregman ' MyDivergence ' Neurons ' NomFich]);
        set(fig,'NumberTitle','off');
        ImgDif = abs(ImgDoubleNormalizada-ImgProt);
        imshow(ImgDif);  
        saveas(gcf,[RutaSalvar 'Bregman_Diff_' MyDivergence '_' strrep(NomFich,'.tiff','') '.fig'],'fig');      
        
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
  end               
    
end % for dataset
tiempoDeEjecicionDelPrograma = toc(basetimer);
fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',tiempoDeEjecicionDelPrograma);
fprintf('fin del programa.\n')
