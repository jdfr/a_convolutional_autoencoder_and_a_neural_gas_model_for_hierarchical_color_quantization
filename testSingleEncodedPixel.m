function testSingleEncodedPixel(coord1, coord2, RutaSalvar, grayEncodedPath, basenameForDecoder)

%testSingleEncodedPixel(3,3,'tests/', 'tests/Baboon_convautoenc_R3_H1_N4_D0_P8_E20000_best_gray.mat', 'convP8H1/Baboon_convautoenc_R3_H1_N4_D0_P8_E20000_best')

grayautoenc = load(grayEncodedPath).autoenc;
encodedOrigGray = double(grayautoenc.encoded);

autoenc = load([basenameForDecoder '.mat']).autoenc;
encodedOrig = double(autoenc.encoded);
Muestras = reshape(shiftdim(encodedOrig,2),size(encodedOrig,3),[]);

NumEpocas = 2;
Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};
MaxNeurons = 50; % Maximum number of neurons in each graph
TauGHBNG = 0.1;
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

MyDivergence=Divergences{1};

[Modelo] = TrainGHBNG(Muestras,NumEpocas,MyDivergence,MaxNeurons,TauGHBNG,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,1);

%[Handle] = PlotGHBNGConcepts(Modelo,'hola');

Centroids = GetCentroidsGHBNG(Modelo);
NumNeurons         = size(Centroids,2);
Winners = TestGHBNG(Centroids,Modelo.Samples,MyDivergence);
Modelo.Winners = Winners;

encodedFromOrigImg = GetPrototypesImg(Centroids,Winners,size(encodedOrig));

position = round(size(encodedFromOrigImg,1)/2);
encodedOrigGray(position, position, :) = encodedFromOrigImg(coord1, coord2,:);
%encoded = encodedFromOrigImg;
encoded = encodedOrigGray;

rnd = round(rand*1000000);
encodedpath = [RutaSalvar sprintf('tmp%d.mat', rnd)];
encodedimgpath = [RutaSalvar sprintf('tmp%d.png', rnd)];
save(encodedpath, 'encoded');
command = sprintf('conda run condaconvenv python pruebaconv1.py --decode --matpath %s --weightpath %s --encodedpath %s --resultpath %s', [basenameForDecoder '.mat'], [basenameForDecoder '.pt'], encodedpath, encodedimgpath);
system(command, '-echo');
ImgProt = imread(encodedimgpath);
delete(encodedpath);
delete(encodedimgpath);

thispatch = ImgProt(240-16:240+16,240-16:240+16);

%for JAJALINA in 1 2 3 4; do python pruebaconv1.py --encode --matpath "convP8H1/Baboon_convautoenc_R3_H1_N${JAJALINA}_D0_P8_E20000_best.mat" --weightpath "convP8H1/Baboon_convautoenc_R3_H1_N${JAJALINA}_D0_P8_E20000_best.pt" --imgpath all/gray.png --basename "tests/Baboon_convautoenc_R3_H1_N${JAJALINA}_D0_P8_E20000_best_gray" --device "cuda:0"; done


