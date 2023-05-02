%%SHOW PARETO PLOT FOR MATLAB AUTOENCODERS

function showPareto2(MEANOFIMAGES, combinaciones, markers, names, allevs, allmods, numImages);
%function [combinaciones, markers, names, allevs, allmods, numImages] = showPareto2;
%function showPareto2(MEANOFIMAGES);

RutasImagenes = {'onlybaboonhouselakelena_autoencoder/', '4k/'};

also_without_autoencoder = true;

num_divergences = 5;

reunir_datos               = false;
figuras_pareto_desglosadas = (~reunir_datos) && false;
figuras_resumidas          = (~reunir_datos) && false;

if reunir_datos

  combinaciones = [8 25 1; 8 50 1; 8 75 1; 8 100 1; 4 20 1; 4 15 1; 4 10 1; 4 5 1; 2 3 1; 2 4 1; 2 5 1; 2 6 1; 2 9 1];
  markers = {'.b', 'ob', '+b', 'xb', '^b', 'vb', '<b', '>b', 'pb', 'hb', 'sb', 'db', '|b', '.g', 'og', '+g', 'xg', '^g', 'vg', '<g', '>g', 'pg', 'hg', 'sg', 'dg', '|g'}';
  if also_without_autoencoder
    markers{end+1} = '.r';
  end
  combinaciones_initial = combinaciones;
  nc = size(combinaciones,1);
  combinaciones = [combinaciones; combinaciones; [-100 -100 0]];
  allevs  = cell(nc*2+also_without_autoencoder,1);
  allmods = cell(nc*2+also_without_autoencoder,1);
  names   = cell(nc*2+also_without_autoencoder,1);
  for k=1:nc
    foldingNumber = combinaciones_initial(k,1);
    hiddenLayer   = combinaciones_initial(k,2);
    subdir        = sprintf('_autoencoder_%dx%dx3to%d/', foldingNumber, foldingNumber, hiddenLayer);
    names{k}      = sprintf('with autoencoder %dx%dx3to%d', foldingNumber, foldingNumber, hiddenLayer);
    fprintf('Loading for %s\n', names{k});
    allevs{k}  = loadRutas(RutasImagenes, subdir, 'EvaluacionesCuantificacionDivergenciasBregman.mat', 'Evaluaciones');
    numImages  = size(allevs{k}, 3);
    allmods{k} = loadModelos(RutasImagenes, subdir, num_divergences);
  end
  for k=1:nc
    foldingNumber = combinaciones_initial(k,1);
    hiddenLayer   = combinaciones_initial(k,2);
    subdir        = sprintf('_autoencoder_%dx%dx3to%d/', foldingNumber, foldingNumber, hiddenLayer);
    names{nc+k}      = sprintf('just autoencoder %dx%dx3to%d', foldingNumber, foldingNumber, hiddenLayer);
    fprintf('Loading for %s\n', names{k});
    allevs{nc+k}     = loadRutas(RutasImagenes, subdir, sprintf('AutoencodersFolding%dLatentDim%03d.Evaluaciones.mat', foldingNumber, hiddenLayer), 'Evaluaciones');
    allmods{nc+k}    = [];
  end
  if also_without_autoencoder
    names{nc*2+1}   = 'without autoencoder';
    allevs{nc*2+1}  = loadRutas(RutasImagenes, 'GHBNC_standalone/', 'EvaluacionesCuantificacionDivergenciasBregman.mat', 'Evaluaciones');
    allmods{nc*2+1} = loadModelos(RutasImagenes, 'GHBNC_standalone/', num_divergences);
  end
end


