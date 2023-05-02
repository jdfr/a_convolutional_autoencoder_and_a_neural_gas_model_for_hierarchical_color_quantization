function I = desnormalizar(In, space_color)

if strcmpi(space_color, 'LAB') == 1
    I(:,:,1) = In(:,:,1)*100;
    I(:,:,2) = (In(:,:,2)*(128*2) - 128);
    I(:,:,3) = (In(:,:,3)*(128*2) - 128);
elseif strcmpi(space_color, 'RGB') == 1
    I(:,:,1) = In(:,:,1)*255;
    I(:,:,2) = In(:,:,2)*255;
    I(:,:,3) = In(:,:,3)*255;
elseif strcmpi(space_color, 'YCC') == 1
    I(:,:,1) = (In(:,:,1)*(235-16) + 16);
    I(:,:,2) = (In(:,:,2)*(246-16) + 16);
    I(:,:,3) = (In(:,:,3)*(246-16) + 16);
end

