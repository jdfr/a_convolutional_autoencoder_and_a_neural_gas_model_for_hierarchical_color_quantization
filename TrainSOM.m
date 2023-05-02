function [Model,Distances]=TrainSOM(Model,Samples,NumSteps)
% Train a Self-Organizing Map (SOM)
% Inputs:
%   Model=GHSOM model
%	Samples=Training samples (one sample per column)
%	NumSteps=Number of training steps
% Output:
%   Model=Trained GHSOM model

[Dimension,NumSamples]=size(Samples);
NumRowsMap = Model.NumRowsMap;
NumColsMap = Model.NumColsMap;
NumNeuro = NumRowsMap*NumColsMap;
TopolDist = Model.TopolDist;
Distances=zeros(NumNeuro,NumSamples);

% Training
%fprintf('\nTraining SOM\n')
MaxRadius=(NumRowsMap+NumColsMap)/8;
NdxPermSamples = randperm(NumSteps);

for NdxStep=1:NumSteps    
    %NdxSample = ceil(NumSamples*rand(1));
    NdxSample = mod(NdxPermSamples(NdxStep)-1,NumSamples)+1;    
    MySample=Samples(:,NdxSample);
    if NdxStep<0.5*NumSteps   
        % Ordering phase: linear decay
        LearningRate=0.4*(1-NdxStep/NumSteps);
        MyRadius=MaxRadius*(1-(NdxStep-1)/NumSteps);
    else
        % Convergence phase: constant
        LearningRate=0.01;
        MyRadius=0.1;
    end
    
    % Euclidean distance (standard Kohonen's SOFM)
    RepMySample=repmat(MySample,1,NumNeuro);        
    MyDistances=sqrt(sum((RepMySample-Model.Prototypes(:,:)).^2,1));            			    
    Distances(:,NdxSample) = MyDistances';        
   
    % Update the neurons
    [~,NdxWinner]=min(MyDistances);
    Coef=repmat(LearningRate*exp(-TopolDist{NdxWinner}/(MyRadius^2)),Dimension,1);
    Model.Prototypes(:,:)=Coef.*repmat(MySample,1,NumNeuro)+...
        (1-Coef).*Model.Prototypes(:,:);
    %if mod(NdxStep,NumSamples)==0
    %    fprintf('%d steps completed\n',NdxStep);        
    %end
end

%fprintf('Training finished\n')

    
    
        
