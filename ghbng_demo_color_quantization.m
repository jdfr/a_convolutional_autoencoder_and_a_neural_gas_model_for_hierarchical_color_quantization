% GHBNG demo for color quantization with the 'Lena' image

clear all
NumSamples=10000;
MaxNeurons = 50; % Maximum number of neurons in each graph
Tau = 0.1;
Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda=100;
Epochs=2;
EpsilonB=0.2;
EpsilonN=0.006;
Alpha=0.5;
AMax=50;
D=0.995;

% Generate data ('baboon' image)
ImgOriginal = imread('lena.tiff');
ImgOriginal = double(ImgOriginal)/255;
Samples = reshape(shiftdim(ImgOriginal,2),3,[]);

Handle=zeros(1,numel(Divergences));
for NdxDivergence=1:length(Divergences)
    
    fprintf('\nBREGMAN DIVERGENCE: %s\n',Divergences{NdxDivergence});
    
    % GHBNG Training
    [Model] = TrainGHBNG(Samples,Epochs,Divergences{NdxDivergence},MaxNeurons,Tau,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,1);

    % Plot the difference image amplified 20 times
    Centroids = GetCentroidsGHBNG(Model);
    Winners = TestGHBNG(Centroids,Model.Samples,Divergences{NdxDivergence});
    ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
    ImgDif = abs(ImgOriginal-ImgProt)*20;
    figure, imshow(ImgDif);
    title(Divergences{NdxDivergence});
end
