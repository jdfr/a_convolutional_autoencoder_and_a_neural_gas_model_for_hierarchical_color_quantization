% Pruebas Autoorganización GNF 3D
clear all
NumMuestras = 10000;
NumEpocas = 2;
NumPasos = NumEpocas*NumMuestras;
MaxNeurons = 50; % Maximum number of neurons in each graph
Datasets = {'SwissRoll','SwissHole','CornerPlanes','PuncturedSphere',...
    'TwinPeaks','3DClusters','ToroidalHelix','Gaussian','UedasSpiral'};

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Leemos los conjuntos de datos del directorio
DatasetsValidos = [1 2 7 9];
Time = zeros(1,length(Datasets));
MSE = zeros(1,length(Datasets));
PSNR = zeros(1,length(Datasets));
DB = zeros(1,length(Datasets));
CS = zeros(1,length(Datasets));

for NdxDataset=DatasetsValidos,
% for NdxDataset=1:1,
        
    NomFich = Datasets{NdxDataset};
    fprintf('\nIMAGEN: %s\n',NomFich);
    Muestras = Generate3DSamples(NdxDataset,NumMuestras);        
                                            
    NomFichSalida = ['GNF_' NomFich];         

    if exist(['./' NomFichSalida '.mat'],'file') == 0,

        fprintf('\nENTRENAMIENTO GNF\n');
        fprintf('------------------------------------\n');            
        tic;
        [Modelo] = TrainGNF(Muestras,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
        Time(NdxDataset) = toc;
        save([NomFichSalida '.mat'],'Modelo');         
    else
        fprintf('\nEntrenamiento realizado\n');    
        load(['./' NomFichSalida '.mat'],'Modelo');
    end
    
    % Calculamos el MSE
    [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);
    MSE(NdxDataset) = mean(Errors);
    MaxI = max(max(Muestras)) - min(min(Muestras));
    PSNR(NdxDataset) = 10*log10(MaxI^2/MSE(NdxDataset));
    DB(NdxDataset) = db_index(Modelo.Samples',Winners,Modelo.Means');
    CS(NdxDataset) = nanmean(silhouetteMEX(Muestras,Winners'-1,max(Winners)));    
            
%     % Dibujamos el modelo resultante
%     GenerateManifolds3D(NdxDataset,50,1);
%     hold on;
%     uistack(gcf,'bottom');
%     PlotGNF3D(Modelo);        
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
% save('ResultadosAutoorganizacionGNF.mat','MSE','PSNR','Time');