%%%% A FIGURE FOR EACH MEASURExDIVERGENCE
if figuras_pareto_desglosadas

  close all;

  Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};

  fields = {'SSIM', 'max'; 'PSNR', 'max'; 'MSE', 'min'; 'NCC', 'max'};%{'MSE', 'PSNR', 'SSIM'};

  imagenames = cell(size(allevs{1}, 3),1);
  for Image=1:numel(imagenames)
    imagenames{Image} = allevs{1}{1,1,Image}.NomFich;
  end
  if MEANOFIMAGES
    paretoname = 'pareto front';
  else
    paretoname = 'pareto front for mean values across all images';
  end
  linenames = [{paretoname}; names];

  for Divergence = 1:num_divergences
    for f=1:size(fields,1)
      field = fields{f,1};
      valuesbyname = cell(size(names));
      compressedSizesByName = cell(size(names));
      for Image=1:numel(imagenames)
        for k=1:numel(allevs)
          values = zeros(size(allevs{k}, 1), 1);
          for n=1:numel(values)
            if isempty(allmods{k}) || numel(size(allevs))<3
              ev = allevs{k}{n,Image};
            else
              ev = allevs{k}{n,Divergence,Image};
            end
            NomFich = ev.NomFich;
            values(n) = getfield(ev, field);
          end
          folding = combinaciones(k,1);
          latentsize = combinaciones(k,2);
          use_autoenc = combinaciones(k,3);
          if isempty(allmods{k})
            modelo = [];
          else
            modelo = allmods{k}{Divergence,Image};
          end
          if strcmp('max', fields{f,2})
            valuesbyname{k}(end+1) = max(values);
          else
            valuesbyname{k}(end+1) = min(values);
          end
          compressedSizesByName{k}(end+1) = computeSize(modelo, [512 512], use_autoenc, folding, latentsize);
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
      paretoPoints = computePareto(compressedSizesByNameMean(1:end-also_without_autoencoder), valuesbynameMean(1:end-also_without_autoencoder), invertValues);
      figure;
      p=plot(paretoPoints(:,1), paretoPoints(:,2), paretoFormat, everything{:});
      if MEANOFIMAGES
        subname='each point is the mean across all images';
      else
        subname='each point is the best result for an image';
        for x=2:numel(p)
          p(x).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Image",imagenames);
        end
      end
      title(sprintf('divergence %s: %s (%s)', Divergences{Divergence}, field, subname));
      legend(linenames);
      xlabel('compressed size');
      ylabel(field);
      if true
        if MEANOFIMAGES
          subname = 'MEAN';
        else
          subname = 'ALLIMAGES';
        end
        saveas(gcf,[RutasImagenes{1} sprintf('ojalaPareto.%s.%s.Divergence%d.fig', subname, field, Divergence)], 'fig');
        close all;
      end
    end
  end

end



%%%%%%%%%%%%% A FIGURE FOR EACH MEASURE
if figuras_resumidas

  close all;

  Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};

  fields = {'SSIM', 'max'; 'PSNR', 'max'; 'MSE', 'min'; 'NCC', 'max'};%{'MSE', 'PSNR', 'SSIM'};

  imagenames = cell(size(allevs{1}, 3),1);
  for Image=1:numel(imagenames)
    imagenames{Image} = allevs{1}{1,1,Image}.NomFich;
  end
  imagenamess = repmat(imagenames, 5, 1);
  divergencess=repmat(Divergences, numel(imagenames), 1); divergencess=divergencess(:);
  if MEANOFIMAGES
    paretoname = 'pareto front';
  else
    paretoname = 'pareto front for mean values across all images';
  end
  %linenames = [{paretoname}; names];
  linenames = names;

  for f=1:size(fields,1)
    field = fields{f,1};
    valuesbyname = cell(size(names));
    compressedSizesByName = cell(size(names));
    for Divergence = 1:5
      for Image=1:numel(imagenames)
        for k=1:numel(allevs)
          values = zeros(size(allevs{k}, 1), 1);
          for n=1:numel(values)
            if isempty(allmods{k}) || numel(size(allevs))<3
              ev = allevs{k}{n,Image};
            else
              ev = allevs{k}{n,Divergence,Image};
            end
            NomFich = ev.NomFich;
            values(n) = getfield(ev, field);
          end
          folding = combinaciones(k,1);
          latentsize = combinaciones(k,2);
          use_autoenc = combinaciones(k,3);
          if isempty(allmods{k})
            modelo = [];
          else
            modelo = allmods{k}{Divergence,Image};
          end
          if strcmp('max', fields{f,2})
            valuesbyname{k}(end+1) = max(values);
          else
            valuesbyname{k}(end+1) = min(values);
          end
          %fprintf('Divergence=%d, Image=%d, k=%d, n=%d, isempty(modelo)=%d, use_autoenc=%d', Divergence, Image , k, n, isempty(modelo), use_autoenc);
          compressedSizesByName{k}(end+1) = computeSize(modelo, [512 512], use_autoenc, folding, latentsize);
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
    end
    everything = cat(2, compressedSizesByName, valuesbyname, markers)';
    everything = everything(:);
    invertValues = strcmp('max', fields{f,2});
    %paretoPoints = computePareto(compressedSizesByNameMean(1:end-also_without_autoencoder), valuesbynameMean(1:end-also_without_autoencoder), invertValues);
    figure;
    %p=plot(paretoPoints(:,1), paretoPoints(:,2), paretoFormat, everything{:});
    p=plot(everything{:});
    if MEANOFIMAGES
      subname='each point is the mean across all images';
    else
      subname='each point is the best result for an image';
      %for x=2:numel(p)
      for x=1:numel(p)
        p(x).DataTipTemplate.DataTipRows([end+1;end+2]) = [dataTipTextRow("Image",imagenamess);dataTipTextRow("Divergence",divergencess)];
      end
    end
    title(sprintf('%s (%s)', field, subname));
    legend(linenames);
    xlabel('compressed size');
    ylabel(field);
    if true
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




