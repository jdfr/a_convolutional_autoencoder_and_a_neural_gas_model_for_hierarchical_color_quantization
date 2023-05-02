% Pruebas Autoorganización SOM 2D
clear all
NumMuestras = 10000;
NumEpocas = 2;
NumPasos = NumEpocas*NumMuestras;
% MaxNeurons = 50; % Maximum number of neurons in each graph
NumRows = 10;
NumCols = 5;
Extension = '.jpg';

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
                                            
    NomFichSalida = ['SOM_' NomFich];         

    if exist(['./' NomFichSalida '.mat'],'file') == 0,

        fprintf('\nENTRENAMIENTO SOM\n');
        fprintf('------------------------------------\n');            
        tic;
        % SOM Training using the SOM Toolbox        
        SOMModel = som_make(Muestras','randinit','seq','msize',[NumRows NumCols],...
            'rect','sheet','gaussian','tracking',0); 
        Time(dataset) = toc;        
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
% %     PlotGNGScaled(Modelo,Ejes);
%     plot(Modelo.Means(1,:)*Ejes(2)+Ejes(1),Modelo.Means(2,:)*Ejes(4)+Ejes(3),'or','LineWidth',1)    
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

