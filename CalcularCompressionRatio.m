% Script para calcular el Compression Ratio para la revisión del SOCO 2021
% Ejecutarse en el directorio GHBNG/Pruebas Cuantificación/
Models = {'GHNG','GHSOM'};
Datasets = {'baboon','house','lake','lena'};
%Tamanyos = [230427,154605,168459,148279];
ByteSize = 786572;
NumPixeles = 512*512;


% Calculamos el Compression Ratio para los modelos GHNG y GHSOM
for i=1:length(Models)
    fprintf(['\nModel ' Models{i} '\n']);
    for j=1:length(Datasets)
        fprintf(['\tImage ' Datasets{j}]);
        NomFichModelo = ['Modelo' Models{i} '_' Datasets{j} '.tiff.mat'];
        load(NomFichModelo,'Modelo');
        if strcmp(Models{i},'GHNG')
            Centroids = GetCentroidsGHNG(Modelo);                        
        elseif strcmp(Models{i},'GHSOM')
            Centroids = GetCentroidsGHSOM(Modelo); 
        end 
        %Tasa = Tamanyos(j)/size(Centroids,2);
        NumNeurons = size(Centroids,2);
        CompressedByteSize = NumPixeles*(ceil(log2(NumNeurons))/8);
        CR = ByteSize/CompressedByteSize;
        
        fprintf(' Compression Ratio (CR): %6.2f (%d/%d) (Neurons=%d)\n',CR,ByteSize,CompressedByteSize,NumNeurons);
    end
end