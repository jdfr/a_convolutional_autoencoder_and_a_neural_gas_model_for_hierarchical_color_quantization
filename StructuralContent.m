%Program for Structural Content Calculation

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

function SC = StructuralContent(origImg, distImg)

origImg = mean(double(origImg),3);
distImg = mean(double(distImg),3);

SC = sum(sum(origImg .* origImg)) / sum(sum(distImg .* distImg));