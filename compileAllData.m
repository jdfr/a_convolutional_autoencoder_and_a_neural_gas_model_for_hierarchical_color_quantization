function compileAllData;
compileAllDataRun(1);
%compileAllDataRun(2);
%compileAllDataRun(3);
%compileAllDataRun(4);

function compileAllDataRun(H);
alsojpeg2000 = false;

originalPixels = 512*512;
uncompressedSize = originalPixels*3*8;

%dosave=false;

prepath = '';

pathMats       = [prepath 'conv/'];
RutasImagenes = {[prepath 'onlybaboonhouselakelena_autoencoder/'], [prepath '4k/']};
Ruta2 = {[prepath 'all/']};

%filenames = {'Baboon.tiff', 'bike.png', 'bird.png', 'building.png', 'chicks.png', 'House.tiff', 'Lake.tiff', 'Lena.tiff', 'mall.png', 'night.png', 'picturesque.png', 'snow.png', 'street.png', 'woman.png'};
%names = cell(size(filenames));
%for k=1:numel(names)
%  ind = strfind(filenames{k},'.');
%  names{k} = filenames{k}(1:ind-1);
%end

%H=1;

Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};
Divergences={'SE','GID','IS','EL','LL'};

%combinaciones [H N D P; ...
combinaciones  = [
H 1 0 8;
H 2 0 8;
H 3 0 8;
H 4 0 8;

%1 1 0  8; 1 2 0  8; 1 3 0  8; 1 4 0  8;
%2 1 0  8; 2 2 0  8; 2 3 0  8; 2 4 0  8;
%3 1 0  8; 3 2 0  8; 3 3 0  8; 3 4 0  8;
%4 1 0  8; 4 2 0  8; 4 3 0  8; 4 4 0  8;
];

% ---->>>>> ESTE PARA N=1 y N=3
%Tau1GHSOM = 0.01; % GHSOM
%Tau2GHSOM = 0.001; % GHSOM
% ---->>>>> ESTE PARA N=3
%Tau1GHSOM = 0.01; % GHSOM
%Tau2GHSOM = 0.01; % GHSOM
% ---->>>>> ESTE PARA N=4
%Tau1GHSOM = 0.1; % GHSOM
%Tau2GHSOM = 0.01; % GHSOM

ghsom_alone = {
  {Ruta2, 'GHSOM_tau101_tau2001/'}; % Tau1GHSOM = 0.01; Tau2GHSOM = 0.001;
  {Ruta2, 'GHSOM_tau101_tau2001/'}; % Tau1GHSOM = 0.01; Tau2GHSOM = 0.001;
  {Ruta2, 'GHSOM_tau101_tau201/'};  % Tau1GHSOM = 0.01; Tau2GHSOM = 0.01;
  {Ruta2, 'GHSOM_tau1_0.1_tau2_0.01/'} % Tau1GHSOM = 0.1; Tau2GHSOM = 0.01;
};
ghsom_path_conv = {
  [prepath 'conv_tau101_tau2001/']; % Tau1GHSOM = 0.01; Tau2GHSOM = 0.001;
  [prepath 'conv_tau101_tau2001/']; % Tau1GHSOM = 0.01; Tau2GHSOM = 0.001;
  [prepath 'conv_tau101_tau201/'];  % Tau1GHSOM = 0.01; Tau2GHSOM = 0.01;
  [prepath 'conv_GHSOM_tau1_0.1_tau2_0.01/'] % Tau1GHSOM = 0.1; Tau2GHSOM = 0.01;
};
ghsom_path_conv = {
  [prepath 'conv_tau101_tau2001/']; % Tau1GHSOM = 0.01; Tau2GHSOM = 0.001;
  [prepath 'conv_tau101_tau201/']; % Tau1GHSOM = 0.01; Tau2GHSOM = 0.01;
  [prepath 'conv_GHSOM_tau1_0.1_tau2_0.01/'];  % Tau1GHSOM = 0.01; Tau2GHSOM = 0.01;
  [prepath 'conv_GHSOM_tau1_0.1_tau2_0.01/'] % Tau1GHSOM = 0.1; Tau2GHSOM = 0.01;
};


imgnames = {
  %'Baboon', 1;
  %'House', 2;
  %'Lake', 3;
  %'Lena', 4;
  'bike', 5;
  'bird', 6;
  'building', 7;
  'chicks', 8;
  'mall', 9;
  'night', 10;
  'picturesque', 11;
  'snow', 12;
  'street', 13;
  'woman', 14
  };

metrics = {'SSIM', 'PSNR', 'MSE', 'NCC', 'TiempoEntrenamiento', 'NumNeurons', 'CR'};

SSIMIndex = 1;
PSNRIndex = 2;
MSEIndex  = 3;
NCCIndex  = 4;
TimeIndex = 5;
CRIndex   = 7;

autoencoders = {'N1', 'N2', 'N3', 'N4'};

modelos = {'JustAutoEncoder', 'GHSOM', 'GHNG', 'MC0', 'MC1', 'GHBNGD1', 'GHBNGD2', 'GHBNGD3', 'GHBNGD4', 'GHBNGD5'};
divergs = [-1                 -1        -1     -1,     -1,   1           2         3           4          5];

indexAE = 1;
indexGHSOM = 2;
indexGHNG = 3;
indexMC0 = 4;
indexMC1 = 5;
divergencesStartingPoint = 6;

NumTrainings = 10;

allmetrics_justGHBNG = zeros(numel(metrics), 5, size(imgnames,1), NumTrainings);
evs = load([RutasImagenes{2} 'GHBNC_standalone/EvaluacionesCuantificacionDivergenciasBregman.mat'],'Evaluaciones').Evaluaciones;
res = load([RutasImagenes{2} 'GHBNC_standalone/ResultadosCuantificacionDivergenciasBregman.mat'],'Resultados').Resultados;
for i=1:size(imgnames,1)
  for d=1:5 % divergences
    for t = 1:NumTrainings
      if numel(size(evs))==2
        ev = evs{t, i};
      elseif numel(size(evs))==3 && size(evs,2)==1
        ev = evs{t, 1, i};
      elseif numel(size(evs))==3 && size(evs,2)==5
        ev = evs{t, d, i};
      end
      allmetrics_justGHBNG(1,d,i,t) = ev.SSIM;
      allmetrics_justGHBNG(2,d,i,t) = ev.PSNR;
      allmetrics_justGHBNG(3,d,i,t) = ev.MSE;
      allmetrics_justGHBNG(4,d,i,t) = ev.NCC;
      if isfield(ev, 'TiempoEntrenamiento')
        allmetrics_justGHBNG(5,d,i,t) = ev.TiempoEntrenamiento;
      else
        allmetrics_justGHBNG(5,d,i,t) = -1; %TiempoEntrenamiento
      end
      if isfield(ev, 'NumNeurons')
        NumNeurons = ev.NumNeurons;
      else
        NumNeurons = res{d,i}.NumNeurons;
      end
      allmetrics_justGHBNG(6,d,i,t) = NumNeurons;
      allmetrics_justGHBNG(7,d,i,t) = uncompressedSize/(originalPixels*(ceil(log2(NumNeurons))) + 8*3*NumNeurons);
      clear ev, NumNeurons;
    end
  end
end
clear evs, res;
meansForTrainings_justGHBNG = mean(allmetrics_justGHBNG,4);
meansForBestDivergence_justGHBNG = zeros(numel(metrics), size(imgnames,1));
indexesForBestDivergence_justGHBNG = zeros(size(imgnames,1),1);
namesBestDivergences_justGHBNG = cell(size(indexesForBestDivergence_justGHBNG));
%get best divergence for each image in GHBNG
for k=1:size(combinaciones,1)
  for i=1:size(imgnames,1)
    PSNRs = meansForTrainings_justGHBNG(PSNRIndex, :,i);
    [bestPSNR, idx] = max(PSNRs);
    indexesForBestDivergence_justGHBNG(i)  = idx;
    indexesForBestDivergence_justGHBNG(i)  = idx;
    namesBestDivergences_justGHBNG{i}      = Divergences{idx};
    meansForBestDivergence_justGHBNG(:, i) = meansForTrainings_justGHBNG(:,idx, i);
  end
end
meansForBestDivergenceAcrossAllImages_justGHBNG = mean(meansForBestDivergence_justGHBNG, 2);





allmetrics = zeros(numel(metrics)+1, size(combinaciones,1), numel(modelos), size(imgnames,1), NumTrainings);
encodedpath_prev = [];
for k=1:size(combinaciones,1)
  H = combinaciones(k,1);
  N = combinaciones(k,2);
  D = combinaciones(k,3);
  P = combinaciones(k,4);
  subcode    = sprintf('R3_H%d_N%d_D%d_P%d_E20000', H, N, D, P);
  for m=1:numel(modelos)
    isAE      = strcmp(modelos{m}, 'JustAutoEncoder');
    isGHNG    = strcmp(modelos{m}, 'GHNG');
    isGHSOM   = strcmp(modelos{m}, 'GHSOM');
    isMC0     = strcmp(modelos{m}, 'MC0');
    isMC1     = strcmp(modelos{m}, 'MC1');
    isGHBNGD1 = strcmp(modelos{m}, 'GHBNGD1');
    if isAE || isGHNG || isGHSOM || isGHBNGD1
      %if exist('mod', 'var'); clear mod; end
      if exist('evs', 'var'); clear evs; end
      if exist('res', 'var'); clear res; end
    end
    if isAE
      evs = load([pathMats sprintf('Evaluaciones_convautoenc_%s', subcode) '.mat'],'Evaluaciones');
      res = load([pathMats sprintf('Resultados_convautoenc_%s', subcode) '.mat'],'Resultados');
      evs = evs.Evaluaciones;
      res = res.Resultados;
      res = res(:,1);
    elseif isGHNG
      evs  = load([prepath 'conv_GHNG/' subcode '/EvaluacionesCuantificacionGHNG.mat'],'Evaluaciones');
      evs = evs.Evaluaciones;
    elseif isGHSOM
      evs  = load([ghsom_path_conv{k} subcode '/EvaluacionesCuantificacionGHSOM.mat'],'Evaluaciones');
      evs = evs.Evaluaciones;
    elseif isMC0 || isMC1
      evs  = load([prepath 'conv_' modelos{m} '/' subcode '/EvaluacionesCuantificacion' modelos{m} '.mat'],'Evaluaciones');
      evs = evs.Evaluaciones;
    elseif isGHBNGD1
      evs  = load([pathMats subcode '/EvaluacionesCuantificacionDivergenciasBregman.mat'],'Evaluaciones');
      evs = evs.Evaluaciones;
    %elseif isGHBNGD2
    %elseif isGHBNGD3
    %elseif isGHBNGD4
    %elseif isGHBNGD5
    end
    if true
      for i=1:size(imgnames,1)
        for t = 1:NumTrainings
          if numel(size(evs))==2
            ev = evs{t, imgnames{i,2}};
          elseif numel(size(evs))==3 && size(evs,2)==1
            ev = evs{t, 1, imgnames{i,2}};
          elseif numel(size(evs))==3 && size(evs,2)==5
            ev = evs{t, divergs(m), imgnames{i,2}};
          end
          allmetrics(1,k,m,i,t) = ev.SSIM;
          allmetrics(2,k,m,i,t) = ev.PSNR;
          allmetrics(3,k,m,i,t) = ev.MSE;
          allmetrics(4,k,m,i,t) = ev.NCC;
          if isfield(ev, 'TiempoEntrenamiento')
            allmetrics(5,k,m,i,t) = ev.TiempoEntrenamiento;
          elseif isAE
            encodedpath = [prepath  sprintf('convP%dH%d/%s_convautoenc_%s_%02d.mat', P, H, imgnames{k}, subcode, t)];
            %datenumber  = dir(encodedpath).datenum;
            if ~isempty(encodedpath_prev) && t>1 % t==1 because results are mostly invalid otherwise
              [~,str] = system(['export ENCODE_PATH_TIMESTAMP_PREV="$(stat -c %.9Y ' encodedpath_prev ')" ; export ENCODE_PATH_TIMESTAMP="$(stat -c %.9Y ' encodedpath ')" ; echo "${ENCODE_PATH_TIMESTAMP}-${ENCODE_PATH_TIMESTAMP_PREV}"']);
              allmetrics(5,k,m,i,t) = eval(str);
            else
              allmetrics(5,k,m,i,t) = -1;
            end
            encodedpath_prev = encodedpath;
          else
            allmetrics(5,k,m,i,t) = -1; %TiempoEntrenamiento
          end
          if isAE
            allmetrics(6,k,m,i,t) = -1; %NumNeurons
            allmetrics(7,k,m,i,t) = uncompressedSize/res{imgnames{i,2}}.compressedSize; %CR
          else
            if isfield(ev, 'NumNeurons')
              allmetrics(6,k,m,i,t) = ev.NumNeurons;
            elseif numel(size(allres{k}))==2
              if size(allres{k},1)==1
                allmetrics(6,k,m,i,t) = res{1,imgnames{i,2}}.NumNeurons;
              else
                allmetrics(6,k,m,i,t) = res{divergs(m),imgnames{i,2}}.NumNeurons;
              end
            end
            sizeDecoder = ev.decoderParams*32;
            size_reduced = ev.encodedShape(1);
            latentDim = ev.encodedShape(end);
            numpixels_reduced = size_reduced*size_reduced;
            sizeData = numpixels_reduced*(ceil(log2(ev.NumNeurons))) + ev.encodedPrecision*latentDim*ev.NumNeurons;
            allmetrics(7,k,m,i,t) = uncompressedSize/(sizeDecoder + sizeData); %CR
            if isMC0 || isMC1
              allmetrics(8,k,m,i,t) = ev.TiempoDecoder;
            else
              allmetrics(8,k,m,i,t) = -1;
            end
          end
          clear ev;
        end
      end
    else
    end
  end
end

timesAE = cell(4,3);
for k=1:size(timesAE,1)
  timesAE{k,1} = squeeze(allmetrics(5,k,1,:));
  timesAE{k,1} = timesAE{k,1}(timesAE{k,1}>=0);
  timesAE{k,2} = mean(timesAE{k,1});
  timesAE{k,3} = std(timesAE{k,1}, 0);
  fprintf('Mean encoding times for N=%d: %f, std: %f\n', k, timesAE{k,2}, timesAE{k,3});
end
%Mean encoding times for N=1: 34.288889, std: 0.403930
%Mean encoding times for N=2: 94.044446, std: 0.640563
%Mean encoding times for N=3: 177.478225, std: 0.666686
%Mean encoding times for N=4: 284.184449, std: 0.673517

meansForTrainings = mean(allmetrics,5);
stdsForTrainings  = std(allmetrics,0,5);
meansAcrossAllImages = mean(meansForTrainings, 4);
meansForBestDivergence = zeros(numel(metrics)+1, size(combinaciones,1), size(imgnames,1));
stdsForBestDivergence = zeros(numel(metrics)+1, size(combinaciones,1), size(imgnames,1));
indexesForBestDivergence = zeros(size(combinaciones,1), size(imgnames,1));
namesBestDivergences = cell(size(indexesForBestDivergence));

%get best divergence for each image in each autoencoder
for k=1:size(combinaciones,1)
  for i=1:size(imgnames,1)
    PSNRs = meansForTrainings(PSNRIndex, k, divergencesStartingPoint:end,i);
    [bestPSNR, idx] = max(PSNRs);
    indexesForBestDivergence(k, i)  = idx;
    namesBestDivergences{k,i} = Divergences{idx};
    meansForBestDivergence(:, k, i) = meansForTrainings(:,k, divergencesStartingPoint-1+idx, i);
    stdsForBestDivergence(:, k, i)  = stdsForTrainings( :,k, divergencesStartingPoint-1+idx, i);
  end
end

meansForBestDivergenceAcrossAllImages = mean(meansForBestDivergence, 3);


medianCutDepths = [12, 13, 14];
evs = load([RutasImagenes{2} 'medianCut_standalone/EvaluacionesMedianCut_modo0.mat'],'Evaluaciones').Evaluaciones; %cell(NumEntrenamientos,numel(depths),length(d));
allmetrics_justMedianCut = zeros(numel(metrics), numel(medianCutDepths), size(imgnames,1), NumTrainings);
for i=1:size(imgnames,1)
  for d=1:numel(medianCutDepths)
    for t = 1:NumTrainings
      ev = evs{t,d,i};
      allmetrics_justMedianCut(1,d,i,t) = ev.SSIM;
      allmetrics_justMedianCut(2,d,i,t) = ev.PSNR;
      allmetrics_justMedianCut(3,d,i,t) = ev.MSE;
      allmetrics_justMedianCut(4,d,i,t) = ev.NCC;
      allmetrics_justMedianCut(5,d,i,t) = ev.TiempoEntrenamiento;
      allmetrics_justMedianCut(6,d,i,t) = ev.NumNeurons;
      allmetrics_justMedianCut(7,d,i,t) = uncompressedSize/(originalPixels*(ceil(log2(ev.NumNeurons))) + 8*3*ev.NumNeurons);;
    end
  end
end
clear evs, ev;
meansForTrainings_justMedianCut = mean(allmetrics_justMedianCut,4);
meansAcrossAllImages_justMedianCut = mean(meansForTrainings_justMedianCut,3);


fprintf('\nMejores divergencias sin autoencoder para cada imagen\n');
disp([{'bike',  'bird',  'building',  'chicks',  'mall',  'night',  'picturesque',  'snow',  'street',  'woman'}; namesBestDivergences_justGHBNG']);

fprintf('Mejores divergencias para cada autoencoder e imagen\n');
disp([{' ', 'bike',  'bird',  'building',  'chicks',  'mall',  'night',  'picturesque',  'snow',  'street',  'woman'};[{'N=1','N=2','N=3','N=4'}' namesBestDivergences]]);

fprintf('Medias de PSNR para imagen night, para cada autoencoder y cada divergencia \n');
disp([{' ' Divergences{:}}; [{'N=1','N=2','N=3','N=4'}' num2cell(squeeze(squeeze(meansForTrainings(2,:,divergencesStartingPoint:end,6))))]]);

showGraphs = false;
if showGraphs
  c1 = '#0072BD';
  c2 = '#D95319';
  c3 = '#EDB120';
  c4 = '#BE6FCE'; %'#7E2F8E';
  c5 = '#1010FF'; %'#77AC30';
  c6 = '#FF1010'; %'#4DBEEE';
  c7 = '#10FF10'; %'#A2142F';
  c8 = '#7E2F8E'; %'#1010EE';
  c9 = '#1010DD';
  cA = '#DD1010';
  cB = '#10DD10';
  cC = '#FFFF10';
  cD = '#101099';
  cE = '#991010';
  cF = '#109910';
  cG = '#BBBB10';
  c9 = '#101099';
  cA = '#991010';
  cB = '#109910';
  cC = '#BBBB10';

  c1 = '#0092DD';
  c2 = '#F97339';
  c3 = '#FDE160';
  c4 = '#DE8FEE';
  cD = '#101099';
  cE = '#A92300';
  cF = '#BD9110';
  cG = '#8E3F9E';

  c_otro = '#101010'; %'#FF1010';
  cN = '#000000';
  m1='^';
  m2='<';
  m3='>';
  m4='v';

  plotData = {...
  %'MedianCut_12', 'Marker', 's', 'Color', cN, 'MarkerFaceColor', cN, 'Linestyle', 'none';
  'MC', 'Marker', 'd', 'Color', cN, 'MarkerFaceColor', cN, 'Linestyle', 'none';
  %'MedianCut_14', 'Marker', 'p', 'Color', cN, 'MarkerFaceColor', cN, 'Linestyle', 'none';
  'GHBNG', 'Marker', 'o', 'Color', cN, 'MarkerFaceColor', cN, 'Linestyle', 'none';
  'N1', 'Marker', m1, 'Color', cN, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  'N2', 'Marker', m1, 'Color', cN, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  'N3', 'Marker', m1, 'Color', cN, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  'N4', 'Marker', m1, 'Color', cN, 'MarkerFaceColor', c4, 'Linestyle', 'none';
  %'N1-GHSOM', 'Marker', m3, 'Color', c1, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  %'N2-GHSOM', 'Marker', m3, 'Color', c2, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  %'N3-GHSOM', 'Marker', m3, 'Color', c3, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  %'N4-GHSOM', 'Marker', m3, 'Color', c4, 'MarkerFaceColor', c4, 'Linestyle', 'none';
  %'N1-GHNG', 'Marker', m2, 'Color', c1, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  %'N2-GHNG', 'Marker', m2, 'Color', c2, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  %'N3-GHNG', 'Marker', m2, 'Color', c3, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  %'N4-GHNG', 'Marker', m2, 'Color', c4, 'MarkerFaceColor', c4, 'Linestyle', 'none';
  'N1-GHBNG', 'Marker', m4, 'Color', cD, 'MarkerFaceColor', cD, 'Linestyle', 'none';
  'N2-GHBNG', 'Marker', m4, 'Color', cE, 'MarkerFaceColor', cE, 'Linestyle', 'none';
  'N3-GHBNG', 'Marker', m4, 'Color', cF, 'MarkerFaceColor', cF, 'Linestyle', 'none';
  'N4-GHBNG', 'Marker', m4, 'Color', cG, 'MarkerFaceColor', cG, 'Linestyle', 'none';
  'N1-MC', 'Marker', m2, 'Color', c1, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  'N2-MC', 'Marker', m2, 'Color', c2, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  'N3-MC', 'Marker', m2, 'Color', c3, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  'N4-MC', 'Marker', m2, 'Color', c4, 'MarkerFaceColor', c4, 'Linestyle', 'none';
  };
  names   = plotData(:,1);
  markers = plotData(:,2:end);
  
  graphmetrics = {...
    'SSIM', 1, true, [0.5 1]; %[0.54 1];
    'PSNR', 2, true, [18 45];%[19 45];
    'MSE', 3, false, [0 3144];%[0 2450];
    'NCC', 4, true, [0.9 1];%[0.923 1];
  };
  for n=1:size(graphmetrics,1)
    y_ae    = reshape(meansAcrossAllImages(graphmetrics{n,2}, :, indexAE), [], 1);
    x_ae    = reshape(meansAcrossAllImages(CRIndex,           :, indexAE), [], 1);
    %y_ghng_ae  = reshape(meansAcrossAllImages(graphmetrics{n,2}, :, indexGHNG), [], 1);
    %x_ghng_ae  = reshape(meansAcrossAllImages(CRIndex,           :, indexGHNG), [], 1);
    %y_ghsom_ae = reshape(meansAcrossAllImages(graphmetrics{n,2}, :, indexGHSOM), [], 1);
    %x_ghsom_ae = reshape(meansAcrossAllImages(CRIndex,           :, indexGHSOM), [], 1);
    y_ghbng_ae = reshape(meansForBestDivergenceAcrossAllImages(graphmetrics{n,2}, :), [], 1);
    x_ghbng_ae = reshape(meansForBestDivergenceAcrossAllImages(CRIndex,           :), [], 1);
    y_ghbng    = reshape(meansForBestDivergenceAcrossAllImages_justGHBNG(graphmetrics{n,2}, :), [], 1);
    x_ghbng    = reshape(meansForBestDivergenceAcrossAllImages_justGHBNG(CRIndex,           :), [], 1);
    y_mcut13   = reshape(meansAcrossAllImages_justMedianCut(graphmetrics{n,2}, 2), [], 1);
    x_mcut13   = reshape(meansAcrossAllImages_justMedianCut(CRIndex,           2), [], 1);
    y_ghng_mc0 = reshape(meansAcrossAllImages(graphmetrics{n,2}, :, indexMC0), [], 1);
    x_ghng_mc0 = reshape(meansAcrossAllImages(CRIndex,           :, indexMC0), [], 1);
    %x_all   = [x_ae; x_ghsom_ae; x_ghng_ae; x_ghbng_ae];
    %y_all   = [y_ae; y_ghsom_ae; y_ghng_ae; y_ghbng_ae];
    x_all   = [x_mcut13; x_ghbng; x_ae; x_ghbng_ae; x_ghng_mc0];
    y_all   = [y_mcut13; y_ghbng; y_ae; y_ghbng_ae; y_ghng_mc0];
    paretoPoints  = computePareto(x_all, y_all, graphmetrics{n,3});
    fig = figure;
    hold on;
    plot(paretoPoints(:,1), paretoPoints(:,2), 'k');
    for k=1:numel(x_all);
      plot(x_all(k), y_all(k), markers{k,:});
    end
    %title(sprintf('%s', graphmetrics{n,1}));
    if strcmp('PSNR', graphmetrics{n,1})
      legend({'', names{:}}, 'NumColumns', 2);
    end
    xlabel('compression ratio');
    ylabel(graphmetrics{n,1});
    xlim([0 170]);
    if ~isempty(graphmetrics{n,4})
      ylim(graphmetrics{n,4});
    end
    pos = get(gcf, 'Position');
    pos(end) = pos(end)-pos(end)/3;
    set(gcf, 'Position', pos);
    saveas(gcf, sprintf('pareto_H%d_%s.pdf', H, graphmetrics{n,1}), 'pdf');
  end
  system('for f in MSE PSNR SSIM NCC; do pdfcrop --margins ''0 0 0 0'' pareto_H1_${f}.pdf pareto_H1_${f}_cropped.pdf; done', '-echo')
end

printTable = true;
if printTable
  printmetrics = {...
    'MSE', MSEIndex, 'min';
    'PSNR', PSNRIndex, 'max';
    'SSIM', SSIMIndex, 'max';
    'NCC', NCCIndex, 'max';
    'CR', CRIndex, 'max';
    'Time', TimeIndex, 'min';
    'Time+AE', TimeIndex, 'min';
  };
  numZeros={ % NxMETRICS
  %[2 2], [2 2], [3 2], [3 2], [2 2];
  %[2 2], [2 2], [3 2], [3 2], [2 2];
  %[1 1], [2 2], [3 2], [3 2], [2 2];
  %[1 1], [2 2], [3 2], [3 2], [2 2];
  [1 1], [2 2], [3 2], [3 2], [2 2], [2 2], [2 2];
  [1 1], [2 2], [3 2], [3 2], [2 2], [2 2], [2 2];
  [1 1], [2 2], [3 2], [3 2], [2 2], [3 2], [1 2];
  [1 1], [2 2], [3 2], [3 2], [2 2], [3 2], [1 2];
  };
  
  printModelos = {'GHBNG', 'GHSOM', 'GHNG', 'MC'};
  for k=1:size(combinaciones,1)
    fprintf('N=%d\n', combinaciones(k,2));
    for n = 1:size(printmetrics,1)
      isMin = strcmp(printmetrics{n,3}, 'min');
      isMax = strcmp(printmetrics{n,3}, 'max');
      meansForAllImages = zeros(numel(printModelos), size(imgnames,1));
      stdsForAllImages  = zeros(numel(printModelos), size(imgnames,1));
      for i=1:size(imgnames,1)
        meansForAllImages(1,i) = meansForBestDivergence(printmetrics{n,2}, k, i);
         stdsForAllImages(1,i) =  stdsForBestDivergence(printmetrics{n,2}, k, i);
        meansForAllImages(2,i) = meansForTrainings(printmetrics{n,2}, k, indexGHSOM, i);
         stdsForAllImages(2,i) =  stdsForTrainings(printmetrics{n,2}, k, indexGHSOM, i);
        meansForAllImages(3,i) = meansForTrainings(printmetrics{n,2}, k, indexGHNG, i);
         stdsForAllImages(3,i) =  stdsForTrainings(printmetrics{n,2}, k, indexGHNG, i);
        meansForAllImages(4,i) = meansForTrainings(printmetrics{n,2}, k, indexMC0, i);
         stdsForAllImages(4,i) =  stdsForTrainings(printmetrics{n,2}, k, indexMC0, i);
      end
      if strcmp(printmetrics{n,1}, 'Time+AE')
        meansForAllImages(1:4,:) =     meansForAllImages(1:4,:)   +timesAE{k,2};
         stdsForAllImages(1:4,:) = sqrt(stdsForAllImages(1:4,:).^2+timesAE{k,3}.^2);
      end
      [nothing, maxsForAllImages] = max(meansForAllImages,[],1);
      [nothing, minsForAllImages] = min(meansForAllImages,[],1);
      fprintf('\\multirow{%d}{*}{%s} ', numel(printModelos), printmetrics{n,1});
      for x=1:4
        fprintf(' & %s ', printModelos{x});
        for i=1:size(imgnames,1)
          spec = sprintf('%%0.0%df (%%0.0%df)', numZeros{k, n}(1), numZeros{k, n}(2));
          if (isMin && minsForAllImages(i)==x) || (isMax && maxsForAllImages(i)==x)
            fprintf(['& \\textbf{' spec '} '], meansForAllImages(x, i), stdsForAllImages(x, i));
          else
            fprintf(['& ' spec ' '], meansForAllImages(x, i), stdsForAllImages(x, i));
          end
        end
        fprintf('\\tabularnewline\n');
      end
      fprintf('\\hline\n');
    end
  end
end

printGanadores = false;
if printGanadores
  printmetrics = {...
    'MSE', MSEIndex, 'min';
    'PSNR', PSNRIndex, 'max';
    'SSIM', SSIMIndex, 'max';
    'NCC', NCCIndex, 'max';
    'CR', CRIndex, 'max';
  };
  printModelos = {'GHBNG', 'GHSOM', 'GHNG'};
  vecesGanadores = zeros(numel(printModelos), size(printmetrics, 1));
  for k=1:size(combinaciones,1)
    for n = 1:size(printmetrics,1)
      isMin = strcmp(printmetrics{n,3}, 'min');
      isMax = strcmp(printmetrics{n,3}, 'max');
      meansForAllImages = zeros(3, size(imgnames,1));
      stdsForAllImages  = zeros(3, size(imgnames,1));
      for i=1:size(imgnames,1)
        meansForAllImages(1,i) = meansForBestDivergence(printmetrics{n,2}, k, i);
         stdsForAllImages(1,i) =  stdsForBestDivergence(printmetrics{n,2}, k, i);
        meansForAllImages(2,i) = meansForTrainings(printmetrics{n,2}, k, indexGHSOM, i);
         stdsForAllImages(2,i) =  stdsForTrainings(printmetrics{n,2}, k, indexGHSOM, i);
        meansForAllImages(3,i) = meansForTrainings(printmetrics{n,2}, k, indexGHNG, i);
         stdsForAllImages(3,i) =  stdsForTrainings(printmetrics{n,2}, k, indexGHNG, i);
      end
      [nothing, maxsForAllImages] = max(meansForAllImages,[],1);
      [nothing, minsForAllImages] = min(meansForAllImages,[],1);
      for i=1:size(imgnames,1)
        for x=1:3
          if (isMin && minsForAllImages(i)==x) || (isMax && maxsForAllImages(i)==x)
            %fprintf('Para N=%d, %s y %s gana: %s\n', combinaciones(k,2), printmetrics{n,1}, imgnames{i,1}, printModelos{x});
            vecesGanadores(x,n)=vecesGanadores(x,n)+1;
          end
        end
      end
    end
  end
  fprintf('Veces que gana cada uno en cada métrica con H=%d\n', H);
  disp([[{' '} printmetrics(:,1)']; [printModelos' num2cell(vecesGanadores)]]);
end


function points = computePareto(x, y, invertValues)

matr = [-x,y];
if invertValues
  matr(:,2) = -matr(:,2);
end
front = paretofront(matr);
points = matr(front,:);
points(:,1) = -points(:,1);
if invertValues
  points(:,2) = -points(:,2);
end
points = sortrows(points, 1);

