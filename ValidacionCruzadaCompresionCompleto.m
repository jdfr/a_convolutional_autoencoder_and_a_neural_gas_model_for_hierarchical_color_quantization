function [EvaluacionValidada]=ValidacionCruzadaCompresionCompleto(Evaluaciones)
% Evaluar el rendimiento de una compresión de imagen usando validación 
% cruzada
% Entrada:
%   Evaluaciones=Evaluaciones de las compresiones obtenidas en la
%   validación cruzada, calculadas mediante evaluarCompresionImagen.m
% Salida:
%   EvaluacionValidada=Resumen de las evaluaciones de las compresiones

if isempty(Evaluaciones),
    EvaluacionValidada = [];
else
    NumDatos=length(Evaluaciones);

    % Error cuadrático medio (MSE)
    MSE = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx}),
            MSE(ndx)=Evaluaciones{ndx}.MSE;
        else
            MSE(ndx) = NaN;
        end
    end
    EvaluacionValidada.MSE.Media=mean(MSE(isfinite(MSE)));
    EvaluacionValidada.MSE.DesvTip=std(MSE(isfinite(MSE)));
    
    % Relación señal-ruido pico (PSNR)
    PSNR = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx}),
            PSNR(ndx)=Evaluaciones{ndx}.PSNR;
        else
            PSNR(ndx) = NaN;
        end
    end
    EvaluacionValidada.PSNR.Media=mean(PSNR(isfinite(PSNR)));
    EvaluacionValidada.PSNR.DesvTip=std(PSNR(isfinite(PSNR)));
    
    % Relación señal-ruido pico (SSIM)
    SSIM = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx}),
            SSIM(ndx)=Evaluaciones{ndx}.SSIM;
        else
            SSIM(ndx) = NaN;
        end
    end
    EvaluacionValidada.SSIM.Media=mean(SSIM(isfinite(SSIM)));
    EvaluacionValidada.SSIM.DesvTip=std(SSIM(isfinite(SSIM)));
    
%     %*********************Añadido por jpicazo 09022017*****************************
         % Average Difference (AD)
    AD = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx})
            %disp(['El tamano de AD(ndx) es: ' int2str(size(AD(ndx)))])
            %disp(['El tamano de Evaluaciones{ndx).AD es ' int2str(size(Evaluaciones{ndx}.AD))])
            AD(ndx)=Evaluaciones{ndx}.AD;
        else
            AD(ndx) = NaN;
        end
    end
    EvaluacionValidada.AD.Media=mean(AD(isfinite(AD)));
    EvaluacionValidada.AD.DesvTip=std(AD(isfinite(AD)));
    
    % Maximum difference (MD)
    MD = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx})
            MD(ndx)=Evaluaciones{ndx}.MD;
        else
            MD(ndx) = NaN;
        end
    end
    EvaluacionValidada.MD.Media=mean(MD(isfinite(MD)));
    EvaluacionValidada.MD.DesvTip=std(MD(isfinite(MD)));
    
    % Error Absoluto normalizado (NAE)
    NAE = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx}),
            NAE(ndx)=Evaluaciones{ndx}.NAE;
        else
            NAE(ndx) = NaN;
        end
    end
    EvaluacionValidada.NAE.Media=mean(NAE(isfinite(NAE)));
    EvaluacionValidada.NAE.DesvTip=std(NAE(isfinite(NAE)));
    
    % Normlized cross-correlation(NCC)
    NCC = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx}),
            NCC(ndx)=Evaluaciones{ndx}.NCC;
        else
            NCC(ndx) = NaN;
        end
    end
    EvaluacionValidada.NCC.Media=mean(NCC(isfinite(NCC)));
    EvaluacionValidada.NCC.DesvTip=std(NCC(isfinite(NCC)));
    
     % Structural content (SC)
    SC = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx}),
            SC(ndx)=Evaluaciones{ndx}.SC;
        else
            SC(ndx) = NaN;
        end
    end
    EvaluacionValidada.SC.Media=mean(SC(isfinite(SC)));
    EvaluacionValidada.SC.DesvTip=std(SC(isfinite(SC)));
    
    
    
    %******************************************************************************
    
    
    
    if isfield(Evaluaciones{1}, 'TiempoEntrenamiento')
      % Tiempo de entrenamiento
      TiempoEntrenamiento = zeros(1,NumDatos);
      for ndx=1:NumDatos
          if ~isempty(Evaluaciones{ndx}),
              TiempoEntrenamiento(ndx)=Evaluaciones{ndx}.TiempoEntrenamiento;
          else
              TiempoEntrenamiento(ndx) = NaN;
          end
      end
      EvaluacionValidada.TiempoEntrenamiento.Media=mean(TiempoEntrenamiento(isfinite(TiempoEntrenamiento)));
      EvaluacionValidada.TiempoEntrenamiento.DesvTip=std(TiempoEntrenamiento(isfinite(TiempoEntrenamiento)));
    end
    
    % Número de neuronas
    NumNeurons = zeros(1,NumDatos);
    for ndx=1:NumDatos
        if ~isempty(Evaluaciones{ndx}),
            NumNeurons(ndx)=Evaluaciones{ndx}.NumNeurons;
        else
            NumNeurons(ndx) = NaN;
        end
    end
    EvaluacionValidada.NumNeurons.Media=mean(NumNeurons(isfinite(NumNeurons)));
    EvaluacionValidada.NumNeurons.DesvTip=std(NumNeurons(isfinite(NumNeurons)));        
end

