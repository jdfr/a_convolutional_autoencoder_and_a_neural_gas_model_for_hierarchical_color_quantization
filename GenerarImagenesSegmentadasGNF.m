% Generar y escribe las imágenes binarias almacenadas en la variable imMask

Videos = {'Campus','Curtain','Escalator','Fountain','LevelCrossing','OneShopOneWait1cor',...
    'Video2','Video4','WaterSurface','Lobby','LightSwitch'};
EspaciosColor = {'HSL','HSV','Lab','Luv','RGB','YCbCr'};
ListaFrames = {'2348','23854','4787','1489','440','370','550','690','1559',...
    '2440','1880'};
% Correspondencia = [20 18 20 18 136 5 246 187 8 20 16];

for NdxEspacioColor=1:length(EspaciosColor),
    
    fprintf('\nEspacio Color: %s\n',EspaciosColor{NdxEspacioColor});
    for NdxVideo=1:length(Videos),
        
        fprintf('\nVídeo: %s\n',Videos{NdxVideo});
        MiEspacioColor = EspaciosColor{NdxEspacioColor};
        MiVideo = Videos{NdxVideo};    
        d = dir([MiEspacioColor '_' MiVideo '_*.mat']);        
        if isempty(d),
            fprintf('\tFichero no encontrado\n');
        else
            NomFich = d(1).name;
            load(NomFich,'imMask');
            figure, imshow(imMask);
            imwrite(imMask,strrep(NomFich,'.mat','.png'),'png');
            close
        end
    end
end

