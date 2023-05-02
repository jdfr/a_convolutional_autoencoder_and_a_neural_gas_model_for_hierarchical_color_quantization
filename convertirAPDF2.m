% Pruebas Cuantificación de Imágenes para el GNG
clear all

Modelo = 'GHSOM';

% Leemos las imágenes del directorio en formato matriz
 d = dir(['./imagesOnly4/' '*.tiff']);
%d = dir('*.tiff');

% IMAGEN
for dataset=1:length(d),        
        
    open(d(dataset).name);
    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperOrientation','portrait');
    set(gcf,'PaperPositionMode','manual');
    set(gcf,'PaperSize',[12 10]);
    set(gcf,'PaperPosition',[0 0 12 10]);
    NomFichSalida = strrep(d(dataset).name,'.tiff','');
    NomFichSalida = strrep(NomFichSalida,'.fig','');
    NdxPunto = strfind(NomFichSalida,'.');    
    NomFichSalida(NdxPunto) = '_';    
    saveas(gcf,[NomFichSalida '.pdf'],'pdf');
    close;
end % for dataset
