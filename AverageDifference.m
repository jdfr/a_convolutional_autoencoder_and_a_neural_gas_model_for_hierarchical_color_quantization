%Program for Average Difference Calculation

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

function AD = AverageDifference(origImg, distImg)

origImg = mean(double(origImg),3);
distImg = mean(double(distImg),3);

[M N] = size(origImg);
error = origImg - distImg;

AD = sum(sum(error)) / (M * N);