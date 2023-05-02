% Script que lee ciertos modelos y saca la cuantificación de dichos modelos
% por capas

clear
clc

Campos={'MSE','PSNR','SSIM','AD','MD','NAE','NCC','SC','TiempoEntrenamiento'};
NumCampos = length(Campos);
NomFichModelos = 'ModelosCuantificacionDivergenciasBregman';
RutaImagenes = 'C:\smartechic\images\';
Divergences={'Squared Euclidean'};
NumDivergences = length(Divergences);
Datasets = {'Baboon','House','Lake','Lena'};
NumDatasets = length(Datasets);
NdxDivergence = 1;
MyDivergence = Divergences{NdxDivergence};

MiFichero = [NomFichModelos '.mat'];
if ~exist(['./' MiFichero],'file')
    disp('Error abriendo modelos');    
else
    % Cargamos los modelos ya entrenados
    load(MiFichero,'Modelos');
    Evaluaciones = cell(NumDatasets,4);
    Resultados = cell(NumDatasets);
    DatosForm = cell(NumDatasets,NumCampos,4);
    
    for NdxDataset=1:NumDatasets
        ImgOriginal = imread([RutaImagenes Datasets{NdxDataset} '.tiff']);
        ImgDoubleNormalizada = double(ImgOriginal)/255;
        MiModelo = Modelos{NdxDivergence,NdxDataset};
        for NdxLevel=1:4
            ModeloPodado = PruneGHBNG(MiModelo,NdxLevel);
            Centroids = GetCentroidsGHBNG(ModeloPodado);
            Winners = TestGHBNG(Centroids,ModeloPodado.Samples,MyDivergence);
            ImgProt = GetPrototypesImg(Centroids,Winners,size(ImgOriginal));
            
            % Evaluamos la compresión de la capa
            Evaluaciones{NdxDataset,NdxLevel} = evaluarCompresionImagen(ImgOriginal,ImgProt);
            Evaluaciones{NdxDataset,NdxLevel}.TiempoEntrenamiento = 0;
            Resultados{NdxDataset} = ValidacionCruzadaCompresion(Evaluaciones(NdxDataset,NdxLevel)');
            for NdxCampo=1:NumCampos
                MiCampo = getfield(Resultados{NdxDataset},Campos{NdxCampo});
                DatosForm{NdxDataset,NdxCampo,NdxLevel} = sprintf('%2.2f',MiCampo.Media);        
            end                       
            
%             % Guardamos la imagen de cuantificación
%             fig = figure;
%             set(fig,'name',['Podado_Bregman_' MyDivergence '_Capa_' num2str(NdxLevel) '_' Datasets{NdxDataset}]);
%             set(fig,'NumberTitle','off');
%             imshow(ImgProt);
%             saveas(gcf,['Podado_Bregman_' MyDivergence '_Capa_' num2str(NdxLevel) '_' Datasets{NdxDataset} '.fig'],'fig');      
% 
%             % Guardamos la imagen de diferencias ampliada 20 veces
%             fig = figure;
%             set(fig,'name',['Podado_Bregman_Diff_' MyDivergence '_Capa_' num2str(NdxLevel) '_' Datasets{NdxDataset}]);
%             set(fig,'NumberTitle','off');
%             ImgDif = abs(ImgDoubleNormalizada-ImgProt);
%             imshow(ImgDif);  
%             saveas(gcf,['Podado_Bregman_Diff_' MyDivergence '_Capa_' num2str(NdxLevel) '_' Datasets{NdxDataset} '.fig'],'fig');
        end
        close all
    end  
    
    for NdxLevel=1:4
        xlswrite('Medidas_Podado_Bregman.xlsx',[[{''} Campos]; [Datasets' DatosForm(:,:,NdxLevel)]],num2str(NdxLevel)); 
    end
end