function [Winners,Errors] = TestGHBNG(Prototypes,Samples,Type)
% Test a GHBNG model depending on the distance
% Inputs:
%   Prototypes=Planar prototypes of the GHBNG model
%   Samples=Matrix of input data (columns are samples)
%   Type = Bregman divergence type (see valid types below), as discussed in:
%       Banerjee, A.; Merugu, S.; Dhillon, I. S.; Ghosh, J. (2005). Clustering 
%       with Bregman divergences. Journal of Machine Learning Research 6,
%       1705-1749.
% Outputs:
%   Winners=Winning neurons for each input sample
%   Errors=Erros for each input sample

NumSamples = size(Samples,2);
Winners = zeros(NumSamples,1);
Errors = zeros(NumSamples,1);
NumNeuro = size(Prototypes,2);

% Main loop
for NdxSample=1:NumSamples       
    %SquaredDistances = sum((repmat(Samples(:,NdxSample),1,NumNeuro)-Prototypes).^2,1);
    RepMySample=repmat(Samples(:,NdxSample),1,NumNeuro);
    Quotient=RepMySample./Prototypes;
    switch Type
		case 'Squared Euclidean'
            % Squared Euclidean distance (standard Kohonen's SOFM)
			MyDistances=sum((RepMySample-Prototypes).^2,1);            			
		case 'Generalized I-Divergence'
			% Generalized I-divergence, strictly positive data only
			MyDistances=sum(RepMySample.*log(Quotient)-RepMySample+Prototypes,1);
		case 'Itakura-Saito'
			% Itakura-Saito distance, strictly positive data only
			MyDistances=sum(Quotient-log(Quotient)-1,1);
        case 'Exponential Loss'
            % Exponential loss, strictly positive data only
			MyDistances=sum(exp(RepMySample)-exp(Prototypes)-(RepMySample-Prototypes).*exp(Prototypes),1);
        case 'Logistic Loss'
            % Logistic loss, data inside the [0,1] interval only
			MyDistances=sum(RepMySample.*log(Quotient)+(1-RepMySample).*log((1-RepMySample)./(1-Prototypes)),1);
        case 'Kullback-Leibler'
            % Kullback-Leibler
			MyDistances=sum(RepMySample.*log(Quotient),1);
        otherwise
            error('Unknown Bregman Divergence')
    end           
    [Minimum,NdxWinner] = min(MyDistances);
    Winners(NdxSample) = NdxWinner;
    Errors(NdxSample) = Minimum;    
end