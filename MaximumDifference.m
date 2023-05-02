%Program for Maximum Difference Calculation

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

function MD = MaximumDifference(origImg, distImg)

origImg = mean(double(origImg),3);
distImg = mean(double(distImg),3);

error = origImg - distImg;

MD = max(max(error));