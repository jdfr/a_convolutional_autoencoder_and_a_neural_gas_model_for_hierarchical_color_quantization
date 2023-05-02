function seeResults;

RutaImagenes = 'onlybaboonhouselakelena_autoencoder/';

combinaciones = [8 25; 8 50; 8 75; 8 100; 4 20; 4 15; 4 10; 4 5; 2 3; 2 6];
allevs = cell(size(combinaciones,1)+1,1);
names = cell(size(combinaciones,1)+1,1);
for k=1:size(combinaciones,1)
  foldingNumber = combinaciones(k,1);
  hiddenLayer   = combinaciones(k,2);
  subdir=sprintf('_autoencoder_%dx%dx3to%d/', foldingNumber, foldingNumber, hiddenLayer);
  names{k}=sprintf('%dx%dx3to%d', foldingNumber, foldingNumber, hiddenLayer);
  allevs{k} = load([RutaImagenes subdir 'EvaluacionesCuantificacionDivergenciasBregman.mat'], 'Evaluaciones');
end
names{end} = 'without autoencoder';
allevs{end} = load([RutaImagenes 'GHBNC_standalone/' 'EvaluacionesCuantificacionDivergenciasBregman.mat'], 'Evaluaciones');

fields = {'SSIM'};%{'MSE', 'PSNR', 'SSIM'};

for ik=1:4
  for f=1:numel(fields)
    Divergence = 1; %1 to 5
    Image = ik; %1 to 4
    field = fields{f};
    valuesbyname = cell(size(names));
    for k=1:numel(allevs)
      evs = allevs{k}.Evaluaciones;
      values = zeros(size(evs, 1), 1);
      for n=1:numel(values)
        ev = evs{n,Divergence,Image};
        NomFich = ev.NomFich;
        values(n) = getfield(ev, field);
      end
      valuesbyname{k} = values;
    end
    allvalues = cat(2, valuesbyname{:});
    figure;
    boxplot(allvalues, 'Labels', names);
    title(sprintf('GHBNG with AutoEncoder, divergence %d, image %s (%d): %s', Divergence, NomFich, Image, field));
  end
end
