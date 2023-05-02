%Program for Normalized Cross Correlation Calculation

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

function NK = NormalizedCrossCorrelation(origImg, distImg)

origImg = mean(double(origImg),3);
distImg = mean(double(distImg),3);

NK = sum(sum(origImg .* distImg)) / sum(sum(origImg .* origImg));