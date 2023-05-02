function [Model]=TrainGHSOM(Samples,NdxSamples,Epochs,Tau1,Tau2,ErrorType,IniQE,ParentQE,IniPrototypes,Level)
% Train a Growing Hierarchical Self-Organizing Map (GHSOM)
% E.J. Palomo  -- Last Modified: January 2013
% Inputs:
%   Samples=Input samples (one sample per column)
%   NdxSamples=Index of samples from the initial dataset
%   Epochs=Number of epochs to train the data
%   Tau1=Growing control parameter (between 0 and 1)
%   Tau2=Expansion control parameter (between 0 and 1)
%   ErrorType=Type of error to compute the quantization error
%       ('abs','mean' or 'median')
%   IniQE=Initial quantization error
%   ParentQE=Quantization error of the parent neuron
%   IniPrototypes=Prototypes to initialize a child BSOM
%   Level=Current level of the hierarchy
% Output:
%   Model=Trained GHSOM model
% See also:
% Rauber et al (2002). The growing hierarchical self-organizing map: 
% Exploratory analysis of high-dimensional data. IEEE Trans. on Neural
% Networks. 13(6):1331–1341.

%fprintf('\nLEVEL %d\n',Level);
Model = [];
[Dimension,NumSamples] = size(Samples);
NumSteps = NumSamples*Epochs;
NumRowsMap = 2;
NumColsMap = 2;
NumNeurons = NumRowsMap*NumColsMap;
Grow = 1;

%% Training Process
while Grow,
    
    % Initialize GHSOM
    [Model] = InitializeGHSOM(Model,Samples,NumRowsMap,NumColsMap,IniPrototypes);                    
    
    % Train the GHSOM
    [Model,Distances] = TrainSOM(Model,Samples,NumSteps);
         
    % Compute the quantization error for each neuron based on Euclidean
    % distance
    [~,Winners] = min(Distances);
    W  = reshape(Model.Prototypes,Dimension,NumNeurons);
    QE = zeros(NumNeurons,1);
    for NdxNeuro=1:NumNeurons,
        InputNdx = Winners == NdxNeuro;        
        QE(NdxNeuro) = QuantizationError(W(:,NdxNeuro),Samples(:,InputNdx),ErrorType);        
    end                        
                    
    % Verification of the Growing Criterion
    MQE = sum(QE)/size(QE,1);
    Grow = (MQE >= Tau1*ParentQE) && (MQE > 0) && ~isinf(MQE);
    %fprintf('\nGrowing Criterion: %g >= (%g*%g) // (MQE >= Tau1*ParentQE)\n\n',MQE,Tau1,ParentQE);
        
    if Grow,       
        %% Growing Process        
        % Compute the error neuron
        [~,NdxErrorNeuron] = max(QE);

        % Compute the error neuron's neighbor with maximum error
        P = zeros(NumRowsMap,NumColsMap);
        P([1:NumNeurons]) = [1:NumNeurons];
        NdxNeigbors = GetNeighborsMap(P,NdxErrorNeuron);
        [~,NdxMaxQE] = max(QE(NdxNeigbors));
        NdxErrorNeuron2 = NdxNeigbors(NdxMaxQE);
        
        % Add a row or a column of neurons between the two computed neurons                           
        Model.Prototypes = InsertNeuronsMap(Model.Prototypes,P,NdxErrorNeuron,NdxErrorNeuron2);
        [~,NumRowsMap,NumColsMap] = size(Model.Prototypes);
        NumNeurons = NumRowsMap*NumColsMap;                       
    end
end

%% Expansion Process
Model.NdxSamples = NdxSamples;
Model.QE = QE;
for NdxNeuro=1:NumNeurons,                
    
    % Verification of the Expansion Criterion        
    Expand = (QE(NdxNeuro) >= Tau2*IniQE) && (QE(NdxNeuro) > 0)  && ~isinf(QE(NdxNeuro));
    %fprintf('Expansion Criterion: %g >= (%g*%g) // (QEi >= Tau2*IniQE)\n',QE(NdxNeuro),Tau2,IniQE);
    
    if Expand, 
        %fprintf('\tExpanding Neuron...\n');
        NdxChildSamples = NdxSamples(Winners==NdxNeuro);
        ChildSamples = Samples(:,Winners==NdxNeuro);
        ChildPrototypes = InitChildPrototypes(Model.Prototypes,NdxNeuro);
                
        % Train a Child BSOM
        Model.Child{NdxNeuro} = TrainGHSOM(ChildSamples,NdxChildSamples,Epochs,Tau1,Tau2,ErrorType,IniQE,QE(NdxNeuro),ChildPrototypes,Level+1);      
        %fprintf('\nLEVEL %d\n',Level);
    else        
        Model.Child{NdxNeuro} = [];
    end
end
