function PruebasCuantificacionExternalAutoencoder

%CLASICO      -> Evaluaciones NUM_EXPERIMENTOS x NUM_DIVERGENCIAS x NUM_FOTOS
%                Resultados   NUM_DIVERGENCIAS x NUM_FOTOS
%AUTOENCODER  -> Evaluaciones NUM_EXPERIMENTOS x NUM_FOTOS%
%                Resultados   NUM_FOTOS

%H2
%N1 N2 N3
%D0 D1
%P8 P16
%1*3*2*2 => 6 ó 12
%
%H3
%N2
%D0
%P8 P16
%1*1*1*2

pathTemplates  = 'all/';
pathResultados = '';
pathSave       = 'conv/'

filenames = {'Baboon.tiff', 'House.tiff', 'Lake.tiff', 'Lena.tiff', 'bike.png', 'bird.png', 'building.png', 'chicks.png', 'mall.png', 'night.png', 'picturesque.png', 'snow.png', 'street.png', 'woman.png'};
names = cell(size(filenames));
for k=1:numel(names)
  ind = strfind(filenames{k},'.');
  names{k} = filenames{k}(1:ind-1);

end

%combinaciones [H N D P; ...
combinaciones  = [
1 1 0  8;
1 2 0  8;
1 3 0  8;
1 4 0  8;
2 1 0  8;
2 2 0  8;
2 3 0  8;
2 4 0  8;
3 1 0  8;
3 2 0  8;
3 3 0  8;
3 4 0  8;
4 1 0  8;
4 2 0  8;
4 3 0  8;
4 4 0  8;




%2 1 0  16;
%2 2 0  16;
%2 3 0  16;
%3 1 0  16;
%3 2 0  16;
%3 3 0  16;

%3 2 0  8;
%2 1 0  8;
%2 1 1  8;
%2 2 0  8;
%2 2 1  8;
%2 3 0  8;
%2 3 1  8;
%3 2 0 16;
%2 1 0 16;
%2 1 1 16;
%2 2 0 16;
%2 2 1 16;
%2 3 0 16;
%2 3 1 16;
];

numTrainings = 10;

for k=1:size(combinaciones,1)
  Evaluaciones = cell(numTrainings, numel(names));
  Resultados = cell(numel(names));
  H = combinaciones(k,1);
  N = combinaciones(k,2);
  D = combinaciones(k,3);
  P = combinaciones(k,4);
  subcode = sprintf('R3_H%d_N%d_D%d_P%d_E20000', H, N, D, P);
  fprintf('Evaluando %s\n', subcode);
  for i=1:numel(names)
    ImagenOriginal = imread([pathTemplates filenames{i}]);
    fprintf('  Evaluando %s\n', names{i});
    for e=1:numTrainings
      subpath = sprintf('convP%dH%d/%s_convautoenc_%s_%02d', P, H, names{i}, subcode, e);
      ImagenResultado = imread([pathResultados subpath '.png']);
      Evaluaciones{e,i} = evaluarCompresionImagen(ImagenOriginal,ImagenResultado);
      Evaluaciones{e,i}.NomFich = names{i};
    end
    Resultados{i} = ValidacionCruzadaCompresion(Evaluaciones(:,i)');
    Resultados{i}.NomFich = names{i};
    Resultados{i}.justAutoEncoder = true;
    %encodedSide = 512/(2^N);
    %encodedDims = 3+H*N;
    %encodedSize = encodedSide*encodedSide*encodedDims*P;
    z = load([pathResultados subpath '.mat']);
    Resultados{i}.encodedSize = prod(size(z.autoenc.encoded))*P;
    decoderSizes      = zeros(size(z.autoenc.decoder_params));
    for s=1:numel(decoderSizes)
      decoderSizes(s) = prod(size(z.autoenc.decoder_params{s}));
    end
    Resultados{i}.decoderSize    = sum(decoderSizes)*32;
    Resultados{i}.compressedSize = Resultados{i}.encodedSize + Resultados{i}.decoderSize;
    save([pathSave sprintf('Evaluaciones_convautoenc_%s', subcode) '.mat'],'Evaluaciones');
    save([pathSave sprintf(  'Resultados_convautoenc_%s', subcode) '.mat'],'Resultados');
  end
end

