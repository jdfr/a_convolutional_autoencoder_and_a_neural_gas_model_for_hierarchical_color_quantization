% Pruebas Clasificación GHPSOG
clear all
NumEpocas=2;
Tau=0.02;
MaxNeuro=20;
NumEntrenamientos = 10;

% Leemos los conjuntos de datos del directorio
d = dir('Datos*.mat');

% for dataset=4:4,
for dataset=1:length(d),
    
    fprintf('\nCONJUNTO DE DATOS: %s\n',d(dataset).name);
    load('ResultadosClasificacionGHPSOG.mat','Resultados');
    if ~isempty(Resultados{dataset})
        disp('Evitando repetir todos los entrenamientos del dataset')
        continue;
    end
    
    % Cargamos el conjunto de datos
    load(d(dataset).name,'Datos');
        
    % Cargamos los evaluaciones ya hechas
    load('EvaluacionesClasificacionGHPSOG.mat','Evaluaciones');    
    
    for NdxRepeticion=1:NumEntrenamientos,    
                     
        fprintf('\nENTRENAMIENTO %d\n',NdxRepeticion);
        if ~isempty(Evaluaciones{NdxRepeticion,dataset}),
            disp('Evitando repetir un entrenamiento')
            continue;
        end
        GruposReales=[];
        GruposEstimados=[];                
        
        % Entrenamientos
        EntrenamientoOk=1;
        for NdxClase=1:Datos.NumClases

            fprintf('\nClase %d\n',NdxClase);
            
            % Obtener todas las muestras de esta clase
            TodasMuestras=Datos.Muestras{NdxClase};
            % Sortear grupos
            Grupos=ceil(10*rand(size(TodasMuestras,2),1));
            % Muestras de entrenamiento y de test
            Muestras=TodasMuestras(:,find(Grupos~=1));
            NumMuestras=size(Muestras,2);
            MuestrasTest{NdxClase}=TodasMuestras(:,find(Grupos==1));
            if size(MuestrasTest{NdxClase},2)==0
                MuestrasTest{NdxClase}=TodasMuestras(:,1);
            end
            NumEtapas=NumMuestras*NumEpocas;           
            Hecho=0;
            Intentos=0;
            while Hecho==0
                try                    
                    Modelo{NdxClase} = MiEntrenarPHSOG(Muestras,NumEtapas,Tau,MaxNeuro,1,1);
                    fprintf('\nEntrenamiento Finalizado Clase %d\n',NdxClase);
                    Hecho=1;
%                     fprintf('\nEntrenamiento Hecho Clase %d\n',NdxClase);
                    if isempty(Modelo{NdxClase}),
                        EntrenamientoOk = 0;
                        fprintf('\nEntrenamiento No OK Clase %d\n',NdxClase);
                    end
                catch
                    disp('Error en PHSOG')                            
                    lasterror.message
                    lasterror.stack
                    Intentos=Intentos+1;
                    clear functions
                end
                Hecho=Hecho | (Intentos>9);
                if (Intentos>9)
                    EntrenamientoOk=0;
                end
            end
        end

        if EntrenamientoOk                    
            for NdxClase=1:Datos.NumClases
                DensidadTest=[];
                for NdxClase2=1:Datos.NumClases                    
                    [Basura,DensidadTest(:,NdxClase2)] = PSOGANLLMEX(MuestrasTest{NdxClase},Modelo{NdxClase2});
                    DensidadTest(:,NdxClase2)=DensidadTest(:,NdxClase2)+...
                                    log(size(Datos.Muestras{NdxClase2},2));

                end
                [Maximos,Indices]=max(DensidadTest,[],2);
                GruposReales=[ GruposReales NdxClase*ones(1,length(Indices))];
                GruposEstimados=[ GruposEstimados Indices'];
            end
            
            % Gardamos la evaluación del entrenamiento
            Evaluaciones{NdxRepeticion,dataset}=EvaluarClasificador(GruposReales,GruposEstimados);
            save('EvaluacionesClasificacionGHPSOG.mat','Evaluaciones');
        end
    end
    
    % Realizamos la validación cruzada
    Resultados{dataset}=ValidacionCruzadaClasificador(Evaluaciones(:,dataset)');
    save('ResultadosClasificacionGHPSOG.mat','Resultados');    
end

