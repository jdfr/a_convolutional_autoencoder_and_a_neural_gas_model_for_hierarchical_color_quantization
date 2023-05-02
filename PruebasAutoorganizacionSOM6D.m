% Pruebas Autoorganización SOM con Hiperesferas en 6D
clear all
Dimension = 6;
NumMuestras = 10000;
NumEpocas = 2;
NumPasos = NumEpocas*NumMuestras;
% MaxNeurons = 50; % Maximum number of neurons in each graph
NumRows = 10;
NumCols = 5;

% Generamos dos hiperesferas
Samples1 = insideSphereGen(Dimension,NumMuestras);
Samples2 = insideSphereGen(Dimension,NumMuestras);
% Samples3 = insideSphereGen(Dimension,NumMuestras);
% Muestras = [Samples1 Samples2+repmat([4 2 5 -2 1]',[1 NumMuestras]) Samples3+repmat([7 4 -1 -7 12]',[1 NumMuestras]) ];
Muestras = [Samples1 Samples2+repmat([4 2 5 -2 1 2]',[1 NumMuestras])];
        
% Entrenamiento GNF
NomFichSalida = ['Resultado_SOM_Hiperesferas6D'];
if exist(['./' NomFichSalida '.mat'],'file') == 0,
    fprintf('\nENTRENAMIENTO SOM\n');
    fprintf('------------------------------------\n');            
    tic;
    % SOM Training using the SOM Toolbox        
    SOMModel = som_make(Muestras','randinit','seq','msize',[NumRows NumCols],...
                'rect','sheet','gaussian','tracking',0); 
    Time = toc;
    Modelo.Samples = Muestras;
    Modelo.Means = SOMModel.codebook';
    [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);
    Modelo.Winners = Winners;
    Modelo.Errors = Errors;
    save([NomFichSalida '.mat'],'Modelo');
else
    fprintf('\nEntrenamiento realizado\n');    
    load(['./' NomFichSalida '.mat'],'Modelo');
end

% Calculamos el MSE
[Winners,Errors] = TestGNG(Modelo,Modelo.Samples);
MSE = mean(Errors);
MaxI = max(max(Muestras)) - min(min(Muestras));
PSNR = 10*log10(MaxI^2/MSE);
DB = db_index(Muestras',Winners,Modelo.Means');
CS = nanmean(silhouetteMEX(Muestras,Winners'-1,max(Winners)));

% save([NomFichSalida '.mat'],'Modelo','MSE','PSNR','DB','Time');

% Dibujamos el modelo resultante
plot(Muestras(1,:),Muestras(2,:),'.k');
axis equal;
hold on;
uistack(gcf,'bottom');
DimShift = 0;
plot(Modelo.Means(1+DimShift,:),Modelo.Means(2+DimShift,:),'or','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',5);
% axis equal
axis off
saveas(gcf,[NomFichSalida '1.fig'],'fig');
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[12 10]);
set(gcf,'PaperPosition',[0 0 12 10]);
saveas(gcf,[NomFichSalida '1.pdf'],'pdf');    
close all;

plot(Muestras(3,:),Muestras(4,:),'.k');
axis equal;
hold on;
uistack(gcf,'bottom');
DimShift = 2;
plot(Modelo.Means(1+DimShift,:),Modelo.Means(2+DimShift,:),'or','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',5);
% PlotGNF5D(Modelo,1);  
% axis equal
axis off
saveas(gcf,[NomFichSalida '2.fig'],'fig');
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[12 10]);
set(gcf,'PaperPosition',[0 0 12 10]);
saveas(gcf,[NomFichSalida '2.pdf'],'pdf');    
close all;

plot(Muestras(5,:),Muestras(6,:),'.k');
axis equal;
hold on;
uistack(gcf,'bottom');
DimShift = 4;
plot(Modelo.Means(1+DimShift,:),Modelo.Means(2+DimShift,:),'or','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',5);
% PlotGNF5D(Modelo,1);  
% axis equal
axis off
saveas(gcf,[NomFichSalida '3.fig'],'fig');
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[12 10]);
set(gcf,'PaperPosition',[0 0 12 10]);
saveas(gcf,[NomFichSalida '3.pdf'],'pdf');    
close all;

% %Dibujamos solo las muestras
% plot3(Muestras(1,:),Muestras(2,:),Muestras(3,:),'.k');
% axis equal;
% axis off
% saveas(gcf,[NomFichSalida 'Samples1.fig'],'fig');
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperOrientation','portrait');
% set(gcf,'PaperPositionMode','manual');
% set(gcf,'PaperSize',[12 10]);
% set(gcf,'PaperPosition',[0 0 12 10]);
% saveas(gcf,[NomFichSalida 'Samples1.pdf'],'pdf');    
% close all;
% 
% plot3(Muestras(3,:),Muestras(4,:),Muestras(5,:),'.k');
% axis equal;
% axis off
% saveas(gcf,[NomFichSalida 'Samples2.fig'],'fig');
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperOrientation','portrait');
% set(gcf,'PaperPositionMode','manual');
% set(gcf,'PaperSize',[12 10]);
% set(gcf,'PaperPosition',[0 0 12 10]);
% saveas(gcf,[NomFichSalida 'Samples2.pdf'],'pdf');    
% close all;
