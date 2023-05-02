function [NumNeuronas,NumNeuronasHoja] = GetNumberNeuronsGHSOM(Model)
% Get the numer of leaf and non-leaf neurons of the GHSOM model.
% Input:
%   Model = GHSOM Model 
% Output:
%   NumNeuronas = Number of neurons of the GHSOM model
%   NumNeuronasHoja = Number of leaf neurons of the GHSOM model
    
NdxValidNeurons = find(isfinite(Model.Prototypes(1,:,:)));
NumNeuronas = numel(NdxValidNeurons);
NumNeuronasHoja = NumNeuronas;

for NdxNeuro=NdxValidNeurons(1):NdxValidNeurons(end)
    if isfield(Model,'Child') && ~isempty(Model.Child{NdxNeuro})
        [NumNeuronasHijo,NumNeuronasHojaHijo] = GetNumberNeuronsGHSOM(Model.Child{NdxNeuro});
        NumNeuronas = NumNeuronas + NumNeuronasHijo;
        NumNeuronasHoja = NumNeuronasHoja + NumNeuronasHojaHijo - 1;
    end    
end

