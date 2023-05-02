function [SQE,QE] = GetQEGNG(Model,Samples,Winners)
% Get the sum of the neurons' quantization error (QE) from the model and
% the obtained QE vector.

% Get the winning neurons for each sample
% Winners = Model.Winners;

% Compute the QEs
NdxValidNeurons = find(isfinite(Model.Means(1,:)));
Means = Model.Means(:,isfinite(Model.Means(1,:)));

for NdxNeuro=NdxValidNeurons,        
    InputNdx = Winners == NdxNeuro;    
    QE(NdxNeuro) = QuantizationError(Means(:,NdxNeuro),Samples(:,InputNdx),'abs');    
end
QE(isinf(QE)) = NaN;
SQE = nansum(QE);