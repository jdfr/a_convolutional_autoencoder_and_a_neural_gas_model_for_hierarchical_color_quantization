function QE = QuantizationError(w,Samples,ErrorType)
% *************************************************************************
% Descripción: función que calcula el error de cuantificación de una
%              neurona
% Entrada:
%   w: vector de pesos de la neurona
%   Samples: datos de entrada
%   ErrorType: tipo de error de cuantificación a calcular ('abs', 'mean' o 
%            'median')
% Salida:
%   QE: error de cuantificación de la neurona
% *************************************************************************

if isempty(Samples),
    QE = 0;
else        
    % Euclidean distance (standard Kohonen's SOFM)
    RepW = repmat(w,1,size(Samples,2));   
%     QE = sqrt(sum((Samples-RepW).^2,1));    
    QE = sum((Samples-RepW).^2,1);    % Error cuadrático

    % Obtenemos el QE absoluto, mediano o medio, en función del 'tipo_qe'
    if (strcmp(ErrorType,'median')),    
        QE = nanmedian(QE);
    else
        QE = nansum(QE);
        if (strcmp(ErrorType,'mean')),        
            QE = QE/size(Samples,2);       
        end
    end
end
