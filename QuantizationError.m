function QE = QuantizationError(w,Samples,ErrorType)
% *************************************************************************
% Descripci�n: funci�n que calcula el error de cuantificaci�n de una
%              neurona
% Entrada:
%   w: vector de pesos de la neurona
%   Samples: datos de entrada
%   ErrorType: tipo de error de cuantificaci�n a calcular ('abs', 'mean' o 
%            'median')
% Salida:
%   QE: error de cuantificaci�n de la neurona
% *************************************************************************

if isempty(Samples),
    QE = 0;
else        
    % Euclidean distance (standard Kohonen's SOFM)
    RepW = repmat(w,1,size(Samples,2));   
%     QE = sqrt(sum((Samples-RepW).^2,1));    
    QE = sum((Samples-RepW).^2,1);    % Error cuadr�tico

    % Obtenemos el QE absoluto, mediano o medio, en funci�n del 'tipo_qe'
    if (strcmp(ErrorType,'median')),    
        QE = nanmedian(QE);
    else
        QE = nansum(QE);
        if (strcmp(ErrorType,'mean')),        
            QE = QE/size(Samples,2);       
        end
    end
end
