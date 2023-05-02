function [Model] = TrainGHBNG(Samples,Epochs,Type,MaxNeurons,Tau,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,Level)
% Train a Growing Hierarchical Bregman M-Estimator Neural Gas (GHBNG)
% E.J. Palomo  -- Last Modified: December 2017
% Inputs:
%   Samples=Input samples (one sample per column)
%   Epochs=Number of epochs to train the data
%   Type=Bregman divergence type (see valid types below), as discussed in:
%       Banerjee, A.; Merugu, S.; Dhillon, I. S.; Ghosh, J. (2005). Clustering 
%       with Bregman divergences. Journal of Machine Learning Research 6,
%       1705-1749.
%   MaxNeurons=Maximum number of neurons in each graph. Tipically MaxNeurons=20
%   Tau=Learning parameter, 0<Tau<1. Tipically Tau=0.01 for a detailed map
%       or Tau=0.02 for a less detailed map
%   Lambda=Number of steps between unit creations
%   EpsilonB=Learning rate for the best matching unit
%   EpsilonN=Learning rate for the neighbors of the best matching unit
%   Alpha=Factor for reducing the value of the error counter in case of
%       unit creation
%   AMax=Maximum admissible age of a connection
%   D=Factor for decreasing the value of the error counter each step
%   Level=Current level of the hierarchy
% Output:
%   Model=Trained GHBNG model
% See also:
% Bernd Fritzke (1995). A Growing Neural Gas Network Learns Topologies. 
% Advances in Neural Information Processing Systems 7, pp. 625-632.

Model = [];
MaxLevels = 4;
[Dimension,NumSamples]=size(Samples);
if ((NumSamples<(Dimension+1)) && (Level>1)) || (Level > MaxLevels)    
    return;
end

%fprintf('\nLEVEL=%d\n',Level);
%% Growing Process
NumSteps = Epochs*NumSamples;
Model = TrainGBNG(Samples,Type,MaxNeurons,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumSteps,Tau);

%% Expansion Process
Winners = Model.Winners;
NdxNeurons = find(isfinite(Model.Means(1,:)));
%fprintf('Final Graph Neurons: %d\n',numel(NdxNeurons));

%% Prune the graphs with only 2 neurons. This is to simplify the hierarchy
if numel(NdxNeurons)==2
    Model=[];
    return;
end

for NdxNeuro=NdxNeurons
    ChildSamples = Samples(:,Winners==NdxNeuro);
    Model.Child{NdxNeuro} = TrainGHBNG(ChildSamples,Epochs,Type,...
        MaxNeurons,Tau,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,Level+1);
end

