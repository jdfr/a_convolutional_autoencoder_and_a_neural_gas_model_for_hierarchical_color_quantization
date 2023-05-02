% Análisis de la sensibilidad de los parámetros del GNF, donde se annalizan
% los 7 parámetros del modelo más el n° de épocas
clear all
rng('default')
Dimension = 5;
NumMuestras = 10000;
NumRepeticiones = 10;

% Generamos las muestras
Muestras = GenerateSamplesImg('ThreeBalls.jpg',NumMuestras);

% Parámetros
ParameterNames = {'\epsilon_b','\epsilon_n','a_{max}','\lambda','H_{max}','\alpha','d','Epochs'};
NumParameters = length(ParameterNames);
Parameters = cell(NumParameters,1);
Parameters{1} = 0.1:0.1:1;
Parameters{2} = 0.001:0.001:0.01;
Parameters{3} = 10:10:100;
Parameters{4} = [1,25,50,75,100,125,150,175,200,225];
Parameters{5} = 10:10:100; % n° máximo de neuronas
Parameters{6} = 0.1:0.1:1;
Parameters{7} = 0.1:0.1:1;
Parameters{8} = 1:1:10;
NumValues = length(Parameters{1});

% Medidas de Rendimiento
MSE = zeros(NumParameters,NumValues,NumRepeticiones);
PSNR = zeros(NumParameters,NumValues,NumRepeticiones);
DB = zeros(NumParameters,NumValues,NumRepeticiones);
Time = zeros(NumParameters,NumValues,NumRepeticiones);
NomFichSalida = ['GNF_Parametros'];

for NdxParameter=1:NumParameters,
        
    % The following values of the parameters are those considered in the
    % original GNG paper by Fritzke (1995)
    EpsilonB = 0.2;
    EpsilonN = 0.006;
    AMax = 50;
    Lambda = 100;
    HMax = 50;
    Alpha = 0.5;
    D = 0.995;
    NumEpocas = 2; % no considerado en el paper de Fritzke

    MyParameterName = ParameterNames{NdxParameter};
    fprintf('\nPARAMETER: %s',MyParameterName);
    MyParameter = Parameters{NdxParameter};
    
    for NdxValue=1:NumValues,
        
        MyValue = MyParameter(NdxValue);
        fprintf('\n\t%g ',MyValue);                

        % Conseguimos los parámetros
        switch NdxParameter,
            case 1
                EpsilonB = MyValue;
            case 2
                EpsilonN = MyValue;
            case 3
                AMax = MyValue;
            case 4
                Lambda = MyValue;
            case 5
                Hmax = MyValue;
            case 6
                Alpha = MyValue;
            case 7
                D = MyValue;
            case 8
                NumEpocas = MyValue;
        end
        NumPasos = NumEpocas*NumMuestras;
                
        for NdxRepeticion=1:NumRepeticiones,
            fprintf('.');
            % Entrenamiento GNF                                    
            tic;
            [Modelo] = TrainGNF(Muestras,HMax,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,NumPasos);
            Time(NdxParameter,NdxValue,NdxRepeticion) = toc;
            % save([NomFichSalida '.mat'],'Modelo');
            
            % Calculamos el MSE
            [Winners,Errors] = TestGNG(Modelo,Modelo.Samples);
            MSE(NdxParameter,NdxValue,NdxRepeticion) = mean(Errors);
            MaxI = max(max(Muestras)) - min(min(Muestras));
            PSNR(NdxParameter,NdxValue,NdxRepeticion) = 10*log10(MaxI^2/MSE(NdxParameter,NdxValue));
            DB(NdxParameter,NdxValue,NdxRepeticion) = db_index(Muestras',Winners,Modelo.Means');           
        end              
    end
    save([NomFichSalida '.mat'],'MSE','PSNR','DB','Time');
    
    % Dibujamos la gráfica
    errorbar(MyParameter,mean(squeeze(MSE(NdxParameter,:,:)),2),std(squeeze(MSE(NdxParameter,:,:)),0,2));
    xlabel(MyParameterName);    
    ylabel('MSE');
    grid on
    saveas(gcf,[NomFichSalida '_' strrep(MyParameterName,'\','') '.fig'],'fig');
    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperOrientation','portrait');
    set(gcf,'PaperPositionMode','manual');
    set(gcf,'PaperSize',[12 10]);
    set(gcf,'PaperPosition',[0 0 12 10]);
    saveas(gcf,[NomFichSalida '_' strrep(MyParameterName,'\','') '.pdf'],'pdf');  
    close all;
end
fprintf('\n');