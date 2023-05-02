function [OutputImage]=colorspace1(Conversion,Alpha,Beta,Gamma,InputImage)
% Convert from RGB (coded as uint8) to another color space, then ensure that the range of the
% three output color channels is from 0 to 255, and scale the channels (the
% range must still be from 0 to 255).

Params=[Alpha Beta Gamma];
if (min(Params)<0) || (max(Params)>1)
    error('The selected parameters are invalid. Only values in the interval [0,1] are allowed.');
end

if (~isempty(Conversion)),
    AuxImage=double(colorspace(Conversion,InputImage));
    
    switch Conversion
        case {'RGB->HSV','RGB->HSL'}
            OutputImage(:,:,1)=255*AuxImage(:,:,1)/360;
            OutputImage(:,:,2)=255*AuxImage(:,:,2);
            OutputImage(:,:,3)=255*AuxImage(:,:,3);
        case {'RGB->YCbCr'}
            % Nothing to do
            OutputImage=AuxImage;
        case {'RGB->Luv','RGB->Lab'}
            OutputImage(:,:,1)=255*AuxImage(:,:,1)/100;
            OutputImage(:,:,2)=255*(AuxImage(:,:,2)+100)/200;
            OutputImage(:,:,3)=255*(AuxImage(:,:,3)+100)/200;  
        otherwise
            error('Color space conversion not supported.');
    end
else
    % RGB->RGB case
    OutputImage=double(InputImage);
end

OutputImage(:,:,1)=Alpha*OutputImage(:,:,1);
OutputImage(:,:,2)=Beta*OutputImage(:,:,2);
OutputImage(:,:,3)=Gamma*OutputImage(:,:,3);