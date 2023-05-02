function showPareto(combinaciones, names, allevs, allmods);

RutaImagenes = 'onlybaboonhouselakelena_autoencoder/';

if false

combinaciones = [8 25 1; 8 50 1; 8 75 1; 8 100 1; 4 20 1; 4 15 1; 4 10 1; 4 5 1; 2 3 1; 2 6 1];
combinaciones_initial = combinaciones;
allevs  = cell(size(combinaciones,1)+1,1);
allmods = cell(size(combinaciones,1)+1,1);
names   = cell(size(combinaciones,1)+1,1);
for k=1:size(combinaciones,1)
  foldingNumber = combinaciones(k,1);
  hiddenLayer   = combinaciones(k,2);
  subdir        = sprintf('_autoencoder_%dx%dx3to%d/', foldingNumber, foldingNumber, hiddenLayer);
  names{k}      = sprintf('with autoencoder %dx%dx3to%d', foldingNumber, foldingNumber, hiddenLayer);
  fprintf('Loading for %s\n', names{k});
  allevs{k}     = load([RutaImagenes subdir 'EvaluacionesCuantificacionDivergenciasBregman.mat'], 'Evaluaciones');
  allmods{k}    = load([RutaImagenes subdir 'ModelosCuantificacionDivergenciasBregman.mat'], 'Modelos');
end
names{end}   = 'without autoencoder';
allevs{end}  = load([RutaImagenes 'GHBNC_standalone/' 'EvaluacionesCuantificacionDivergenciasBregman.mat'], 'Evaluaciones');
allmods{end} = load([RutaImagenes 'GHBNC_standalone/' 'ModelosCuantificacionDivergenciasBregman.mat'], 'Modelos');
combinaciones = [combinaciones; [-100 -100 0]; combinaciones];
for k=1:size(combinaciones_initial,1)
  foldingNumber = combinaciones_initial(k,1);
  hiddenLayer   = combinaciones_initial(k,2);
  subdir        = sprintf('_autoencoder_%dx%dx3to%d/', foldingNumber, foldingNumber, hiddenLayer);
  names{end+1}      = sprintf('just autoencoder %dx%dx3to%d', foldingNumber, foldingNumber, hiddenLayer);
  fprintf('Loading for %s\n', names{k});
  allevs{end+1}     = load([RutaImagenes subdir sprintf('AutoencodersFolding%dLatentDim%03d.Evaluaciones.mat', foldingNumber, hiddenLayer)], 'Evaluaciones');
  allmods{end+1}    = [];
end
end

close all;

Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};

fields = {'SSIM', 'max'; 'PSNR', 'max'; 'MSE', 'min'; 'NCC', 'max'};%{'MSE', 'PSNR', 'SSIM'};

markers = {'.b', 'ob', '+b', 'xb', '^b', 'vb', '<b', '>b', 'pb', 'hb', '.r', '.g', 'og', '+g', 'xg', '^g', 'vg', '<g', '>g', 'pg', 'hg'}';
for Divergence = 1:5
for ik=1:4
  for f=1:size(fields,1)
    Image = ik; %1 to 4
    field = fields{f,1};
    valuesbyname = cell(size(names));
    compressedSizesByName = cell(size(names));
    for k=1:numel(allevs)
      evs = allevs{k}.Evaluaciones;
      values = zeros(size(evs, 1), 1);
      for n=1:numel(values)
        if isempty(allmods{k})
          ev = evs{n,Image};
        else
          ev = evs{n,Divergence,Image};
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
        modelo = allmods{k}.Modelos{Divergence,Image};
      end
      if strcmp('max', fields{f,2})
        valuesbyname{k} = max(values);
      else
        valuesbyname{k} = min(values);
      end
      compressedSizesByName{k} = computeSize(modelo, [512 512], use_autoenc, folding, latentsize);
    end
    everything = cat(2, compressedSizesByName, valuesbyname, markers)';
    everything = everything(:);
    figure;
    plot(everything{:});
    legend(names);
    title(sprintf('divergence %s, image %s: %s', Divergences{Divergence}, NomFich, field));
    xlabel('compressed size');
    ylabel(field);
    saveas(gcf,[RutaImagenes sprintf('ojalaPareto.%s.Image%d.Divergence%d.fig', field, Image, Divergence)], 'fig');
    close all;
  end
end
end
