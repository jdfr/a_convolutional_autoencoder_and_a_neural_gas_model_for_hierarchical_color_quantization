function Modelo = initializeSOMModel(Modelo,frames)


NumFilasImg = Modelo.NumFilasImg;
NumColsImg = Modelo.NumColsImg;
NumColsMapa = Modelo.NumColsMapa;
NumFilasMapa = Modelo.NumFilasMapa;

Muestras = mean(frames,4);

R=reshape(Muestras(:,:,1),[1 1 NumFilasImg NumColsImg]);
G=reshape(Muestras(:,:,2),[1 1 NumFilasImg NumColsImg]);
B=reshape(Muestras(:,:,3),[1 1 NumFilasImg NumColsImg]);
Modelo.Mu=zeros(3,NumFilasMapa,NumColsMapa,NumFilasImg,NumColsImg);    
Modelo.Mu(1,:,:,:,:)=repmat(R,[NumFilasMapa NumColsMapa 1 1]);
Modelo.Mu(2,:,:,:,:)=repmat(G,[NumFilasMapa NumColsMapa 1 1]);
Modelo.Mu(3,:,:,:,:)=repmat(B,[NumFilasMapa NumColsMapa 1 1]);

%Hallar una estimación para Sigma2
DifMuestras = zeros(size(frames,1),size(frames,2),3);
for i=1:size(frames,4)
    DifMuestras = DifMuestras + (Muestras-double(frames(:,:,:,i))).^2;
end

DifMuestras = (DifMuestras./size(frames,4));


DifMuestras = mean(DifMuestras,3);

DifMuestras=reshape(DifMuestras,[1 1 NumFilasImg NumColsImg]);

Modelo.Sigma2=zeros(NumFilasMapa,NumColsMapa,NumFilasImg,NumColsImg);      
Modelo.Sigma2 =repmat(DifMuestras,[NumFilasMapa NumColsMapa 1 1]);
    