% Pruebas Cuantificación de Imágenes para el GNF
function PruebasCuantificacionMulti(MODE, RutaImagenes)
if false
PruebasCuantificacionMulti('GHSOM', 'all/');
PruebasCuantificacionMulti('GHNG', 'all/');
end
%clear all
basetimer = tic;

NumEpocas = 2;
NumEntrenamientos = 10;
MaxNeurons = 50; % Maximum number of neurons in each graph
%RutaImagenes = 'onlybaboonhouselakelena_autoencoder/';
subdir='GHBNC_standalone_tau2_001/';
RutaSalvar = [RutaImagenes subdir];
mkdir(RutaSalvar);

TauGHBNG = 0.1;
TauGHNG = 0.1;
%Tau1GHSOM = 0.001; % GHSOM
%Tau2GHSOM = 0.0001; % GHSOM
Tau1GHSOM = 0.001; % GHSOM
Tau2GHSOM = 0.001; % GHSOM
ErrorTypeGHSOM='abs'; % GHSOM


MODES = {'GHBNG', 'GHSOM', 'GHNG'};
%MODE = 'GHSOM';

isGHBNG = strcmp(MODE, 'GHBNG');
isGHSOM = strcmp(MODE, 'GHSOM');
isGHNG  = strcmp(MODE, 'GHNG');
if isGHBNG
  Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};
else
  Divergences= {0};
end
if isGHBNG
  NomFichResultados = 'ResultadosCuantificacionDivergenciasBregman';
  NomFichEvaluaciones = 'EvaluacionesCuantificacionDivergenciasBregman';
  NomFichModelos = 'ModelosCuantificacionDivergenciasBregman';
elseif isGHSOM
  NomFichResultados = 'ResultadosCuantificacionGHSOM';
  NomFichEvaluaciones = 'EvaluacionesCuantificacionGHSOM';
  NomFichModelos = 'ModelosCuantificacionGHSOM';
elseif isGHNG
  NomFichResultados = 'ResultadosCuantificacionGHNG';
  NomFichEvaluaciones = 'EvaluacionesCuantificacionGHNG';
  NomFichModelos = 'ModelosCuantificacionGHNG';
end



% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Leemos las imágenes del directorio en formato matriz
%d = dir([RutaImagenes '*.' imgExt]);
filenames = {'Baboon.tiff', 'House.tiff', 'Lake.tiff', 'Lena.tiff', 'bike.png', 'bird.png', 'building.png', 'chicks.png', 'mall.png', 'night.png', 'picturesque.png', 'snow.png', 'street.png', 'woman.png'};
for NdxDataset=1:length(filenames)
    fprintf('Dentro...\n')
    % Generate data from image
    ImgOriginal = imread([RutaImagenes filenames{NdxDataset}]);
    ImgDoubleNormalizada = double(ImgOriginal)/255;
    Muestras = reshape(shiftdim(ImgDoubleNormalizada,2),size(ImgDoubleNormalizada,3),[]);
