% Demo of the Growing Neural Forest
clear all

FileName='./Synthetic2D/Irregular.bmp';
%FileName='./Synthetic2D/HollowCircleInnerSquare.bmp';
% FileName='./Synthetic2D/Circle.bmp';
% FileName='./Synthetic2D/FourShapes.bmp';
NumSamples=20000;

MaxUnits=50;

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda=100;
NumSteps=20000;
EpsilonB=0.2;
EpsilonN=0.006;
Alpha=0.5;
AMax=50;
D=0.995;

%Samples=rand(2,20000);
Samples=GenerateSamplesImg(FileName,NumSamples);

[Model]=TrainGNF(Samples,MaxUnits,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumSteps);

Handle=PlotGNF(Model);
