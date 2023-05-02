%-- 20/04/22 14:21:07 --%
baboon = imread('Baboon.tiff');
load('Baboon.tiff.autoencoder.mat')
imshow(baboon)
ImgDoubleNormalizada = double(baboon)/255;  MuestrasOrig = reshape(shiftdim(ImgDoubleNormalizada,2),3,[]); Muestras = autoenc.encode(MuestrasOrig);
ImgProt = reshape(MuestrasOrig(1:3,:), ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
ImgSize=size(baboon);
ImgProt = reshape(MuestrasOrig(1:3,:), ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
ImgProt = reshape(Muestras(1:3,:), ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
ms = Muestras(1:3,:);
size(min(ms))
size(min(ms(:)))
ms = Muestras(1:3,:); ms = ms-min(ms(:)); ms = ms/max(ms(:));
ms = Muestras(1:3,:); for k=1:3; ms = ms-min(ms(k,:)); ms = ms/max(ms(k,:)); end;
ImgProt = reshape(ms, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
ms2 = autoenc.decode(Muestras);
ImgProt = reshape(ms2, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig);
Muestras2 = a2.encode(MuestrasOrig);
ms3 = autoenc.decode(Muestras2);
ms3 = a2.decode(Muestras2);
ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 0); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 1000); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 1000, 'UseGPU'); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 1000, 'UseGPU', 1); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
gpuDeviceTable
gpuDevice(2)
gpuDeviceTable
a2 = trainAutoencoder(MuestrasOrig, 1000, 'UseGPU', 1); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
gpuDevice()
gpuDevice(2)
a2 = trainAutoencoder(MuestrasOrig, 10, 'UseGPU', 1); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 10, 'UseGPU', 1);
Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
imshow(ImgProt);
close all
imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 100, 'UseGPU', 1); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a2 = trainAutoencoder(MuestrasOrig, 500, 'UseGPU', 1); Muestras2 = a2.encode(MuestrasOrig); ms3 = a2.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
a_nosparse_3 = trainAutoencoder(MuestrasOrig, 3 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_nosparse_3 = trainAutoencoder(MuestrasOrig, 3, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_nosparse_10 = trainAutoencoder(MuestrasOrig, 10, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_nosparse_10 = trainAutoencoder(MuestrasOrig, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_nosparse_100 = trainAutoencoder(MuestrasOrig, 100, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_nosparse_100 = trainAutoencoder(MuestrasOrig, 100, 'UseGPU', 1, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_nosparse_100 = trainAutoencoder(MuestrasOrig, 100, 'MaxEpochs', 5000, 'UseGPU', 1, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
Muestras2 = a_nosparse_3.encode(MuestrasOrig); ms3 = a_nosparse_3.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
Muestras2 = a_nosparse_10.encode(MuestrasOrig); ms3 = a_nosparse_10.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
Muestras2 = a_nosparse_100.encode(MuestrasOrig); ms3 = a_nosparse_100.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
Muestras2 = a_nosparse_3.encode(MuestrasOrig); ms3 = a_nosparse_3.decode(Muestras2); for k=1:3; ms3 = ms3-min(ms3(k,:)); ms3 = ms3/max(ms3(k,:)); end; ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); imshow(ImgProt);
imshow(baboon)
Muestras2 = a_nosparse_3.encode(MuestrasOrig); ms3 = a_nosparse_3.decode(Muestras2); for k=1:3; ms3 = ms3-min(ms3(k,:)); ms3 = ms3/max(ms3(k,:)); end; ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(ImgProt);; figure; imshow(baboon);
Muestras2 = a_nosparse_3.encode(MuestrasOrig); ms3 = a_nosparse_3.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(ImgProt);; figure; imshow(baboon);
Muestras2 = a_nosparse_100.encode(MuestrasOrig); ms3 = a_nosparse_3.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(ImgProt);; figure; imshow(baboon);
Muestras2 = a_nosparse_100.encode(MuestrasOrig); ms3 = a_nosparse_100.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(ImgProt);; figure; imshow(baboon);
Muestras2 = a_nosparse_100.encode(MuestrasOrig); ms3 = a_nosparse_100.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(baboon-ImgProt));
Muestras2 = a_nosparse_100.encode(MuestrasOrig); ms3 = a_nosparse_100.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(ImgProt);; figure; imshow(ImgDoubleNormalizada);
Muestras2 = a_nosparse_100.encode(MuestrasOrig); ms3 = a_nosparse_100.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada));
a_nosparse_3 = trainAutoencoder(MuestrasOrig, 3, 'ScaleData', 0, 'MaxEpochs', 5000, 'UseGPU', 1, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_sparse_3 = trainAutoencoder(MuestrasOrig, 3, 'ScaleData', 0, 'MaxEpochs', 5000, 'UseGPU', 1, 'ShowProgressWindow', 1);
a_nosparse_10 = trainAutoencoder(MuestrasOrig, 10, 'ScaleData', 0, 'MaxEpochs', 5000, 'UseGPU', 1, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
a_sparse_10 = trainAutoencoder(MuestrasOrig, 10, 'ScaleData', 0, 'MaxEpochs', 5000, 'UseGPU', 1, 'ShowProgressWindow', 1);
a_sparse_100 = trainAutoencoder(MuestrasOrig, 100, 'ScaleData', 0, 'MaxEpochs', 5000, 'UseGPU', 1, 'ShowProgressWindow', 1);
a_sparse_500 = trainAutoencoder(MuestrasOrig, 500, 'ScaleData', 0, 'MaxEpochs', 5000, 'UseGPU', 1, 'ShowProgressWindow', 1);
a_nosparse_100 = trainAutoencoder(MuestrasOrig, 100, 'ScaleData', 0, 'MaxEpochs', 5000, 'UseGPU', 1, 'SparsityRegularization', 0, 'SparsityProportion', 1, 'ShowProgressWindow', 1);
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada));
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_sparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_sparse_500; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_sparse_100; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_sparse_10; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_nosparse_10; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_nosparse_100; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_nosparse_10; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
ImgProt10=ImgProt;
aa=a_nosparse_100; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
figure; imshow(abs(imgProt-ImgProt10))
figure; imshow(abs(ImgProt-ImgProt10))
ImgProt100=ImgProt;
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
ImgProt3=ImgProt;
figure; imshow(abs(ImgProt3-ImgProt100))
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; hist(abs(ImgProt(:)-ImgDoubleNormalizada(:)));
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; hist(abs(ImgProt(:)-ImgDoubleNormalizada(:)));
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); zz=sum((ImgProt-ImgDoubleNormalizada).^2, 3);
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); zz=sqrt(sum((ImgProt-ImgDoubleNormalizada).^2, 3)); figure; hist(zz(:));
aa=a_nosparse_100; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); zz=sqrt(sum((ImgProt-ImgDoubleNormalizada).^2, 3)); figure; hist(zz(:));
aa=a_sparse_100; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); zz=sqrt(sum((ImgProt-ImgDoubleNormalizada).^2, 3)); figure; hist(zz(:));
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(ImgProt);
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ImgProt = reshape(Muestras2, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(ImgProt);
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_nosparse_100; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
aa=a_nosparse_3; Muestras2 = aa.encode(MuestrasOrig); ms3 = aa.decode(Muestras2); ImgProt = reshape(ms3, ImgSize(3), ImgSize(1), ImgSize(2)); ImgProt = shiftdim(ImgProt,1); figure; imshow(abs(ImgProt-ImgDoubleNormalizada)); figure; imshow(ImgProt); figure; imshow(ImgDoubleNormalizada);
close all
