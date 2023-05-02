% Ejemplo entrenamiento GNF 2D
clear all
NumMuestras = 10000;
NumEpocas = 2;
NumPasos = NumEpocas*NumMuestras;
MaxNeurons = 50; % Maximum number of neurons in each graph
NomFich = 'ThreeBalls.jpg';

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

fprintf('\nIMAGEN: %s\n',NomFich);
Muestras = GenerateSamplesImg(NomFich,NumMuestras);        
fprintf('\nEntrenando GNF\n');      
[Model] = TrainGNFPlot(Muestras,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos,NomFich);   
fprintf('\nEntrenamiento realizado\n');      

