% Pruebas Clustering GNF de la BBDD MNIST para dígitos pares, impares o
% todos SIN PCA
clear all
fprintf('\nClustering Dígitos MNIST SIN PCA\n');

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

Par = 1; % 0 Impar / 1 Par / 2 Todos
NumEpocas = 2;
MaxNeurons = 20; % Maximum number of neurons in each graph
NumRepeticiones = 10;
NomFich = 'MNISTTrain';
load(['../../' NomFich '.mat'],'images');
TodasMuestras = images;
[NumCarac,NumMuestras] = size(TodasMuestras);
NumPasos = NumEpocas*NumMuestras;
NumRowsImg = sqrt(NumCarac);
NumColsImg = NumRowsImg;
ImageSize=0.028;

% Escogemos ciertos dígitos
load(['../../' NomFich 'Labels.mat'],'labels');
labels = labels';
if Par==1,
    fprintf('\nPAR\n');
    NdxDigitosValidos = (0:2:8);
elseif Par==0,
    fprintf('\nIMPAR\n');
    NdxDigitosValidos = (1:2:9);
else
    fprintf('\nTODOS\n');
    NdxDigitosValidos = (0:9);
end
NdxDigitos = [];
for NdxDig=NdxDigitosValidos,    
    NdxDigitos = [NdxDigitos find(labels==NdxDig)];
end
Muestras = TodasMuestras(:,NdxDigitos);
[NumCarac, NumMuestras] = size(Muestras);

% % Realizamos un PCA global
% Dimension = 15;
% MediaGlobal = mean(Muestras')';
% CovGlobal = cov(Muestras');
% [Uq, Lambdaq] = eigs(CovGlobal,Dimension,'LM');
% Lambdaq = diag(Lambdaq);
% Muestras_zq = Uq'*(Muestras-repmat(MediaGlobal,1,size(Muestras,2)));
% Muestras = Muestras_zq;

NomFichSalida = ['Modelos_GNF_' NomFich];
if exist(['./' NomFichSalida '.mat'],'file') == 0,
    Modelos = cell(1,NumRepeticiones);
else
    load(NomFichSalida);
end
MSE = zeros(1,NumRepeticiones);
PSNR = zeros(1,NumRepeticiones);
DB = zeros(1,NumRepeticiones);
CS = zeros(1,NumRepeticiones);
Time = zeros(1,NumRepeticiones);
MinMSE = Inf;
for NdxRepeticion=1:NumRepeticiones,                 
            
    if isempty(Modelos{NdxRepeticion}),
        fprintf('\nENTRENAMIENTO GNF\n');
        fprintf('------------------------------------\n');            
        tic;
        [Modelo] = TrainGNF(Muestras,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
        Time(NdxRepeticion) = toc;
        if isempty(Modelo),
            continue;
        end
        Modelos{NdxRepeticion} = Modelo;        
%         save([NomFichSalida '.mat'],'Modelos');
    else
        fprintf('\nModelo GNF Entrenado\n');        
        Modelo = Modelos{NdxRepeticion};
    end

    % Calculamos el MSE, PSNR y los Coeficientes de Silueta
    [Winners,Errors] = TestGNG(Modelo,Muestras);
%     MSE(NdxRepeticion) = mean(Errors);
%     MAX_I = (max(max(Muestras)) - min(min(Muestras)))^2;
%     PSNR(NdxRepeticion) = 10*log10(MAX_I/MSE(NdxRepeticion));
    DB(NdxRepeticion) = db_index(Modelo.Samples',Winners,Modelo.Means');
%     CS(NdxRepeticion) = nanmean(silhouetteMEX(Muestras,Winners'-1,max(Winners)));    
    
    if MSE(NdxRepeticion) < MinMSE,
        MinMSE = MSE(NdxRepeticion);
        NdxMinMSE = NdxRepeticion;
    end
end

% Dibujamos el mejor modelo resultante
Modelo = Modelos{NdxMinMSE};
% % Expandir los prototipos (deshacer el PCA)
% Modelo.Means = Uq*Modelo.Means+repmat(MediaGlobal,1,size(Modelo.Means,2));
% Dibujar
[Handle]=PlotGNFImages(Modelo,NumRowsImg,NumColsImg);

% PlotHandle=PlotTreeGHNG(Modelo,MediaGlobal,Uq,NumRowsImg,NumColsImg,ImageSize);
NomFichSalida = ['Plot_GNF_' NomFich];
hgsave(gcf,[NomFichSalida '.fig']);                 
fprintf('\nGuardando figura como PDF...\n');
fig = open([NomFichSalida '.fig']);
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[12 10]);
set(gcf,'PaperPosition',[0 0 12 10]);
axis off;
saveas(gcf,[NomFichSalida '.pdf'],'pdf');    
    
save(['./Resultados_GNF_' NomFich '.mat'],'MSE','PSNR','DB','CS','Time');
