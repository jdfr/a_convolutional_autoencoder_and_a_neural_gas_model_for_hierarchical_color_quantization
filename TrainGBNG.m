function [Model]=TrainGBNG(Samples,Type,MaxUnits,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumSteps,Tau)
% Train a Growing Bregman M-Estimator Neural Gas (GBNG) neural network
% E.j. Palomo and E. López-Rubio
% Reference:
%   Fritzke, B. (1995). A Growing Neural Gas Network Learns Topologies.
%       Advances in Neural Information Processing Systems 7, 625-632.
% Inputs:
%   Samples=Input samples (one sample per column)
%   Type=Bregman divergence type (see valid types below), as discussed in:
%       Banerjee, A.; Merugu, S.; Dhillon, I. S.; Ghosh, J. (2005). Clustering 
%       with Bregman divergences. Journal of Machine Learning Research 6,
%       1705-1749.
%   MaxNeurons=Maximum number of neurons in each graph. Tipically MaxNeurons=20
%   Lambda=Number of steps between unit creations
%   EpsilonB=Learning rate for the best matching unit
%   EpsilonN=Learning rate for the neighbors of the best matching unit
%   Alpha=Factor for reducing the value of the error counter in case of
%       unit creation
%   D=Factor for decreasing the value of the error counter each step
%   AMax=Maximum admissible age of a connection
%   NumSteps=Total number of steps
% Output:
%   Model=Trained modified GBMNG model

Model.Samples=Samples;
Model.Divergence=Type;
Model.MaxUnits=MaxUnits;
Model.Lambda=Lambda;
Model.EpsilonB=EpsilonB;
Model.EpsilonN=EpsilonN;
Model.Alpha=Alpha;
Model.AMax=AMax;
Model.D=D;
Model.NumSteps=NumSteps;
Model.Winners=zeros(1,size(Samples,2));

[Dimension,NumSamples]=size(Samples);

% Prototype vectors
Model.Means=nan*ones(Dimension,MaxUnits);

% Accumulated errors
Model.Errors=zeros(1,MaxUnits);

% Matrix of connections. An absent connection is represented by a zero value.
% A present connection is represented by a positive value which is the
% number of steps remaining until connection removal, i.e. its time to live
Model.Connections=sparse(MaxUnits,MaxUnits);

% Initialization (two units and a connection between them)
Model.Means(:,1:2)=Samples(:,ceil(rand(2,1)*NumSamples));
Model.Connections(1,2)=AMax;
Model.Connections(2,1)=AMax;

% Random permutation of samples
SampleNdxs=randperm(NumSamples);
Growing = 1;

% Main loop
for NdxStep=1:NumSteps
    % Choose a random sample    
