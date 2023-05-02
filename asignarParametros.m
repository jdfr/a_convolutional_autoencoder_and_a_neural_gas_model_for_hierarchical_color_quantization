function Parametros = asignarParametros(cadena)

% Parametros generales
Parametros.Captura = 0;
Parametros.Imagenes = 1;
Parametros.IntervaloImagenes = 1;
Parametros.PostProcesado = 1;
Parametros.NumOpenClose = 0;
Parametros.FillHoles = 1;
Parametros.RemoveObjects = 1;
Parametros.MinArea = 10;
Parametros.Traza = 0;
Parametros.Visualizacion = 0;
Parametros.Tracking = 0;
Parametros.Secuencia = '';
Parametros.Tiempo = [];
Parametros.Directorio = [];
Parametros.CadenaParam = [];
Parametros.SpaceColor = {'RGB'}; %'RGB','YCbCr','YPbPr','PhotoYCC' 

% Ponderación de componentes
Parametros.Alpha = 1/3;
Parametros.Beta = 1/3;
Parametros.Gamma = 1/3;


switch cadena
     case 'fgd'
%%%%%%%%%%%%%%%
% %   'c'  == "color", a three-component red/green/blue vector.
% %           We use histograms of these to model the range of
% %           colors we've seen at a given background pixel.
% % 
% %   'cc' == "color co-occurrence", a six-component vector giving
% %           RGB color for both this frame and preceding frame.
% %           We use histograms of these to model the range of
% %           color CHANGES we've seen at a given background pixel.
 %%%%%%%%%%%%%%
        Parametros.alpha1=0.1;      %How quickly we forget old background pixel values seen.  Typically set to 0.1
        Parametros.alpha2=0.005;    %"Controls speed of feature learning". Depends on T. Typical value circa 0.005.
        Parametros.alpha3= 0.1;     %Alternate to alpha2, used (e.g.) for quicker initial convergence. Typical value 0.1.	
        Parametros.delta= 2;        %Affects color and color co-occurrence quantization, typically set to 2.	
        Parametros.holes=0;         %If TRUE we ignore holes within foreground blobs. Defaults to TRUE.
        Parametros.Lc=128;          %Quantized levels per 'color' component. Power of two, typically 32, 64 or 128.128
        Parametros.N1c=15;          %Number of color vectors used to model normal background color variation at a given pixel.15
        Parametros.N2c=25;          %Number of color vectors retained at given pixel.  Must be > N1c, typically ~ 5/3 of N1c.25	
        
        %Used to allow the first N1c vectors to adapt over time to changing background.
        
        Parametros.Lcc=64;          %Quantized levels per 'color co-occurrence' component.  Power of two, typically 16, 32 or 64.64	
        Parametros.N1cc=25;         %Number of color co-occurrence vectors used to model normal background color variation at a given pixel.25
        Parametros.N2cc=40;         %Number of color co-occurrence vectors retained at given pixel.  Must be > N1cc, typically ~ 5/3 of N1cc.40
        %Used to allow the first N1cc vectors to adapt over time to changing background.
        
        Parametros.minArea=15;      %Discard foreground blobs whose bounding box is smaller than this threshold.15
        Parametros.T= 0.9;          %"A percentage value which determines when new features can be recognized as new background." (Typically 0.9).
        Parametros.morphing=0;      %Number of erode-dilate-erode foreground-blob cleanup iterations.0
     case 'mog'
         
        Parametros.win_size=100;        %100 
        Parametros.n_gauss=5;           %5
        Parametros.bg_threshold=0.7;    %0.7
        Parametros.std_threshold=2.5;   %2.5
        Parametros.weight=0.01;         %0.05      
        Parametros.variance=30;         %30
        Parametros.minArea=15.0;        %15.0
 
     case 'ae'
        Parametros.NumMuestras = 100;
        Parametros.Ruido = [0 0 0];
        Parametros.EpsilonZero = 0.01;
        Parametros.H = 2;
        Parametros.RuidoAutomatico = 1;
        Parametros.Z = 250; 
        Parametros.NumProcesos = 4;
     case 'mgus'
        Parametros.NumMuestras = 200;
        Parametros.Ruido = [0 0 0];
        Parametros.EpsilonZero = 0.01;
        Parametros.H = 2;
        Parametros.RuidoAutomatico = 1;
        Parametros.Z = 250;
        Parametros.NumProcesos = 4;
     case 'som'
        Parametros.NumFilasMapa = 1;
        Parametros.NumColsMapa = 12;
        Parametros.ProbAPrioriUnif = 0.1;
        Parametros.StepSize = 0.01;
        Parametros.TasaAprendizaje = 0.01;
        Parametros.FramesIni = 100; 
        Parametros.RadioVecindad = 0.1;
        Parametros.NumMuestras = 200;
        % Valor elevado al cuadrado: 4^2
        Parametros.Ruido = 1;
        Parametros.LimiteSigma2 = 2.77;
        
     case 'ann'
        %parametros = [NumMaxNeuronas MaxRadioNeurona MinRadioNeurona T LEARNING_RATE L PropSolapamiento PropActivacionAnexas IniProcesoUnion FrecuenciaProcesoUnion]
        Parametros.NumMaxNeuronas = 16;
        Parametros.MaxRadioNeurona = 60;
        Parametros.MinRadioNeurona = 15;
        Parametros.T = 0.7;
        Parametros.LearningRate = 0.05;
        Parametros.L = 75;
        Parametros.PropSolapamiento = 0.9;
        Parametros.PropActivacionAnexas = 0.01;
        Parametros.IniProcesoUnion = 50;
        Parametros.FrecuenciaProcesoUnion = 10;
        Parametros.LAB = 0;
        Parametros.Regionalizacion = 0;
        Parametros.Frecuencia_Regionalizacion = 25;
        Parametros.Distancia_UnionRegiones = 10;
     
     case 'sobs'
        Parametros.n = 3; %(square root of) number of weight vectors for each pixel. Default 3
        Parametros.K = 200; %Number of initial frames for calibration. Default 200
        Parametros.e1 = 0.1; %Distance threshold e1 for calibration phase (eqn. (2)).Default 0.1
        Parametros.e2 = 0.03; %Distance threshold e2 for online phase (eqn. (2)). Default 0.03
        Parametros.c1 = 1.0; %Learning rate c1 for calibration phase (eqn. (4)). Default 1.0
        Parametros.c2 = 0.05; %Learning rate c2 for online phase (eqn. (4)) Default 0.05
        Parametros.g = 0.7; %Value for g in eqn. (5). Default 0.7
        Parametros.b = 1.0; %Value for b in eqn. (5). Default 1.0
        Parametros.tS = 0.1; %Value for tS in eqn. (5). Default 0.1
        Parametros.tH = 10.0; %Value for tH in eqn. (5). Default 10.0
         
     case 'codebook'
         Parametros.modMin0 = 10;                %Por defecto 3
         Parametros.modMin1 = 10;                %Por defecto 3
         Parametros.modMin2 = 10;                %Por defecto 3
         Parametros.modMax0 = 10;               %Por defecto 10
         Parametros.modMax1 = 10;               %Por defecto 10
         Parametros.modMax2 = 10;               %Por defecto 10
         Parametros.cbBounds0 = 10;             %Por defecto 10
         Parametros.cbBounds1 = 10;             %Por defecto 10
         Parametros.cbBounds2 = 10;             %Por defecto 10
         Parametros.framesEntrenamiento = 300;  %Por defecto 300

    case 'eigbg'
         Parametros.lowthreshold = 225;                         %Por defecto 15*15
         Parametros.highthreshold = 2*Parametros.lowthreshold;  %Por defecto 2*Parametros.lowthreshold;
         Parametros.historysize = 100;                          %Por defecto 100
         Parametros.embeddeddim = 20;                           %Por defecto 20
         
     case 'gmm'
         %Significa la varianza que indica si la entrada
         %esta dentro de la distribucion o no 
         % (((x-mu)^2)/var) < lowthreshold
         Parametros.lowthreshold = 9;                           %Por defecto 3*3 
         Parametros.highthreshold = 2*Parametros.lowthreshold;  %Por defecto 2*Parametros.lowthreshold;
         Parametros.alpha = 0.001;                              %Por defecto 0.001
         % Numero de distribuciones a usar
         Parametros.maxmodes = 3;                               %Por defecto 3
         Parametros.bgthreshold = 0.8;                         %Por defecto 0.75
         Parametros.variance = 36;                              %Por defecto 36
     case 'amf'
         % Umbral fijo = lowthreshold
         % (DifR < lowthreshold) && (DifG < lowthreshold) && (DifB <
         % lowthreshold)
         Parametros.lowthreshold = 9;                           %Por defecto 3.0f*3.0f
         Parametros.highthreshold = 2*Parametros.lowthreshold;  %Por defecto 2*Parametros.lowthreshold;
         Parametros.samplingrate = 7;                           %Por defecto 7
         Parametros.learningframes = 30;                        %Por defecto 30
     case 'mean'
         % Umbral fijo = lowthreshold
         % (DifR^2+DifG^2+DifB^2 < lowthreshold)
         Parametros.lowthreshold = 3*30*30;                     %Por defecto 3*30*30
         Parametros.highthreshold = 2*Parametros.lowthreshold;  %Por defecto 2*Parametros.lowthreshold;
         Parametros.alpha = 10^-6;                              %Por defecto 1e-6f
         Parametros.learningframes = 30;                        %Por defecto 30
     case 'mediod'
         Parametros.lowthreshold = 30;                          %Por defecto 30
         Parametros.highthreshold = 2*Parametros.lowthreshold;  %Por defecto 2*Parametros.lowthreshold;
         Parametros.weight = 5;                                 %Por defecto 5
         Parametros.historysize = 16;                           %Por defecto 16
         Parametros.samplingrate = 5;                           %Por defecto 5   
         
     case 'agmm'
          %Significa la varianza que indica si la entrada
         %esta dentro de la distribucion o no 
         % (((x-mu)^2)/var) < lowthreshold
         Parametros.lowthreshold = 25;                          %Por defecto 5f*5f
         Parametros.highthreshold = 2*Parametros.lowthreshold;  %Por defecto 2*Parametros.lowthreshold;
         Parametros.alpha = 0.001;                              %Por defecto 0.001f
         % Numero MAXIMO de distribuciones a usar
         Parametros.maxmodes = 3;                               %Por defecto 3
         Parametros.bgthreshold = 0.75;                         %Por defecto 0.75
         Parametros.variance = 36;                              %Por defecto 36
         Parametros.learningframes = 30;                        %Por defecto 30
     case 'bodids'
         Parametros.k = 15;        %Frames de entrenamiento. Por defecto 200
         Parametros.l = 10;         %Tamano de la ventana.Por defecto 30 
         Parametros.alpha = 0.1;   %Por defecto 0.05
         Parametros.gamma = 0.1;    %Por defecto 0.1
     
    case 'wren'
         %Significa la varianza que indica si la entrada
         %esta dentro de la distribucion o no 
         % (((x-mu)^2)/var) < lowthreshold
         Parametros.lowthreshold = 3.5*3.5;                     %Por defecto 3.5f*3.5f
         Parametros.highthreshold = 2*Parametros.lowthreshold;  %Por defecto 2*Parametros.lowthreshold;
         Parametros.alpha = 0.01;                              %Por defecto 0.005f
         Parametros.learningframes = 30;                        %Por defecto 30
         Parametros.variance = 36;                              %Por defecto 36
 end