%     % Cargamos la imagen original
    ind = strfind(filenames{NdxDataset},'.');
    NomFich = filenames{NdxDataset}(1:ind-1);
    NumPasos = size(Muestras,2)*NumEpocas;

    for NdxDivergence=1:length(Divergences),
        if isGHBNG
          MyDivergence = Divergences{NdxDivergence};
          fprintf('\nBREGMAN DIVERGENCE: %s\n',MyDivergence);
        end
        
        MiFichero = [RutaSalvar NomFichResultados '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los resultados ya hechos
            load(MiFichero,'Resultados');            
        else
            Resultados = cell(length(Divergences),length(filenames));
        end

        MiFichero = [RutaSalvar NomFichEvaluaciones '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los evaluaciones ya hechas
            load(MiFichero,'Evaluaciones');
        else
            Evaluaciones = cell(NumEntrenamientos,length(Divergences),length(filenames));
        end

        MiFichero = [RutaSalvar NomFichModelos '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los modelos ya entrenados
            load(MiFichero,'Modelos');
        else
            Modelos = cell(length(Divergences),length(filenames));
        end

        MejorModelo = [];
        for NdxRepeticion=1:NumEntrenamientos,

            fprintf('\t\tENTRENAMIENTO %d\n',NdxRepeticion);
            if length(filenames)==1 %fucking retarded matlab removing trailing singleton dimensions :(
              notisemptyEvaluaciones = ~isempty(Evaluaciones{NdxRepeticion,NdxDivergence});
            else
              notisemptyEvaluaciones = ~isempty(Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset});
            end
            if notisemptyEvaluaciones,
                disp('Evitando repetir un entrenamiento')
                if length(filenames)==1 %fucking retarded matlab removing trailing singleton dimensions :(
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
                if isGHSOM
                  % Compute the mean of the samples (initial weight vector)
                  IniWeight = full(nansum(Muestras,2)/size(Muestras,2));
                  % Compute the initial Bregman quantization errror (qe0)
                  IniQE = QuantizationError(IniWeight,Muestras,ErrorTypeGHSOM);
                end
                while Hecho==0
                    try
                        innertimer = tic;
                        if isGHBNG
                           [Modelo] = TrainGHBNG(Muestras,NumEpocas,MyDivergence,MaxNeurons,TauGHBNG,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,1);
                           if isempty(Modelo)
                             fprintf('PARECE QUE TrainGHBNG se ha salido por donde dice "Prune the graphs with only 2 neurons. This is to simplify the hierarchy", repetimos a ver si hay mas suerte');
                             continue;
                           end
                        elseif isGHSOM
                          [Modelo] = TrainGHSOM(Muestras,(1:size(Muestras,2)),NumEpocas,Tau1GHSOM,Tau2GHSOM,ErrorTypeGHSOM,IniQE,IniQE,[],1);
                        elseif isGHNG
                          [Modelo] = TrainGHNG3(Muestras,NumEpocas,MaxNeurons,TauGHNG,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,1);
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
                    if isGHBNG
                      % Obtenemos la imagen de los prototipos
                      %Centroids = Modelo.Means;
                      Centroids = GetCentroidsGHBNG(Modelo);
                      NumNeurons         = size(Centroids,2);
                      %[Winners,Errors] = TestGNG(Modelo,Modelo.Samples); 
                      Winners = TestGHBNG(Centroids,Modelo.Samples,MyDivergence);
                      Modelo.Winners = Winners;
                    else
                      if isGHSOM
                        Centroids  = GetCentroidsGHSOM(Modelo);                        
                        NumNeurons = GetNumberNeuronsGHSOM(Modelo);
                      elseif isGHNG
                        Centroids  = GetCentroidsGHNG(Modelo);
                        NumNeurons = GetNumberNeuronsGHNF(Modelo);
                      end
                      [Winners,Errors] = TestGHNG(Centroids,Muestras);%Modelo.Samples);
                      Modelo.Winners = Winners;
                    end
                    ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgDoubleNormalizada));
                    if length(filenames)==1 %fucking retarded matlab removing trailing singleton dimensions :(
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
                if length(filenames)==1 %fucking retarded matlab removing trailing singleton dimensions :(
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
        if length(filenames)==1 %fucking retarded matlab removing trailing singleton dimensions :(
          Resultados{NdxDivergence} = ValidacionCruzadaCompresionCompleto(Evaluaciones(:,NdxDivergence)');
          Resultados{NdxDivergence}.NomFich = NomFich;
          Modelos{NdxDivergence} = MejorModelo;
        else
          Resultados{NdxDivergence,NdxDataset} = ValidacionCruzadaCompresionCompleto(Evaluaciones(:,NdxDivergence,NdxDataset)');
          Resultados{NdxDivergence,NdxDataset}.NomFich = NomFich;
          Modelos{NdxDivergence,NdxDataset} = MejorModelo;
        end
        save([RutaSalvar NomFichResultados '.mat'],'Resultados');
        save([RutaSalvar NomFichModelos '.mat'],'Modelos');
        if isGHBNG
          namemejormodelo = [RutaSalvar sprintf('MejorModelo.Divergence%d.Image%02d', NdxDivergence, NdxDataset) '.mat'];
        elseif isGHSOM
          namemejormodelo = [RutaSalvar sprintf('MejorModelo.GHSOM.Image%02d', NdxDataset) '.mat'];
        elseif isGHNG
          namemejormodelo = [RutaSalvar sprintf('MejorModelo.GHNG.Image%02d', NdxDataset) '.mat'];
        end
        save(namemejormodelo, 'MejorModelo')
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en realizar la validacion cruzada: %g segundos\n', morecputime);

        % Guardamos la imagen del mejor modelo
        innertimer = tic;
        if isGHBNG
          nameimg     = [RutaSalvar 'Bregman_' MyDivergence '_' NomFich '.png'];
          nameimgdiff = [RutaSalvar 'Bregman_Diff_' MyDivergence '_' NomFich '.png'];
          Centroids = GetCentroidsGHBNG(MejorModelo);
          Winners = TestGHBNG(Centroids,MejorModelo.Samples,MyDivergence);
        else
          if isGHSOM
            nameimg     = [RutaSalvar 'GHSOM_' NomFich '.png'];
            nameimgdiff = [RutaSalvar 'GHSOM_Diff_' NomFich '.png'];
            Centroids = GetCentroidsGHSOM(MejorModelo);
          elseif isGHNG
            nameimg     = [RutaSalvar 'GHNG_' NomFich '.png'];
            nameimgdiff = [RutaSalvar 'GHNG_Diff_' NomFich '.png'];
            Centroids = GetCentroidsGHNG(MejorModelo);
          end
          [Winners,Errors] = TestGHNG(Centroids,Muestras);
        end
        ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgDoubleNormalizada));
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en testear el modelo: %g segundos\n', morecputime);
        imwrite(ImgProt, nameimg);
        ImgDif = abs(ImgDoubleNormalizada-ImgProt);
        imwrite(ImgDif, nameimgdiff);
        
    end % for MaxNeruons
    
end % for dataset
tiempoDeEjecicionDelPrograma = toc(basetimer);
fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',tiempoDeEjecicionDelPrograma);
fprintf('fin del programa.\n')
