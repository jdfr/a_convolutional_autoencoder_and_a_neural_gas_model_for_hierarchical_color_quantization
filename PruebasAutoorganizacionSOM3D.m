% Pruebas Autoorganización SOM 3D
clear all
NumMuestras = 10000;
NumEpocas = 2;
NumPasos = NumEpocas*NumMuestras;
% MaxNeurons = 50; % Maximum number of neurons in each graph
NumRows = 10;
NumCols = 5;
Datasets = {'SwissRoll','SwissHole','CornerPlanes','PuncturedSphere',...
    'TwinPeaks','3DClusters','ToroidalHelix','Gaussian','UedasSpiral'};

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
                                            
    NomFichSalida = ['SOM_' NomFich];         

    if exist(['./' NomFichSalida '.mat'],'file') == 0,

        fprintf('\nENTRENAMIENTO SOM\n');
        fprintf('------------------------------------\n');                    
        tic;
        % SOM Training using the SOM Toolbox        
        SOMModel = som_make(Muestras','randinit','seq','msize',[NumRows NumCols],...
            'rect','sheet','gaussian','tracking',0); 
        Time(NdxDataset) = toc;
        Modelo.Samples = Muestras;
        Modelo.Means = SOMModel.codebook';
        [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);        
        Modelo.Winners = Winners;
        Modelo.Errors = Errors;       
        save([NomFichSalida '.mat'],'Modelo');         
    else
        fprintf('\nEntrenamiento realizado\n');    
        load(['./' NomFichSalida '.mat'],'Modelo');
        [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);        
    end
    
    % Calculamos el MSE    
    MSE(NdxDataset) = mean(Errors);
    MaxI = max(max(Muestras)) - min(min(Muestras));
    PSNR(NdxDataset) = 10*log10(MaxI^2/MSE(NdxDataset));
    DB(NdxDataset) = db_index(Modelo.Samples',Winners,Modelo.Means');
    CS(NdxDataset) = nanmean(silhouetteMEX(Muestras,Winners'-1,max(Winners)));    
            
%     % Dibujamos el modelo resultante
%     GenerateManifolds3D(NdxDataset,50,1);
%     hold on;
%     uistack(gcf,'bottom');
%     plot3(Modelo.Means(1,:),Modelo.Means(2,:),Modelo.Means(3,:),'or','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',10)
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
% save('ResultadosAutoorganizacionSOM.mat','MSE','PSNR','DB','Time');

