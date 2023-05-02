% Pruebas Autoorganización GNF con Hiperesferas en 6D
clear all
Dimension = 6;
NumMuestras = 10000;
NumEpocas = 2;
NumPasos = NumEpocas*NumMuestras;
MaxNeurons = 50; % Maximum number of neurons in each graph

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Generamos dos hiperesferas
Samples1 = insideSphereGen(Dimension,NumMuestras);
Samples2 = insideSphereGen(Dimension,NumMuestras);
% Samples3 = insideSphereGen(Dimension,NumMuestras);
% Muestras = [Samples1 Samples2+repmat([4 2 5 -2 1]',[1 NumMuestras]) Samples3+repmat([7 4 -1 -7 12]',[1 NumMuestras]) ];
Muestras = [Samples1 Samples2+repmat([4 2 5 -2 1 2]',[1 NumMuestras])];
        
% Entrenamiento GNF
NomFichSalida = ['Resultado_GNF_Hiperesferas6D'];     
if exist(['./' NomFichSalida '.mat'],'file') == 0,
    fprintf('\nENTRENAMIENTO GNF\n');
    fprintf('------------------------------------\n');            
    tic;
    [Modelo] = TrainGNF(Muestras,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
    Time = toc;   
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
% h = plot3(Muestras(1,:),Muestras(2,:),Muestras(3,:),'.k');
h = plot(Muestras(1,:),Muestras(2,:),'.k');
axis equal;
hold on;
uistack(gcf,'bottom');
PlotGNF(Modelo);   
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

% plot3(Muestras(3,:),Muestras(4,:),Muestras(5,:),'.k');
plot(Muestras(3,:),Muestras(4,:),'.k');
axis equal;
hold on;
uistack(gcf,'bottom');
PlotGNFShift(Modelo,2);  
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
PlotGNFShift(Modelo,4);  
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

%Dibujamos solo las muestras
% plot3(Muestras(1,:),Muestras(2,:),Muestras(3,:),'.k');
plot(Muestras(1,:),Muestras(2,:),'.k');
axis equal;
axis off
saveas(gcf,[NomFichSalida 'Samples1.fig'],'fig');
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[12 10]);
set(gcf,'PaperPosition',[0 0 12 10]);
saveas(gcf,[NomFichSalida 'Samples1.pdf'],'pdf');    
close all;

% plot3(Muestras(3,:),Muestras(4,:),Muestras(5,:),'.k');
plot(Muestras(3,:),Muestras(4,:),'.k');
axis equal;
axis off
saveas(gcf,[NomFichSalida 'Samples2.fig'],'fig');
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[12 10]);
set(gcf,'PaperPosition',[0 0 12 10]);
saveas(gcf,[NomFichSalida 'Samples2.pdf'],'pdf');    
close all;

plot(Muestras(5,:),Muestras(6,:),'.k');
axis equal;
axis off
saveas(gcf,[NomFichSalida 'Samples3.fig'],'fig');
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[12 10]);
set(gcf,'PaperPosition',[0 0 12 10]);
saveas(gcf,[NomFichSalida 'Samples3.pdf'],'pdf');    
close all;
