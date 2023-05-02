function showPareto3(MEANOFIMAGES, alldivergencesSingleImage, dosave);
%function showPareto3(MEANOFIMAGES);

alsojpeg2000 = false;

uncompressedSize = 512*512*3*8;

%alldivergencesSingleImage = false;
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

%combinaciones [H N D P; ...
combinaciones  = [
4 1 0 8;
3 1 0 8;
2 1 0 8;
1 1 0 8;
4 2 0 8;
3 2 0 8;
2 2 0 8;
1 2 0 8;
4 3 0 8;
3 3 0 8;
2 3 0 8;
1 3 0 8;
4 4 0 8;
3 4 0 8;
2 4 0 8;
1 4 0 8;

%1 1 0  8; 1 2 0  8; 1 3 0  8; 1 4 0  8;
%2 1 0  8; 2 2 0  8; 2 3 0  8; 2 4 0  8;
%3 1 0  8; 3 2 0  8; 3 3 0  8; 3 4 0  8;
%4 1 0  8; 4 2 0  8; 4 3 0  8; 4 4 0  8;
];

%'|b',
%'|g'
%'.b','ob','+b','xb', ...%'^b','vb','<b','>b','pb','hb','sb','db',
%'.g','og','+g','xg', ...%'^g','vg','<g','>g','pg','hg','sg','dg',
%markers = {'.b','ob','+b','xb','^b','vb','<b','>b','pb','hb','sb','db','.c','oc','+c','xc'     '.g','og','+g','xg','^g','vg','<g','>g','pg','hg','sg','dg','.y','oy','+y','xy' }';
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
c_otro = '#101010'; %'#FF1010';
m1='^';
m2='<';
m3='>';
m4='v';

markers1 = markerBlock(m1, m2, m3, m4, c1, c2, c3, c4);
markers2 = markerBlock(m1, m2, m3, m4, c5, c6, c7, c8);
markers = [markers1; markers2];

%markers = {'.b','ob',     '.g','og'}';

also_without_autoencoder = true;
also_just_ghsom = false;
also_just_ghng = true;
num_divergences = 5;
%Tau1GHSOM = 0.001; % GHSOM
%Tau2GHSOM = 0.0001; % GHSOM
%ghsom_alone = {Ruta2, 'GHBNC_standalone/'}; ghsom_path_conv = [pathMats];

%Tau1GHSOM = 0.001; % GHSOM
%Tau2GHSOM = 0.001; % GHSOM
%ghsom_alone = {Ruta2, 'GHBNC_standalone_tau2_001/'}; ghsom_path_conv = [prepath 'conv_tau2_001/'];

% ---->>>>> ESTE PARA N=1 y N=3
%Tau1GHSOM = 0.01; % GHSOM
%Tau2GHSOM = 0.001; % GHSOM
%ghsom_alone = {Ruta2, 'GHSOM_tau101_tau2001/'}; ghsom_path_conv = [prepath 'conv_tau101_tau2001/'];

% ---->>>>> ESTE PARA N=3
%Tau1GHSOM = 0.01; % GHSOM
%Tau2GHSOM = 0.01; % GHSOM
ghsom_alone = {Ruta2, 'GHSOM_tau101_tau201/'}; ghsom_path_conv = [prepath 'conv_tau101_tau201/'];

% ---->>>>> ESTE PARA N=4
%Tau1GHSOM = 0.1; % GHSOM
%Tau2GHSOM = 0.01; % GHSOM
%ghsom_alone = {Ruta2, 'GHSOM_tau1_0.1_tau2_0.01/'}; ghsom_path_conv = [prepath 'conv_GHSOM_tau1_0.1_tau2_0.01/'];

nadd = 0;%also_without_autoencoder+also_just_ghsom+also_just_ghng;

nc = size(combinaciones,1);
tot = nc*(2+also_just_ghsom+also_just_ghng)+nadd;
allevs  = cell(tot, 1);
allmods = cell(tot, 1);
allres  = cell(tot, 1);
names   = cell(tot, 1);

for k=1:nc
  H = combinaciones(k,1);
  N = combinaciones(k,2);
  D = combinaciones(k,3);
  P = combinaciones(k,4);
  subcode    = sprintf('R3_H%d_N%d_D%d_P%d_E20000', H, N, D, P);
  allevs{k+nadd}  = load([pathMats sprintf('Evaluaciones_convautoenc_%s', subcode) '.mat'],'Evaluaciones');
  allevs{k+nadd}  = getfield(allevs{k+nadd}, 'Evaluaciones');
  allmods{k+nadd} = [];
  allres{k+nadd}  = load([pathMats sprintf('Resultados_convautoenc_%s', subcode) '.mat'],'Resultados');
  allres{k+nadd}  = getfield(allres{k+nadd}, 'Resultados');
  allres{k+nadd}  = allres{k+nadd}(:,1);
  names{k+nadd}   = sprintf('N%d-H%d', N,H); %sprintf('H%d-N%d-D%d-P%d', H, N, D, P);
  %names{k+nadd}   = sprintf(' H%d', H);
  kk = k+nc;
  allevs{kk+nadd}  = load([pathMats subcode '/EvaluacionesCuantificacionDivergenciasBregman.mat'],'Evaluaciones');
  allevs{kk+nadd}  = allevs{kk+nadd}.Evaluaciones;
  allmods{kk+nadd} = 1;
  names{kk+nadd}   = [names{k+nadd} '-GHBNG'];
  if also_just_ghsom
    kk = kk+nc;
    allevs{kk+nadd}  = load([ghsom_path_conv subcode '/EvaluacionesCuantificacionGHSOM.mat'],'Evaluaciones');
    allevs{kk+nadd}  = allevs{kk+nadd}.Evaluaciones;
    allmods{kk+nadd} = 1;
    names{kk+nadd}   = [names{k+nadd} '-GHSOM'];
  end
  if also_just_ghng
    kk = kk+nc;
    allevs{kk+nadd}  = load([prepath 'conv_GHNG/' subcode '/EvaluacionesCuantificacionGHNG.mat'],'Evaluaciones');
    allevs{kk+nadd}  = allevs{kk+nadd}.Evaluaciones;
    allmods{kk+nadd} = 1;
    names{kk+nadd}   = [names{k+nadd} '-GHNG'];
  end
end
if alsojpeg2000
  ev2000 = load([pathMats 'Evaluaciones_JPEG2000.mat'],'Evaluaciones').Evaluaciones;
end

imgnames = {
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
if also_just_ghsom
  orderedevs  = loadRutas(ghsom_alone{:}, 'EvaluacionesCuantificacionGHSOM.mat', 'Evaluaciones');
  orderedres  = loadRutas(ghsom_alone{:}, 'ResultadosCuantificacionGHSOM.mat', 'Resultados');
  allevs  = [{orderedevs}; allevs];
  allres  = [{orderedres}; allres];
  allmods = [{0}; allmods];
  names   = [{'GHSOM'}; names];
  block   = markerBlock(m1, m2, m3, m4, c9, cA, cB, cC);
  markers = [{'Marker', 's', 'Color', c_otro, 'MarkerFaceColor', c_otro, 'Linestyle', 'none'}; markers; block];
end
if also_just_ghng
  orderedevs  = loadRutas(Ruta2, 'GHNG_standalone/', 'EvaluacionesCuantificacionGHNG.mat', 'Evaluaciones');
  orderedres  = loadRutas(Ruta2, 'GHNG_standalone/', 'ResultadosCuantificacionGHNG.mat', 'Resultados');
  allevs  = [{orderedevs}; allevs];
  allres  = [{orderedres}; allres];
  allmods = [{0}; allmods];
  names   = [{'GHNG'}; names];
  block   = markerBlock(m1, m2, m3, m4, cD, cE, cF, cG);
  markers = [{'Marker', 'd', 'Color', c_otro, 'MarkerFaceColor', c_otro, 'Linestyle', 'none'}; markers; block];
end
if also_without_autoencoder
  unorderedevs  = loadRutas(RutasImagenes, 'GHBNC_standalone/', 'EvaluacionesCuantificacionDivergenciasBregman.mat', 'Evaluaciones');
  unorderedres  = loadRutas(RutasImagenes, 'GHBNC_standalone/', 'ResultadosCuantificacionDivergenciasBregman.mat', 'Resultados');
  orderedevs=cell(size(unorderedevs));
  orderedres=cell(size(unorderedres));
  for k1 = 1:size(unorderedevs,3)
    for k2 = 1:size(unorderedevs,3)
      if strcmp(imgnames{k1}, unorderedevs{1,1,k2}.NomFich)
        orderedevs(:,:,k1)=unorderedevs(:,:,k2);
        orderedres(:,k1)  =unorderedres(:,k2);
        break;
      end
    end
  end
  allevs  = [{orderedevs}; allevs];
  allres  = [{orderedres}; allres];
  allmods = [{0}; allmods];
  names   = [{'GHBNG'}; names];
  %markers{end+1} = '.r';
  markers = [{'Marker', 'o', 'Color', c_otro, 'MarkerFaceColor', c_otro, 'Linestyle', 'none'}; markers];
end
  basepath = '';

  subcode = sprintf('R3_H%d_N%d_D%d_P%d_E20000', H, N, D, P);

  RutaSalvar = [basepath 'conv/' subcode '/'];

%fields = {'SSIM', 'max'; 'PSNR', 'max'; 'MSE', 'min'; 'NCC', 'max'};
%fields = {'AD', 'min', [], []; 'MD', 'min', [], []; 'NAE', 'min', [], []; 'SC', 'min', [], []};
%fields = {'AD', 'min', [], []; 'MD', 'min', [], []; 'NAE', 'min', [], []; 'SC', 'min', [], []; 'SSIM', 'max', [], []; 'PSNR', 'max', [], []; 'MSE', 'min', [], []; 'NCC', 'max', [], []};
%fields = {'SSIM', 'max', [], []; 'PSNR', 'max', [], [19 45]; 'MSE', 'min', [], []; 'NCC', 'max', [], []};
fields = {'PSNR', 'max', [], [19 45]};
%fields = {'NumNeurons', 'max', [], []; 'NumNeurons', 'min', [], []};
%fields = {'SSIM', 'max', [], []; 'PSNR', 'max', [], [19 45]; 'MSE', 'min', [], []; 'NCC', 'max', [], []; 'NumNeurons', 'max', [], []; 'NumNeurons', 'min', [], []};
Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};

%close all;

sae = size(allevs{1});
imagenames = cell(sae(end),1);
for Image=1:numel(imagenames)
  imagenames{Image} = allevs{2}{1,Image}.NomFich;
end
if MEANOFIMAGES
  paretoname = 'pareto front';
else
  paretoname = 'pareto front for mean values across all images';
end
linenames = names;
if MEANOFIMAGES
  linenames = [{paretoname}; linenames;];
end
if alsojpeg2000
  linenames = [linenames; {'JPEG2000'}];
end

%%%%%%%%%%%%% A FIGURE FOR EACH MEASURE
if alldivergencesSingleImage

Evaluaciones = cell(numel(combinaciones), numel(names));
  for f=1:size(fields,1)
    field = fields{f,1};
    if alsojpeg2000
      e2000_compression = zeros(size(ev2000,1),1);
      if MEANOFIMAGES
        e2000_values     = zeros(size(ev2000,1),1);
      else
        e2000_values     = zeros(size(ev2000));
      end
      for compression=1:size(ev2000,1)
        values = zeros(size(ev2000,2),1);
        for Image=1:size(ev2000,2)
          values(Image) = getfield(ev2000{compression,Image}, field);
          if isinf(values(Image))
            values(Image)=100;
          end
        end
        e2000_compression(compression) = ev2000{compression,1}.compress;
        if MEANOFIMAGES
          e2000_values(compression) = mean(values);
        else
          e2000_values(compression,:) = values;
        end
      end
      if ~MEANOFIMAGES
        e2000_compression = repmat(e2000_compression, 1, size(ev2000, 2));
      end
    end
    valuesbyname = cell(size(names));
    compressedSizesByName = cell(size(names));
    imagenamesByName = cell(size(names));
    DivergencesByName = cell(size(names));
    autoencoderByName = cell(size(names));
    for Divergence = 1:5
      for Image=1:numel(imagenames)
        for k=1:numel(allevs)
          values = zeros(size(allevs{k}, 1), 1);
          for n=1:numel(values)
            if numel(size(allevs{k}))<3 %isempty(allmods{k}) || numel(size(allevs))<3
              ev  = allevs{k}{n,Image};
            else
              ev  = allevs{k}{n,Divergence,Image};
            end
            NomFich = ev.NomFich;
            values(n) = getfield(ev, field);
          end
          if isempty(allmods{k})
            compressedSizesByName{k}(end+1) = allres{k}{Image}.compressedSize/uncompressedSize;
          elseif allmods{k}==0
            numpixels_init = 512*512;
            compressedSizesByName{k}(end+1) = (numpixels_init*(ceil(log2(allres{k}{Image}.NumNeurons))) + 8*3*allres{k}{Divergence,Image}.NumNeurons)/uncompressedSize;
          else
            sizeDecoder = ev.decoderParams*32;
            size_reduced = ev.encodedShape(1);
            latentDim = ev.encodedShape(end);
            numpixels_reduced = size_reduced*size_reduced;
            sizeData = numpixels_reduced*(ceil(log2(ev.NumNeurons))) + ev.encodedPrecision*latentDim*ev.NumNeurons;
            compressedSizesByName{k}(end+1) = (sizeDecoder + sizeData)/uncompressedSize;
          end
          if strcmp('max', fields{f,2})
            valuesbyname{k}(end+1) = max(values);
          else
            valuesbyname{k}(end+1) = min(values);
          end
          %fprintf('Divergence=%d, Image=%d, k=%d, n=%d, isempty(modelo)=%d, use_autoenc=%d', Divergence, Image , k, n, isempty(allmods{k}), use_autoenc);
          if isempty(imagenamesByName{k})
            imagenamesByName{k}  = {imagenames{Image}};
            DivergencesByName{k} = {Divergences{Divergence}};
            autoencoderByName{k} = {names{k}};
          elseif ~MEANOFIMAGES
            imagenamesByName{k}{end+1}  = imagenames{Image};
            DivergencesByName{k}{end+1} = Divergences{Divergence};
            autoencoderByName{k}{end+1} = names{k};
          end
        end
      end
    end
    valuesbynameMean          = computeMeans(valuesbyname);
    compressedSizesByNameMean = computeMeans(compressedSizesByName);
    if MEANOFIMAGES
      valuesbyname          = valuesbynameMean;
      compressedSizesByName = compressedSizesByNameMean;
      paretoFormat          = 'k';
    else
      paretoFormat          = '-ok';
    end
    everything = cat(2, compressedSizesByName, valuesbyname, markers)';
    everything = everything(:);
    invertValues = strcmp('max', fields{f,2});
    figure;
    if MEANOFIMAGES
      %paretoPoints = computePareto(compressedSizesByNameMean(1:end-also_without_autoencoder), valuesbynameMean(1:end-also_without_autoencoder), invertValues);
      paretoPoints = computePareto(compressedSizesByNameMean, valuesbynameMean, invertValues);
      p=plot(paretoPoints(:,1), paretoPoints(:,2), paretoFormat, everything{:});
      markerjpge2000 = 'm';
    else
      p=plot(everything{:});
      markerjpge2000 = '.m';
    end
    if alsojpeg2000
      hold on;
      p2 = plot(e2000_compression(:), e2000_values(:), markerjpge2000);
    end
    if MEANOFIMAGES
      %text([compressedSizesByName{:}], [valuesbynameMean{:}], names);
      subname='each point is the mean across all images';
    else
      subname='each point is the best result for an image';
      %for x=2:numel(p)
      for x=1:numel(p)
        %p(x).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Image",imagenamess);
        %p(x).DataTipTemplate.DataTipRows([end+1;end+2]) = [dataTipTextRow("Image",imagenamess);dataTipTextRow("Divergence",divergencess)];
        %p(x).DataTipTemplate.DataTipRows([end+1;end+2;end+3]) = [dataTipTextRow("Image",cat(2,imagenamesByName{:})); dataTipTextRow("Divergence",cat(2,DivergencesByName{:})); dataTipTextRow("Autoencoder",cat(2,autoencoderByName{:}))];
        p(x).DataTipTemplate.DataTipRows([end+1;end+2;end+3]) = [dataTipTextRow("Image",imagenamesByName{x}); dataTipTextRow("Divergence",DivergencesByName{x}); dataTipTextRow("Autoencoder",autoencoderByName{x})];
      end
    end
    title(sprintf('%s (%s)', field, subname));
    if ~MEANOFIMAGES
      legend(linenames);
    end
    xlabel('compressed size');
    ylabel(field);
    if dosave
      if MEANOFIMAGES
        subname = 'MEAN';
      else
        subname = 'ALLIMAGESANDDIVERGENCES';
      end
      saveas(gcf,[RutasImagenes{1} sprintf('ojalaPareto.%s.%s.fig', subname, field)], 'fig');
      close all;
    end
  end

end




%%%%%%%%%%%%% A FIGURE FOR EACH MEASURE
if ~alldivergencesSingleImage

  fid = fopen('allresults.txt', 'w');

  for f=1:size(fields,1)
    field = fields{f,1};
    if alsojpeg2000
      e2000_compression = zeros(size(ev2000,1),1);
      if MEANOFIMAGES
        e2000_values     = zeros(size(ev2000,1),1);
      else
        e2000_values     = zeros(size(ev2000));
      end
      for compression=1:size(ev2000,1)
        values = zeros(size(ev2000,2),1);
        for Image=1:size(ev2000,2)
          values(Image) = getfield(ev2000{compression,Image}, field);
          if isinf(values(Image))
            values(Image)=100;
          end
        end
        e2000_compression(compression) = ev2000{compression,1}.compress;
        if MEANOFIMAGES
          e2000_values(compression) = mean(values);
        else
          e2000_values(compression,:) = values;
        end
      end
      if ~MEANOFIMAGES
        e2000_compression = repmat(e2000_compression, 1, size(ev2000, 2));
      end
    end
    for Divergence = [1 5]%1:5
      valuesbyname = cell(size(names));
      meansbyname  = cell(size(names));
      stdsbyname   = cell(size(names));
      outsbyname   = cell(size(names));
      compressedSizesByName = cell(size(names));
      for Image=1:numel(imagenames)
        for k=1:numel(allevs)
          values = zeros(size(allevs{k}, 1), 1);
          for n=1:numel(values)
            if numel(size(allevs{k}))<3 %isempty(allmods{k}) || numel(size(allevs))<3
              ev  = allevs{k}{n,Image};
            elseif size(allevs{k},2)==1
              ev  = allevs{k}{n,1,Image};
            else
              ev  = allevs{k}{n,Divergence,Image};
            end
            NomFich = ev.NomFich;
            if strcmp(field, 'NumNeurons')
              if isfield(ev, 'NumNeurons')
                NumNeurons = ev.NumNeurons;
              elseif ~isempty(allmods{k}) && numel(size(allres{k}))==2
                if size(allres{k},1)==1 && isfield(allres{k}{1,Image}, 'NumNeurons')
                  NumNeurons = allres{k}{1,Image}.NumNeurons;
                elseif isfield(allres{k}{Divergence,Image}, 'NumNeurons')
                  %fprintf('k=%d, n=%d, Divergence=%d, Image=%d, allres size: (%s)\n', k, n, Divergence, Image, sprintf(' %d', size(allres{k})));
                  NumNeurons = allres{k}{Divergence,Image}.NumNeurons;
                else
                  NumNeurons=0;
                end
              else
                NumNeurons = 0;
              end
              values(n) = NumNeurons;
              clear NumNeurons;
            else
              values(n) = getfield(ev, field);
            end
          end
          if isempty(allmods{k})
            %fprintf('Mira: k==%d, Divergence=%d, Image=%d\n', k, Divergence, Image);
            %disp(size(allres{k}));
            compressedSizesByName{k}(end+1) = allres{k}{Image}.compressedSize/uncompressedSize;
          elseif allmods{k}==0
            numpixels_init = 512*512;
            if isfield(ev, 'NumNeurons')
              NumNeurons = ev.NumNeurons;
            elseif numel(size(allres{k}))==2
              if size(allres{k},1)==1
                NumNeurons = allres{k}{1,Image}.NumNeurons;
              else
                NumNeurons = allres{k}{Divergence,Image}.NumNeurons;
              end
            end
            %fprintf('Mira: k==%d, Divergence=%d, Image=%d\n', k, Divergence, Image);
            compressedSizesByName{k}(end+1) = (numpixels_init*(ceil(log2(NumNeurons))) + 8*3*NumNeurons)/uncompressedSize;
            %compressedSizesByName{k}(end+1) = (numpixels_init*(ceil(log2(allres{k}{Image}.NumNeurons))) + 8*3*NumNeurons)/uncompressedSize;
            clear NumNeurons;
          else
            sizeDecoder = ev.decoderParams*32;
            size_reduced = ev.encodedShape(1);
            latentDim = ev.encodedShape(end);
            numpixels_reduced = size_reduced*size_reduced;
            sizeData = numpixels_reduced*(ceil(log2(ev.NumNeurons))) + ev.encodedPrecision*latentDim*ev.NumNeurons;
            compressedSizesByName{k}(end+1) = (sizeDecoder + sizeData)/uncompressedSize;
          end
          meansbyname{k}(end+1) = mean(values);
          stdsbyname{k}(end+1)  =  std(values);
          outsbyname{k}{end+1}  = sprintf('%0.04f (%0.02f)', meansbyname{k}(end), stdsbyname{k}(end));
          if strcmp('max', fields{f,2})
            valuesbyname{k}(end+1) = mean(values); %max(values);
          else
            valuesbyname{k}(end+1) = mean(values);%min(values);
          end
          if false && strcmp(names{k},'N3-H4-GHNG')
            fprintf('Mira k=%d,Divergence=%d,Image=%d values MAX %s: %f\n', k, Divergence, Image, names{k}, valuesbyname{k}(end));
          end
          if false && strcmp(names{k},'N3-H3-GHNG')
            fprintf('Mira k=%d,Divergence=%d,Image=%d values MAX %s: %f\n', k, Divergence, Image, names{k}, valuesbyname{k}(end));
          end
          if false && strcmp(names{k},'N3-H2-GHNG')
            fprintf('Mira k=%d,Divergence=%d,Image=%d values MAX %s: %f\n', k, Divergence, Image, names{k}, valuesbyname{k}(end));
          end
          if true && strcmp(names{k},'N1-H1-GHBNG')
            fprintf('Mira k=%d,Divergence=%d,Image=%d values MEAN %s: %f\n', k, Divergence, Image, names{k}, valuesbyname{k}(end));
            disp(values);
          end
          %fprintf('Divergence=%d, Image=%d, k=%d, n=%d, isempty(modelo)=%d, use_autoenc=%d', Divergence, Image , k, n, isempty(allmods{k}), use_autoenc);
        end
      end
      for k=1:numel(allevs)
        if endsWith(names{k}, 'GHBNG')
          %fprintf(fid, 'Field %s, Divergence %s, autoencoder %s: %s\n', fields{f, 1}, Divergences{Divergence}, names{k}, sprintf(' | %s', outsbyname{k}{5:14}));
          fprintf(fid, '%s, %s, %s: %s\n', fields{f, 1}, Divergences{Divergence}, names{k}, sprintf(' | %s', outsbyname{k}{5:14}));
          fprintf(fid, '      Compression ratios: %s\n', sprintf(' | %0.02f', 1./compressedSizesByName{k}(5:14)));
        elseif Divergence==1
          %fprintf(fid, 'Field %s, autoencoder %s: %s\n', fields{f, 1}, names{k}, sprintf(' | %s', outsbyname{k}{5:14}));
          fprintf(fid, '%s, autoencoder %s: %s\n', fields{f, 1}, names{k}, sprintf(' | %s', outsbyname{k}{5:14}));
          fprintf(fid, '      Compression ratios: %s\n', sprintf(' | %0.02f', 1./compressedSizesByName{k}(5:14)));
        end
      end
      valuesbynameMean          = computeMeans(valuesbyname);
      compressedSizesByNameMean = computeMeans(compressedSizesByName);
      if MEANOFIMAGES
        valuesbyname          = valuesbynameMean;
        compressedSizesByName = compressedSizesByNameMean;
        paretoFormat          = 'k';
      else
        paretoFormat          = '-ok';
      end
      everything = cat(2, compressedSizesByName, valuesbyname, markers)';
      everything = everything(:);
      invertValues = strcmp('max', fields{f,2});
      fig=figure;
      if MEANOFIMAGES
        %paretoPoints = computePareto(compressedSizesByNameMean(1:end-also_without_autoencoder), valuesbynameMean(1:end-also_without_autoencoder), invertValues);
        paretoPoints = computePareto(compressedSizesByNameMean, valuesbynameMean, invertValues);
        %p=plot(paretoPoints(:,1), paretoPoints(:,2), 'Color', 'k', everything{:});
        hold on;
        plot(paretoPoints(:,1), paretoPoints(:,2), 'k');
        p = {};
        for n=1:numel(compressedSizesByName)
          plot(compressedSizesByName{n}, valuesbyname{n}, markers{n,:});
        end
        %plot(paretoPoints(:,1), paretoPoints(:,2), paretoFormat, ...
        %      [compressedSizesByName{1:4}],   [valuesbyname{1:4}],   '^k', ...
        %      [compressedSizesByName{5:8}],   [valuesbyname{5:8}],   '<k', ...
        %      [compressedSizesByName{9:12}],  [valuesbyname{9:12}],  '>k', ...
        %      [compressedSizesByName{13:16}], [valuesbyname{13:16}], 'vk', ...
        %      [compressedSizesByName{17:20}], [valuesbyname{17:20}], 'sk', ...
        %      [compressedSizesByName{21:24}], [valuesbyname{21:24}], '+k', ...
        %      [compressedSizesByName{25:28}], [valuesbyname{25:28}], 'dk', ...
        %      [compressedSizesByName{29:32}], [valuesbyname{29:32}], 'xk', ...
        %      [compressedSizesByName{33:33}], [valuesbyname{33:33}], 'ok', ...
        %      'MarkerFaceColor', 'k');
        markerjpge2000 = 'm';
      else
        p=plot(everything{:});
        markerjpge2000 = '.m';
      end
      if alsojpeg2000
        hold on;
        p2 = plot(e2000_compression(:), e2000_values(:), markerjpge2000);
      end
      if MEANOFIMAGES
        %t=text([compressedSizesByName{:}], [valuesbynameMean{:}], names);
        %set(t,'Rotation',-45);
        subname='each point is the mean across all images';
      else
        subname='each point is the best result for an image';
      end
      title(sprintf('%s (%s) %s', field, subname, Divergences{Divergence}));
      %title(sprintf('%s', field));
      %legend({'', ' N1', ' N2', ' N3', ' N4', ' N1*', ' N2*', ' N3*', ' N4*', 'no autoencoder'});
      legend(linenames, 'NumColumns', 2);
      xlabel('compressed size');
      ylabel(field);
      if ~isempty(fields{f,3})
        xlim(fields{f,3});
      end
      if ~isempty(fields{f,4})
        ylim(fields{f,4});
      end
      if false;
        magnifyOnFigure(...
          fig,...
          'units', 'pixels',...
          'initialPositionSecondaryAxes', [326.933 259.189 164.941 102.65],...
          'initialPositionMagnifier',     [0 0 20 20],...    
          'mode', 'interactive',...    
          'displayLinkStyle', 'straight',...        
          'edgeWidth', 2,...
          'edgeColor', 'black',...
          'secondaryAxesFaceColor', [0.91 0.91 0.91]... 
              ); 
      end
      if dosave
        if MEANOFIMAGES
          subname = 'MEAN';
        else
          subname = 'ALLIMAGESANDDIVERGENCES';
        end
        saveas(gcf,[RutasImagenes{1} sprintf('ojalaPareto.%s.%s.Divergence%d.fig', subname, field, Divergence)], 'fig');
        close all;
      end
    end
  end

  fclose(fid);

end





function allxs = loadRutas(RutasImagenes, subdir, filename, valname)
  xs=cell(size(RutasImagenes));
  for x=1:numel(RutasImagenes)
    xs{x}  = load([RutasImagenes{x} subdir filename], valname);
    xs{x} = getfield(xs{x}, valname);
  end
  allxs = cat(numel(size(xs{1})), xs{:});

function allxs = loadModelos(RutasImagenes, subdir, numImages, num_divergences)
  xs=cell(size(RutasImagenes));
  for x=1:numel(RutasImagenes)
    xs{x}  = load([RutasImagenes{x} subdir 'ModelosCuantificacionDivergenciasBregman.mat'], 'Modelos');
    if isfield(xs{x}, 'Modelos')
      xs{x} = getfield(xs{x}, 'Modelos');
    else
      xs{x} = cell(num_divergences, numImages);
      for a=1:num_divergences
        for b=1:numImages
          xs{x}{a,b} = load([RutasImagenes{x} subdir sprintf('MejorModelo.Divergence%d.Image%02d', a, b) '.mat'], 'MejorModelo');
          xs{x}{a,b} = getfield(xs{x}, 'MejorModelo');
        end
      end
    end
  end
  allxs = cat(numel(size(xs{1})), xs{:});

function newcellvalues = computeMeans(cellvalues)
  newcellvalues = cell(size(cellvalues));
  for k=1:numel(newcellvalues)
    newcellvalues{k} = mean(cellvalues{k});
  end

function points = computePareto(compressedSizesByName, valuesbyname, invertValues)

matr = zeros(numel(compressedSizesByName)*numel(compressedSizesByName{1}), 2);
k=1;
for a=1:numel(compressedSizesByName)
  for b=1:numel(compressedSizesByName{a})
    matr(k,1) = compressedSizesByName{a}(b);
    matr(k,2) = valuesbyname{a}(b);
    k=k+1;
  end
end
if invertValues
  matr(:,2) = -matr(:,2);
end
front = paretofront(matr);
points = matr(front,:);
if invertValues
  points(:,2) = -points(:,2);
end
points = sortrows(points, 1);

function markers = markerBlock(m1, m2, m3, m4, c1, c2, c3, c4)
  markers = {...
  'Marker', m1, 'Color', c1, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  'Marker', m1, 'Color', c2, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  'Marker', m1, 'Color', c3, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  'Marker', m1, 'Color', c4, 'MarkerFaceColor', c4, 'Linestyle', 'none';
  'Marker', m2, 'Color', c1, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  'Marker', m2, 'Color', c2, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  'Marker', m2, 'Color', c3, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  'Marker', m2, 'Color', c4, 'MarkerFaceColor', c4, 'Linestyle', 'none';
  'Marker', m3, 'Color', c1, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  'Marker', m3, 'Color', c2, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  'Marker', m3, 'Color', c3, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  'Marker', m3, 'Color', c4, 'MarkerFaceColor', c4, 'Linestyle', 'none';
  'Marker', m4, 'Color', c1, 'MarkerFaceColor', c1, 'Linestyle', 'none';
  'Marker', m4, 'Color', c2, 'MarkerFaceColor', c2, 'Linestyle', 'none';
  'Marker', m4, 'Color', c3, 'MarkerFaceColor', c3, 'Linestyle', 'none';
  'Marker', m4, 'Color', c4, 'MarkerFaceColor', c4, 'Linestyle', 'none'};

