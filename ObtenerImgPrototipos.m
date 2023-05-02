function ImgProt = ObtenerImgPrototipos(W,Ganadoras,s)

% Asignamos a cada entrada su protipo
% prototipos = zeros(size(W,1),size(s.m,2));
prototipos = W(:,Ganadoras);

% Redimensionamos el vector para ponerlo como imagen
ImgProt = reshape(prototipos(1:3,:), s.dim(3), s.dim(1), s.dim(2));
ImgProt = shiftdim(ImgProt,1);