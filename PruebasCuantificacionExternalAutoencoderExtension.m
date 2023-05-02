function PruebasCuantificacionExternalAutoencoderExtension(MODE, H, N, D, P, GPU)

if false
PruebasCuantificacionExternalAutoencoderExtension('MC0', 1, 1, 0, 8, '0');
PruebasCuantificacionExternalAutoencoderExtension('MC0', 1, 2, 0, 8, '0');
PruebasCuantificacionExternalAutoencoderExtension('MC0', 1, 3, 0, 8, '0');
PruebasCuantificacionExternalAutoencoderExtension('MC0', 1, 4, 0, 8, '0');
PruebasCuantificacionExternalAutoencoderExtension('MC1', 1, 1, 0, 8, '0');
PruebasCuantificacionExternalAutoencoderExtension('MC1', 1, 2, 0, 8, '0');
PruebasCuantificacionExternalAutoencoderExtension('MC1', 1, 3, 0, 8, '0');
PruebasCuantificacionExternalAutoencoderExtension('MC1', 1, 4, 0, 8, '0');


PruebasCuantificacionMulti('GHSOM', 'all/');
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 1, 1, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 4, 1, 0, 8);

PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 1, 4, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 2, 4, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 3, 4, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 4, 4, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 1, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 2, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 3, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 4, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 1, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 2, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 3, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 4, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 2, 1, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder('GHSOM', 3, 1, 0, 8);


PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(1, 1, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(1, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(1, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(1, 4, 0, 8);



%en otro servidor
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(2, 1, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(2, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(2, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(2, 4, 0, 8);

%en proceso
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(3, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(3, 1, 0, 8);

%en proceso
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(3, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(3, 4, 0, 8);

%en proceso
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(4, 2, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(4, 1, 0, 8);

%en proceso
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(4, 3, 0, 8);
%por lanzar
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(4, 4, 0, 8);


PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(3, 2, 0, 8);

PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(2, 1, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(2, 2, 0, 8);


PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(3, 1, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(3, 3, 0, 8);
PruebasCuantificacionDivergenciasBregmanExternalAutoencoder(2, 3, 0, 8);

end

  basepath = '';

  filenames = {
  [basepath 'all/Baboon.tiff'],
  [basepath 'all/House.tiff'],
  [basepath 'all/Lake.tiff'],
  [basepath 'all/Lena.tiff'],
  [basepath 'all/bike.png'],
  [basepath 'all/bird.png'],
  [basepath 'all/building.png'],
  [basepath 'all/chicks.png'],
  [basepath 'all/mall.png'],
  [basepath 'all/night.png'],
  [basepath 'all/picturesque.png'],
  [basepath 'all/snow.png'],
  [basepath 'all/street.png'],
  [basepath 'all/woman.png']
  }';
  if false
    imgs = cell(size(filenames));
    for k=1:numel(filenames)
      imgs{k} = imread(filenames{k});
    end
    mega = [imgs{1:7}; imgs{8:end}];
    imwrite(mega, [basepath 'allimages.png']);
    return
  end

  subcode = sprintf('R3_H%d_N%d_D%d_P%d_E20000', H, N, D, P);
  RutaSalvar = [basepath 'conv_' MODE '/' subcode '/'];

  names = {
  'Baboon',
  'House',
  'Lake',
  'Lena',
  'bike',
  'bird',
  'building',
  'chicks',
  'mall',
  'night',
  'picturesque',
  'snow',
  'street',
  'woman'
  };

  toprocess = cell(numel(names), 3);
  toprocess(:,1) = filenames;
  for k=1:numel(names)
    subpath = sprintf('convP%dH%d/%s_convautoenc_%s_best', P, H, names{k}, subcode);
    toprocess{k,2} = [basepath subpath '.mat'];
    toprocess{k,3} = [basepath subpath '.pt'];
  end

  PruebasCuantificacionExternalAutoencoderRun(MODE, P, RutaSalvar, toprocess, N, GPU)


% toprocess = {nameimg1, namemat1, namept1; nameimg2, namemat2, namept2; ...}
function PruebasCuantificacionExternalAutoencoderRun(MODE, P, RutaSalvar, toprocess, N, GPU)
%clear all
basetimer = tic;

NumEpocas = 2;
NumEntrenamientos = 10;
MaxNeurons = 50; % Maximum number of neurons in each graph
mkdir(RutaSalvar);

TauGHBNG = 0.1;
TauGHNG = 0.1;
%Tau1GHSOM = 0.001; % GHSOM
%Tau2GHSOM = 0.0001; % GHSOM
Tau1GHSOM = 0.001; % GHSOM
Tau2GHSOM = 0.001; % GHSOM
ErrorTypeGHSOM='abs'; % GHSOM


MODES = {'GHBNG', 'GHSOM', 'GHNG', 'MC0', 'MC1'};

isGHBNG = strcmp(MODE, 'GHBNG');
isGHSOM = strcmp(MODE, 'GHSOM');
isGHNG  = strcmp(MODE, 'GHNG');
isMC0   = strcmp(MODE, 'MC0');
isMC1   = strcmp(MODE, 'MC1');
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
elseif isMC0
  NomFichResultados = 'ResultadosCuantificacionMC0';
  NomFichEvaluaciones = 'EvaluacionesCuantificacionMC0';
  NomFichModelos = 'ModelosCuantificacionMC0';
elseif isMC1
  NomFichResultados = 'ResultadosCuantificacionMC1';
  NomFichEvaluaciones = 'EvaluacionesCuantificacionMC1';
  NomFichModelos = 'ModelosCuantificacionMC1';
end

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

%depends on N:
%K>> mean(reshape(allmetrics(6, 1, 4:8, :,:), [],1))
%ans =   2.2853e+03
%depth=11
%K>> mean(reshape(allmetrics(6, 2, 4:8, :,:), [],1))
%ans = 631.4760
%depth=9
%K>> mean(reshape(allmetrics(6, 3, 4:8, :,:), [],1))
%ans = 167.8200
%depth=7
%K>> mean(reshape(allmetrics(6, 4, 4:8, :,:), [],1))
%ans = 43.8760
%depth=5
%K>> mean(allmetrics_justGHBNG(6,:))
%ans = 8.7203e+03
%depth=13
medianCutDepths = [11, 9, 7, 5];

DELETEPREVRUN = false;
if DELETEPREVRUN
  if exist([RutaSalvar NomFichResultados '.mat'],'file')
    delete([RutaSalvar NomFichResultados '.mat']);
  end
  if exist([RutaSalvar NomFichEvaluaciones '.mat'],'file')
    delete([RutaSalvar NomFichEvaluaciones '.mat']);
  end
  if exist([RutaSalvar NomFichModelos '.mat'],'file')
    delete([RutaSalvar NomFichModelos '.mat']);
  end
end

for NdxDataset=1:size(toprocess,1)
    fprintf('Dentro...\n')
    % Generate data from image
    ImgOriginal = imread(toprocess{NdxDataset,1});
    ImgDoubleNormalizada = double(ImgOriginal)/255;
%     % Cargamos la imagen original
    ind = strfind(toprocess{NdxDataset,1},'.');
    NomFich = toprocess{NdxDataset,1}(1:ind(end)-1);
    ind = strfind(NomFich,'/');
    NomFich = NomFich(ind(end)+1:end);
    autoenc = load(toprocess{NdxDataset,2}).autoenc;
    encodedOrig = double(autoenc.encoded);
    Muestras = reshape(shiftdim(encodedOrig,2),size(encodedOrig,3),[]);

    encodedShape      = size(autoenc.encoded);
    encodedPrecision  = P;
    decoderSizes      = zeros(size(autoenc.decoder_params));
    for s=1:numel(decoderSizes)
      decoderSizes(s) = prod(size(autoenc.decoder_params{s}));
    end
    decoderParams     = sum(decoderSizes);

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
            Resultados = cell(length(Divergences),size(toprocess,1));
        end

        MiFichero = [RutaSalvar NomFichEvaluaciones '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los evaluaciones ya hechas
            load(MiFichero,'Evaluaciones');
        else
            Evaluaciones = cell(NumEntrenamientos,length(Divergences),size(toprocess,1));
        end

        MiFichero = [RutaSalvar NomFichModelos '.mat'];
        if exist([MiFichero],'file')
            % Cargamos los modelos ya entrenados
            load(MiFichero,'Modelos');
        else
            Modelos = cell(length(Divergences),size(toprocess,1));
        end

        MejorModelo = [];
        for NdxRepeticion=1:NumEntrenamientos,

            fprintf('\t\tENTRENAMIENTO %d\n',NdxRepeticion);
            if size(toprocess,1)==1 %fucking retarded matlab removing trailing singleton dimensions :(
              notisemptyEvaluaciones = ~isempty(Evaluaciones{NdxRepeticion,NdxDivergence});
            else
              notisemptyEvaluaciones = ~isempty(Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset});
            end
            if notisemptyEvaluaciones,
                disp('Evitando repetir un entrenamiento')
                if size(toprocess,1)==1 %fucking retarded matlab removing trailing singleton dimensions :(
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
                        if isGHBNG || isGHSOM || isGHNG
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
                        elseif isMC0
                          [ImgReduced, isRandomized] = medianCut(encodedOrig, 0, true, medianCutDepths(N));
                        elseif isMC1
                          [ImgReduced, isRandomized] = medianCut(encodedOrig, 1, true, medianCutDepths(N));
                        end
                        CpuTime = toc(innertimer);
                        fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',CpuTime);
                        Hecho=1;
                        if (isGHBNG || isGHSOM || isGHNG) && isempty(Modelo),
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
                    if isGHBNG || isGHSOM || isGHNG
                      if isGHBNG
                        % Obtenemos la imagen de los prototipos
                        %Centroids = Modelo.Means;
                        Centroids = GetCentroidsGHBNG(Modelo);
                        NumNeurons         = size(Centroids,2);
                        %[Winners,Errors] = TestGNG(Modelo,Modelo.Samples);
                        Winners = TestGHBNG(Centroids,Modelo.Samples,MyDivergence);
                        Modelo.Winners = Winners;
                      elseif isGHSOM || isGHNG
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
                      encoded = GetPrototypesImg(Centroids,Winners,size(encodedOrig));
                    elseif isMC0 || isMC1
                      NumNeurons = 2^medianCutDepths(N);
                      encoded = ImgReduced;
                    end
                    rnd = round(rand*1000000);
                    encodedpath = [RutaSalvar sprintf('tmp%d.mat', rnd)];
                    encodedimgpath = [RutaSalvar sprintf('tmp%d.png', rnd)];
                    save(encodedpath, 'encoded');
                    command = sprintf('conda run condaconvenv python pruebaconv1.py --decode --matpath %s --weightpath %s --encodedpath %s --resultpath %s', toprocess{NdxDataset,2}, toprocess{NdxDataset,3}, encodedpath, encodedimgpath);
                    decodertimer=tic;
                    system(['export CUDA_VISIBLE_DEVICES=' GPU ' ; ' command], '-echo');
                    decodetime = toc(decodertimer);
                    ImgProt = imread(encodedimgpath);
                    delete(encodedpath);
                    delete(encodedimgpath);
                    if size(toprocess,1)==1 %fucking retarded matlab removing trailing singleton dimensions :(
                      Evaluaciones{NdxRepeticion,NdxDivergence} = evaluarCompresionImagen(ImgOriginal,ImgProt);
                      Evaluaciones{NdxRepeticion,NdxDivergence}.NomFich = NomFich;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.TiempoEntrenamiento = CpuTime;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.TiempoDecoder = decodetime;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.NumNeurons = NumNeurons;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.encodedShape = encodedShape;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.encodedPrecision = encodedPrecision;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.decoderSizes = decoderSizes;
                      Evaluaciones{NdxRepeticion,NdxDivergence}.decoderParams = decoderParams;
                    else
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset} = evaluarCompresionImagen(ImgOriginal,ImgProt);
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.NomFich = NomFich;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.TiempoEntrenamiento = CpuTime;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.TiempoDecoder = decodetime;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.NumNeurons = NumNeurons;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.encodedShape = encodedShape;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.encodedPrecision = encodedPrecision;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.decoderSizes = decoderSizes;
                      Evaluaciones{NdxRepeticion,NdxDivergence,NdxDataset}.decoderParams = decoderParams;
                    end
                    save(namefile,'Evaluaciones');
                    morecputime = toc(innertimer);
                    fprintf('Tiempo tardado en crear %s: %g segundos\n', namefile, morecputime);
                end

                if isGHBNG || isGHSOM || isGHNG
                  % Obtenemos el mejor modelo (el de máximo PSNR)
                  innertimer = tic;
                  if size(toprocess,1)==1 %fucking retarded matlab removing trailing singleton dimensions :(
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
                elseif isMC0 || isMC1
                  if isempty(MejorModelo),
                      MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence}.PSNR;
                      MejorModelo = ImgProt;
                  elseif Evaluaciones{NdxRepeticion,NdxDivergence}.PSNR > MaximoPSNR,
                      MaximoPSNR = Evaluaciones{NdxRepeticion,NdxDivergence}.PSNR;
                      MejorModelo = ImgProt;
                  end
                end
            end
        end % for NdxRepeticion

        if isGHBNG || isGHSOM || isGHNG
          % Realizamos la validación cruzada
          innertimer = tic;
          MejorModelo.NomFich = NomFich;
          if size(toprocess,1)==1 %fucking retarded matlab removing trailing singleton dimensions :(
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
          if DELETEPREVRUN && exist(namemejormodelo,'file')
            delete(namemejormodelo);
          end
          save(namemejormodelo, 'MejorModelo')
          morecputime = toc(innertimer);
          fprintf('Tiempo tardado en realizar la validacion cruzada: %g segundos\n', morecputime);
        end

        % Guardamos la imagen del mejor modelo
        innertimer = tic;
        if isGHBNG || isGHSOM || isGHNG
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
          encoded = GetPrototypesImg(Centroids,Winners,size(encodedOrig));
          rnd = round(rand*1000000);
          encodedpath = [RutaSalvar sprintf('tmp%d.mat', rnd)];
          encodedimgpath = [RutaSalvar sprintf('tmp%d.png', rnd)];
          save(encodedpath, 'encoded');
          command = sprintf('conda run condaconvenv python pruebaconv1.py --decode --matpath %s --weightpath %s --encodedpath %s --resultpath %s', toprocess{NdxDataset,2}, toprocess{NdxDataset,3}, encodedpath, encodedimgpath);
          system(command, '-echo');
          ImgProt = imread(encodedimgpath);
          delete(encodedpath);
          delete(encodedimgpath);
        elseif isMC0 || isMC1
          ImgProt = MejorModelo;
          if isMC0
            nameimg     = [RutaSalvar 'MC0_' NomFich '.png'];
            nameimgdiff = [RutaSalvar 'MC0_Diff_' NomFich '.png'];
          elseif isMC1
            nameimg     = [RutaSalvar 'MC1_' NomFich '.png'];
            nameimgdiff = [RutaSalvar 'MC1_Diff_' NomFich '.png'];
          end
        end
        morecputime = toc(innertimer);
        fprintf('Tiempo tardado en testear el modelo: %g segundos\n', morecputime);
        imwrite(ImgProt, nameimg);
        ImgDif = abs(ImgDoubleNormalizada-double(ImgProt)/255);
        imwrite(ImgDif, nameimgdiff);

    end % for MaxNeruons
    %close all

end % for dataset
tiempoDeEjecicionDelPrograma = toc(basetimer);
fprintf('\t\t\tEntrenamiento Finalizado en %g segundos\n',tiempoDeEjecicionDelPrograma);
fprintf('fin del programa.\n')
