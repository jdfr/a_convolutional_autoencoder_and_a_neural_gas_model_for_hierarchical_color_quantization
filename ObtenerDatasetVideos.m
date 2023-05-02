% Obtiene un dataset a partir de N frames para cada vídeo y espacio de color
clear all;

NumBackgroundFrames = 100;
ColorSpaces = {'HSL','HSV','Lab','Luv','RGB','YCbCr'};
NumColorSpaces = length(ColorSpaces);
Mu = 2; % penalization parameter for some dataset features

%% VIDEOS TO BE PROCESSED
Videos = {'Campus','Curtain','Escalator','Fountain','LevelCrossing','OneShopOneWait1cor',...
    'Video2','Video4','WaterSurface','Lobby','LightSwitch'};
% Videos = {'Campus','Curtain','Fountain','LevelCrossing',...
%     'Video2','Video4','WaterSurface','Lobby'};
NumVideos = length(Videos);
PathVideos = '../../Videos/';
SubPathFrames = '/frames/f%07d.bmp';
SubPathFramesLightSwitch = '/frames/f%07d.jpg';
SubPathGT = '/GT/GT%07d.bmp';
DeltaFrames = [999,20999,1397,999,0,0,0,0,999,999,0];
% DeltaFrames = [999,20999,999,0,0,0,999,999];
NumFrames = [1438,2963,3417,523,500,1376,749,819,632,1545,2799];
% NumFrames = [1438,2963,523,500,749,819,632,1545];
GT = [20,20,20,20,163,11,444,316,20,20,21];
% GT = [20,20,20,163,444,316,20,20];
PrimerFrameGT = [1199,22755,1398,1152,275,0,253,273,1480,1152,666];

Data = [];
for NdxColorSpace=1:NumColorSpaces,
       
    MyColorSpace = ColorSpaces{NdxColorSpace};
    fprintf('\nESPACIO COLOR: %s\n',MyColorSpace);
    switch MyColorSpace,
        case {'RGB'}
            MyColorSpaceConversion = '';
        otherwise
            MyColorSpaceConversion = ['RGB->' MyColorSpace];
    end 
    
    for NdxVideo=1:NumVideos,        

        MyVideo = Videos{NdxVideo};
        fprintf('\n\tVIDEO: %s\n',MyVideo);
        PathMyVideo = [PathVideos MyVideo SubPathFrames];
        if NdxVideo==11, % jpg instead of bmp extension
            PathMyVideo = [PathVideos MyVideo SubPathFramesLightSwitch];
        end
        
        % Store the first frames belonging to the background
        NdxFrameInicio = PrimerFrameGT(NdxVideo) - NumBackgroundFrames;
        if NdxFrameInicio <= DeltaFrames(NdxVideo),
            NdxFrameInicio = DeltaFrames(NdxVideo)+1;
        end
        fprintf('\t\tFrames desde %d hasta %d (Primer Frame=%d)\n',NdxFrameInicio,NdxFrameInicio+NumBackgroundFrames-1,DeltaFrames(NdxVideo)+1);
%         MyFrame = imread(sprintf(PathMyVideo,DeltaFrames(NdxVideo)+1));        
        MyFrame = imread(sprintf(PathMyVideo,NdxFrameInicio));
        if ~isempty(MyColorSpaceConversion),
            MyFrame = colorspace(MyColorSpaceConversion,MyFrame); 
            MyFrame(isnan(MyFrame)) = 0;
        end
        FirstFrames = zeros(size(MyFrame,1),size(MyFrame,2),size(MyFrame,3),NumBackgroundFrames);
        FirstFrames(:,:,:,1) = MyFrame;             
        for NdxFrame=2:NumBackgroundFrames,
                        
            NdxFrameInicio = NdxFrameInicio + 1;
%             MyFrame = imread(sprintf(PathMyVideo,DeltaFrames(NdxVideo)+NdxFrame));
            MyFrame = imread(sprintf(PathMyVideo,NdxFrameInicio));
            if ~isempty(MyColorSpaceConversion),
                MyFrame = colorspace(MyColorSpaceConversion,MyFrame);
                MyFrame(isnan(MyFrame)) = 0;
            end
            FirstFrames(:,:,:,NdxFrame) = MyFrame;
        end
            
        % Obtain the dataset as the mean of the first frames
%         MyFrame = mean(FirstFrames,4);
        MyFrame = median(FirstFrames,4);
        MyFrame = NormalizarEspColor(double(MyFrame), MyColorSpace);
        MyMatrixFrame = reshape(shiftdim(MyFrame,2),3,[]);            
        [i,j] = ind2sub([size(MyFrame,1) size(MyFrame,2)],[1:length(MyMatrixFrame)]);
        Data = [MyMatrixFrame;Mu*NormalizeData(i);Mu*NormalizeData(j)];           
        
        save(['Dataset_' MyColorSpace '_' MyVideo '.mat'],'Data'); 
        Data = [];
    end      
end
        