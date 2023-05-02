% Pruebas Cuantificación de Imágenes para el GNG
clear all
close all
warning off
rng('default');

NumEpocas=2;
NumEntrenamientos = 10;
MaxNeurons = 20; % Maximum number of neurons in each graph
Tau = (0:0.05:0.2);
RutaImagenes = 'images/';

% The following values of the parameters are those considered in the
% original GNG paper by Fritzke (1995)
Lambda = 100;
EpsilonB = 0.2;
EpsilonN = 0.006;
Alpha = 0.5;
AMax = 50;
D = 0.995;

% Leemos las imágenes del directorio en formato matriz
d = dir([RutaImagenes '*RGB_s.mat']);
NumDataSets = length(d);
fprintf('NumDataSets=%d\n',NumDataSets);

MyArrayID=getenv('SLURM_ARRAYID');
if ~isempty(MyArrayID)
     ArrayIDNumber=sscanf(MyArrayID,'%d');
     fprintf('\r\nTask %d starting.\r\n',ArrayIDNumber);
     IsPicasso=1;
else
     ArrayIDNumber=35;
     IsPicasso=0;
end
dataset = mod(ArrayIDNumber-1,NumDataSets)+1;
NdxTau = floor((ArrayIDNumber-1)/NumDataSets)+1;
NomFichResultados = ['ResultadosCuantificacionGNG_' num2str(dataset) '_' num2str(NdxTau) '.mat'];
NomFichEvaluaciones = ['EvaluacionesCuantificacionGNG_' num2str(dataset) '_' num2str(NdxTau) '.mat'];
NomFichModelos = ['ModelosCuantificacionGNG_' num2str(dataset) '_' num2str(NdxTau) '.mat'];
NomFichModelosGHNG = ['ModelosCuantificacionGHNG_' num2str(dataset) '_' num2str(NdxTau) '.mat'];
     
% Cargamos la imagen original
ind = strfind(d(dataset).name,'_');
NomFich = d(dataset).name(1:ind-1);
fprintf('\nIMAGEN: %s\n',NomFich); 
load([RutaImagenes d(dataset).name],'s');
ImgOriginal = s.frame;
Muestras = s.m;
NumPasos = size(Muestras,2)*NumEpocas;  

MiTau = Tau(NdxTau);
fprintf('\nTAU = %g\n',MiTau);                                              
Evaluaciones = cell(1,NumEntrenamientos);
            
load(NomFichModelosGHNG,'Modelos');
ModeloGHNG = Modelos;
if isempty(ModeloGHNG),
    fprintf('\nModelo GHNG vacío\n');            
else
    MejorModelo = [];
    
    for NdxRepeticion=1:NumEntrenamientos,    

        % Obtenemos el nº de neuronas hojas del mejor modelo GHNG para
        % ese Tau y esa imagen
        [~,NumNeuronasHoja] = ObtenerNumeroNeuronasGHNG(ModeloGHNG);
        fprintf('Número Hojas=%d\n',NumNeuronasHoja);
                
        EntrenamientoOk=1;
        Hecho=0;
        Intentos=0;
        while Hecho==0
            try               
                tic;                    
                Modelo = TrainGNG(Muestras,NumNeuronasHoja,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
                CpuTime = toc;
                fprintf('\nEntrenamiento Finalizado\n');
                Hecho=1;
                if isempty(Modelo),
                    EntrenamientoOk = 0;
                    fprintf('\nEntrenamiento No OK\n');
                end
            catch
                disp('Error en GNG')                  
%                 lasterror.message
%                 lasterror.stack
                Intentos=Intentos+1;
                clear functions
            end
            Hecho=Hecho | (Intentos>9);
            if (Intentos>9)
                EntrenamientoOk=0;
            end
        end % while                        

        if EntrenamientoOk,

            % Obtenemos la imagen de los prototipos
            Centroids = Modelo.Means;
            Winners = Modelo.Winners;
            ImgProt = ObtenerImgPrototipos(Centroids,Winners,s);

            % Evaluamos la compresión hecha                                        
            Evaluaciones{NdxRepeticion} = evaluarCompresionImagen(ImgOriginal,ImgProt);
            Evaluaciones{NdxRepeticion}.TiempoEntrenamiento = CpuTime;
            save(NomFichEvaluaciones,'Evaluaciones');

            % Obtenemos el mejor modelo (el de máximo PSNR)
            if isempty(MejorModelo),
                MaximoPSNR = Evaluaciones{NdxRepeticion}.PSNR;
                MejorModelo = Modelo;
            elseif Evaluaciones{NdxRepeticion}.PSNR > MaximoPSNR,
                MaximoPSNR = Evaluaciones{NdxRepeticion}.PSNR;
                MejorModelo = Modelo;
            end
        end    
    end % for NdxRepeticion                        

    % Realizamos la validación cruzada
    Resultados = ValidacionCruzadaCompresion(Evaluaciones(:)');
    save(NomFichResultados,'Resultados');
    Modelos = MejorModelo;
    save(NomFichModelos,'Modelos');
end
