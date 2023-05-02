function [Eval] = evaluarCompresionImagenCompleto(I,Ic)

% Desnormalizamos la imagen y la convertimos a uint8
if ~isa(Ic, 'uint8')
  Ic = uint8(desnormalizar(Ic,'RGB'));
end

% MSE
D = (double(I)-double(Ic)).^2;
%         MSE  = sum(D(:))/numel(I);
MSE  = sum(D(:))/(size(I,1)*size(I,2));

% PSNR
PSNR = 10*log10((3*255*255)/MSE);

% SSIM
MSSIM = zeros(1,3);
[MSSIM(1) SSIM_MAP] = ssim_index(I(:,:,1), Ic(:,:,1));
[MSSIM(2) SSIM_MAP] = ssim_index(I(:,:,2), Ic(:,:,2));
[MSSIM(3) SSIM_MAP] = ssim_index(I(:,:,3), Ic(:,:,3));

% 

Eval.MSE = MSE;
Eval.PSNR = PSNR;
Eval.SSIM = mean(MSSIM);
Eval.AD = AverageDifference(I,Ic);
% disp (['El tamano de la matriz Eval.AD es: ' int2str(size(Eval.AD))])
% %disp(['Evaluacion' Eval.AD])
Eval.MD = MaximumDifference(I,Ic);
Eval.NAE = NormalizedAbsoluteError(I,Ic);
Eval.NCC = NormalizedCrossCorrelation(I,Ic);
Eval.SC = StructuralContent(I,Ic);