function allxs = loadRutas(RutasImagenes, subdir, filename, valname)
  xs=cell(size(RutasImagenes));
  for x=1:numel(RutasImagenes)
    xs{x}  = load([RutasImagenes{x} subdir filename], valname);
    xs{x} = getfield(xs{x}, valname);
  end
  allxs = cat(numel(size(xs{1})), xs{:});

function allxs = loadModelos(RutasImagenes, subdir, num_divergences)
  xs=cell(size(RutasImagenes));
  for x=1:numel(RutasImagenes)
    xs{x}  = load([RutasImagenes{x} subdir 'ModelosCuantificacionDivergenciasBregman.mat'], 'Modelos');
    if isfield(xs{x}, 'Modelos')
      xs{x} = getfield(xs{x}, 'Modelos');
    else
      evs = load([RutasImagenes{x} subdir 'EvaluacionesCuantificacionDivergenciasBregman.mat'], 'Evaluaciones');
      evs = getfield(evs, 'Evaluaciones');
      numImages = size(evs, 3);
      xs{x} = cell(num_divergences, numImages);
      for a=1:num_divergences
        for b=1:numImages
          xs{x}{a,b} = load([RutasImagenes{x} subdir sprintf('MejorModelo.Divergence%d.Image%02d', a, b) '.mat'], 'MejorModelo');
          xs{x}{a,b} = getfield(xs{x}{a,b}, 'MejorModelo');
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




function compressedSizeBits = computeSize(Modelo, size_init, use_autoencoder, folding, latentsize)

use_algorithm     = ~isempty(Modelo);

realToBits        = 16;

size_reduced      = size_init/folding;

numpixels_init    = size_init(1)   *size_init(2);
numpixels_reduced = size_reduced(1)*size_reduced(2);

numel_DecoderWeights   = latentsize*folding*folding*3;
numel_DecoderBiases    = folding*folding*3;

if use_autoencoder
  compressedSizeBits   = realToBits*(numel_DecoderWeights+numel_DecoderBiases);
  if use_algorithm
    Centroids          = GetCentroidsGHBNG(Modelo);
    NumNeurons         = size(Centroids,2);
    compressedSizeBits = compressedSizeBits + numpixels_reduced*(ceil(log2(NumNeurons))) + realToBits*latentsize*NumNeurons;
    fprintf('Use autoencoder and algorithm!: folding %d, latentsize %d, NumNeurons %d, weights %g + pixels %g + latents %g = %g\n', folding, latentsize, NumNeurons, realToBits*(numel_DecoderWeights+numel_DecoderBiases), numpixels_reduced*(ceil(log2(NumNeurons))), realToBits*latentsize*NumNeurons, compressedSizeBits);
  else
    compressedSizeBits = compressedSizeBits + realToBits*latentsize*numpixels_reduced;
    fprintf('Use just autoencoder!: folding %d, latentsize %d, weights %g + latents %g = %g\n', folding, latentsize, realToBits*(numel_DecoderWeights+numel_DecoderBiases), realToBits*latentsize*numpixels_reduced, compressedSizeBits);
  end
else
  if use_algorithm
    Centroids          = GetCentroidsGHBNG(Modelo);
    NumNeurons         = size(Centroids,2);
    compressedSizeBits = numpixels_init*(ceil(log2(NumNeurons))) + 8*3*NumNeurons;
    fprintf('Use just algorithm!: NumNeurons %d, pixels %g + colors %g = %g\n', NumNeurons, numpixels_init*(ceil(log2(NumNeurons))), 8*3*NumNeurons, compressedSizeBits);
  end
end



