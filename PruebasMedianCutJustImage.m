function PruebasMedianCutJustImage(imgExt, RutaImagenes, modo);

if false
  PruebasMedianCutJustImage('png', '4k/');
end

d = dir([RutaImagenes '*.' imgExt]);

NumEntrenamientos = 10;

depths = [12, 13, 14];

modos = [0, 1];

Evaluaciones = cell(NumEntrenamientos,numel(depths),length(d));

randomized = true;

subdir='medianCut_standalone/';
RutaSalvar = [RutaImagenes subdir];
mkdir(RutaSalvar);
NomFichEvaluaciones = sprintf('EvaluacionesMedianCut_modo%d', modo);


for NdxDataset=1:length(d)
    fprintf('Dentro...\n')
    % Generate data from image
    ImgOriginal = imread([RutaImagenes d(NdxDataset).name]);
    %ImgDoubleNormalizada = double(ImgOriginal)/255;
    ind = strfind(d(NdxDataset).name,'.');
    NomFich = d(NdxDataset).name(1:ind-1);
    for depth=1:numel(depths)
      for NdxRepeticion=1:NumEntrenamientos
          fprintf('repeticion=%d, modo=%d, depth=%d, imagen=%d\n', NdxRepeticion, modo, depth, NdxDataset);
          timer = tic;
          [ImgProt, isRandomized] = medianCut(ImgOriginal, modo, randomized, depths(depth));
          Evaluaciones{NdxRepeticion, depth, NdxDataset} = evaluarCompresionImagen(ImgOriginal,ImgProt);
          Evaluaciones{NdxRepeticion, depth, NdxDataset}.TiempoEntrenamiento = toc(timer);
          Evaluaciones{NdxRepeticion, depth, NdxDataset}.NomFich = NomFich;
          Evaluaciones{NdxRepeticion, depth, NdxDataset}.NumNeurons = 2^depths(depth);
          Evaluaciones{NdxRepeticion, depth, NdxDataset}.Deterministic = false;
          namefile_img = [RutaSalvar sprintf('justMedianCut.modo%d.depth%d.Imagen%d.Rep%d', modo, depth, NdxDataset, NdxRepeticion) '.png'];
          imwrite(ImgProt, namefile_img);
          if NdxRepeticion==1 && ~isRandomized
              Evaluaciones{NdxRepeticion, modo, depth, NdxDataset}.Deterministic = true;
              fprintf('        Deterministic median cut: skipping the other trainings\n');
              for rep=2:NumEntrenamientos
                namefile_img = [RutaSalvar sprintf('justMedianCut.modo%d.depth%d.Imagen%d.Rep%d', modo, depth, NdxDataset, rep) '.png'];
                imwrite(ImgProt, namefile_img);
              end
              Evaluaciones(2:end, depth, NdxDataset) = Evaluaciones(1, modo, depth, NdxDataset);
              break;
          end
      end
    end
end

namefile = [RutaSalvar NomFichEvaluaciones '.mat'];
save(namefile,'Evaluaciones');