%     SampleIndex=ceil(rand(1)*NumSamples);
%     SampleIndex=SampleNdxs(NdxStep);
    SampleIndex=SampleNdxs(mod(NdxStep-1,NumSamples)+1); % to allow more than one epoch
    MySample=Samples(:,SampleIndex);
    
    % Determine the first (S1) and second (S2) best matching units
    RepMySample=repmat(MySample,1,MaxUnits);
    Quotient=RepMySample./Model.Means;
    switch Type
		case 'Squared Euclidean'
            % Squared Euclidean distance (standard Kohonen's SOFM)
			MyDistances=sum((RepMySample-Model.Means).^2,1);            			
		case 'Generalized I-Divergence'
			% Generalized I-divergence, strictly positive data only
			MyDistances=sum(RepMySample.*log(Quotient)-RepMySample+Model.Means,1);
		case 'Itakura-Saito'
			% Itakura-Saito distance, strictly positive data only
			MyDistances=sum(Quotient-log(Quotient)-1,1);
        case 'Exponential Loss'
            % Exponential loss, strictly positive data only
			MyDistances=sum(exp(RepMySample)-exp(Model.Means)-(RepMySample-Model.Means).*exp(Model.Means),1);
        case 'Logistic Loss'
            % Logistic loss, data inside the [0,1] interval only
			MyDistances=sum(RepMySample.*log(Quotient)+(1-RepMySample).*log((1-RepMySample)./(1-Model.Means)),1);
        case 'Kullback-Leibler'
            % Kullback-Leibler
			MyDistances=sum(RepMySample.*log(Quotient),1);
        otherwise
            error('Unknown Bregman Divergence')
    end
    [Sorted Indexes]=sort(MyDistances);
    S1=Indexes(1);
    S2=Indexes(2);
    Model.Winners(SampleIndex)=S1;
    
    % Decrease the time to live of all edges emanating from S1
    Model.Connections(S1,:)=max(0,Model.Connections(S1,:)-1);
    Model.Connections(:,S1)=max(0,Model.Connections(:,S1)-1);
    
    % Add the squared distance of S1 to the input sample to the error
    % counter of S1
    Model.Errors(S1)=Model.Errors(S1)+Sorted(1);
    
    % Move S1 and its topological neighbors towards the input sample
    Model.Means(:,S1)=(1-EpsilonB)*Model.Means(:,S1)+EpsilonB*MySample;
    Neighbors=find(Model.Connections(S1,:));
    Model.Means(:,Neighbors)=(1-EpsilonN)*Model.Means(:,Neighbors)+...
        EpsilonN*repmat(MySample,1,numel(Neighbors));
    
    % Create or refresh the connection between S1 and S2
    Model.Connections(S1,S2)=AMax;
    Model.Connections(S2,S1)=AMax;
    
    % Remove units with no emanating edges
    NdxNoEdges=find(sum(Model.Connections>0,1)==0);
    Model.Means(:,NdxNoEdges)=nan;
    Model.Errors(NdxNoEdges)=0;
    
    % Unit creation (only if the graph can keep growing)
    if mod(NdxStep,Lambda)==0 && Growing
        % Store the mean quantization error for the current number of neurons
        OldNumNeurons=nnz(isfinite(Model.Means(1,:)));
        Model.MQE(OldNumNeurons)=sum(Model.Errors)/OldNumNeurons;
        
        % Store the current model
        OldModel=Model;
        
        % Find the unit with the largest error
        [Maximum NdxMaxError]=max(Model.Errors);
        
        % Find its neighbor with the largest error
        [Maximum NdxNeighbor]=max(Model.Errors.*(Model.Connections(NdxMaxError,:)>0));
        
        % Create the new unit, if possible. Otherwise, finish
        NdxNewUnit=find(isnan(Model.Means(1,:)),1,'first');
        if ~isempty(NdxNewUnit)        
            % Set the new prototype vector
            Model.Means(:,NdxNewUnit)=0.5*(Model.Means(:,NdxMaxError)+...
                Model.Means(:,NdxNeighbor));
            
            % Remove the connection between the two old units
            Model.Connections(NdxMaxError,NdxNeighbor)=0;
            Model.Connections(NdxNeighbor,NdxMaxError)=0;    
            
            % Create connections among the new unit and the two old ones
            Model.Connections(NdxNewUnit,[NdxMaxError NdxNeighbor])=AMax;
            Model.Connections([NdxMaxError NdxNeighbor],NdxNewUnit)=AMax;
            
            % Decrease the errors of the old units and set the error of the new
            % one
            Model.Errors([NdxMaxError NdxNeighbor])=Alpha*...
                Model.Errors([NdxMaxError NdxNeighbor]);
            Model.Errors(NdxNewUnit)=Model.Errors(NdxMaxError);
        end
    end
    % Growing check
    if mod(NdxStep,2*Lambda)==floor(3*Lambda/2)
        NumNeurons=nnz(isfinite(Model.Means(1,:)));
        Model.MQE(NumNeurons)=sum(Model.Errors)/NumNeurons;
        if NumNeurons>OldNumNeurons
            Improvement = (Model.MQE(OldNumNeurons)-Model.MQE(NumNeurons))/abs(Model.MQE(OldNumNeurons));
            if Improvement < Tau  
                %Improvement
                %OldNumNeurons
                %NumNeurons
                Model = OldModel;   
                Growing = 0;
            end        
        end
    end
    
    % Decrease all error variables by multiplying them by D
    Model.Errors=D*Model.Errors; 
end
