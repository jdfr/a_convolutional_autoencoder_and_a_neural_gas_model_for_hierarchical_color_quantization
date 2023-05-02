% Pruebas Autoorganización GNG 2D
clear all
NumMuestras = 10000;
NumEpocas = 2;
NumPasos = NumEpocas*NumMuestras;
MaxNeurons = 50; % Maximum number of neurons in each graph
Extension = '.jpg';

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Leemos los conjuntos de datos del directorio
d = dir(['*' Extension]);
DatasetsValidos = [11 3];
Time = zeros(1,length(d));
MSE = zeros(1,length(d));
PSNR = zeros(1,length(d));
DB = zeros(1,length(d));
CS = zeros(1,length(d));

for dataset=DatasetsValidos,
% for dataset=4:4,
        
    NomFich = strrep(d(dataset).name,Extension,'');
    fprintf('\nIMAGEN: %s\n',NomFich);
    Muestras = GenerateSamplesImg(sprintf(['%s' Extension],NomFich),NumMuestras);        
                                            
    NomFichSalida = ['GNG_' NomFich];         

    if exist(['./' NomFichSalida '.mat'],'file') == 0,

        fprintf('\nENTRENAMIENTO GNG\n');
        fprintf('------------------------------------\n');            
        tic;
        [Modelo] = TrainGNG(Muestras,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
        Time(dataset) = toc;
        save([NomFichSalida '.mat'],'Modelo');         
    else
        fprintf('\nEntrenamiento realizado\n');    
        load(['./' NomFichSalida '.mat'],'Modelo');
    end
    
    % Calculamos el MSE
    [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);
    MSE(dataset) = mean(Errors);
    MaxI = max(max(Muestras)) - min(min(Muestras));
    PSNR(dataset) = 10*log10(MaxI^2/MSE(dataset));
    DB(dataset) = db_index(Modelo.Samples',Winners,Modelo.Means');
    CS(dataset) = nanmean(silhouetteMEX(Muestras,Winners'-1,max(Winners)));    
            
%     % Dibujamos el modelo resultante
%     Handle = figure;
%     Image = fliplr(rot90(double(rgb2gray(imread(d(dataset).name)))/255,2));
%     h = imshow(Image);
%     hold on
%     Ejes = axis(gca);
%     Ejes([1 3]) = round(Ejes([1 3]));
%     Ejes([2 4]) = floor(Ejes([2 4]))-1;
%     axis tight;
%     axis xy;
%     PlotGNGScaled(Modelo,Ejes);
%     axis off
%     hgsave(gcf,[NomFichSalida '.fig']);
%     fig = open([NomFichSalida '.fig']);
%     set(gcf,'PaperUnits','centimeters');
%     set(gcf,'PaperOrientation','portrait');
%     set(gcf,'PaperPositionMode','manual');
%     set(gcf,'PaperSize',[12 10]);
%     set(gcf,'PaperPosition',[0 0 12 10]);
%     axis off;
%     saveas(gcf,[NomFichSalida '.pdf'],'pdf');    
%     close all;
end
% save('ResultadosAutoorganizacionGNG.mat','MSE','PSNR','DB','Time');

