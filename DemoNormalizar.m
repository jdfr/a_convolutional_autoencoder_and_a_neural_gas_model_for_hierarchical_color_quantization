clear all
close all
ColorSpaces = {'HSL','HSV','Lab','Luv','RGB','YCbCr'};

%OriginalImg=imread('peppers.png');
OriginalImg=uint8(256*rand(512,512,3));

for NdxSpace=1:numel(ColorSpaces)
    MyColorSpace=ColorSpaces{NdxSpace};
    fprintf('Espacio de color: %s\r',MyColorSpace);
    switch MyColorSpace
        case 'RGB'
            ConvertedImg=OriginalImg;
        otherwise
            ConvertedImg=colorspace(sprintf('RGB->%s',MyColorSpace),OriginalImg);    
    end
    ConvertedNormImg=NormalizarEspColor(double(ConvertedImg),MyColorSpace);
    SamplesImg=reshape(ConvertedNormImg,[size(ConvertedNormImg,1)*size(ConvertedNormImg,2) size(ConvertedNormImg,3)]);
    minmax(SamplesImg')
end