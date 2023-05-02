function PerformanceMeasures = TestGNFSegmentation(Model,TrainingWinners,TrainingErrors,ColorSpaceName,VideoName,NumFrames,NumGTFrames,DeltaFrames,VideoPath,GTPath,Mu)

MinArea = 10;
PerformanceMeasures = zeros(7,0);
Cputime = 0;
contGT = 0;

switch ColorSpaceName,
    case {'RGB'}
        MyColorSpaceConversion = '';
    otherwise
        MyColorSpaceConversion = ['RGB->' ColorSpaceName];
end

for NdxFrame=1:NumFrames,
    
    if (mod(NdxFrame,100)==0),
        fprintf('\t\t\tFrame %d\n',NdxFrame);
    end
    
    if exist(sprintf(GTPath,DeltaFrames+NdxFrame),'file')
        % Obtain the test samples
        MyFrame = imread(sprintf(VideoPath,DeltaFrames+NdxFrame));     
        if ~isempty(MyColorSpaceConversion),
            MyFrame = colorspace(MyColorSpaceConversion,MyFrame); 
            MyFrame(isnan(MyFrame)) = 0;
        end
        MyFrame = NormalizarEspColor(double(MyFrame), ColorSpaceName);
        MyMatrixFrame = reshape(shiftdim(MyFrame,2),3,[]);            
        [i,j] = ind2sub([size(MyFrame,1) size(MyFrame,2)],[1:length(MyMatrixFrame)]);
        TestSamples = [MyMatrixFrame;Mu*NormalizeData(i);Mu*NormalizeData(j)];

        % DETECT THE FOREGROUND
        tic;
        [TestWinners,TestErrors] = TestGNG(Model,TestSamples);
        % Criterion 1
    %     ForegroundPixels = ((TrainingWinners == TestWinners) == 0);
        % Criterion 2 (more restrictive)    
        ErrorDiff = abs(TrainingErrors - TestErrors);
        MyThreshold = nanmean(ErrorDiff)+nanstd(ErrorDiff);
    %     BackgroundPixels = (ErrorDiff <= mean(ErrorDiff));
    %     BackgroundPixels = (ErrorDiff > (mean(ErrorDiff)+std(ErrorDiff)));
        ForegroundPixels = (ErrorDiff > MyThreshold);

        % Foreground pixels are those that fulfill both criteria
    %     ForegroundPixels = (ForegroundPixels - BackgroundPixels) == 1;
        Cputime = Cputime + toc;
        imMask = reshape(ForegroundPixels,size(MyFrame,1),size(MyFrame,2));       
        imMask = double(imMask >= 0.5);

        % Fill holes (size 1) and remove objects with minimum area
        imMask = bwmorph(imMask,'majority');
%         imMask = bwmorph(imMask,'close',5);
%         imMask = bwmorph(imMask,'open',5);
        imMask = removeSpuriousObjects(imMask, MinArea);  
    
        % Measure performance    
        contGT = contGT+1;
        if contGT == round(NumGTFrames/2),
            save([ColorSpaceName '_' VideoName '_' num2str(DeltaFrames+NdxFrame) '.mat'],'imMask');
        end
        GroundTruthFrame = double(imread(sprintf(GTPath,DeltaFrames+NdxFrame)));
        %         PerformanceMeasures(:,end+1)=EvaluatePerformance(imMask>0.5,GroundTruthFrame);
        PerformanceMeasures(:,end+1) = EvaluatePerformance(imMask>40/255,GroundTruthFrame);
    end
end
PerformanceMeasures(1,end+1) = Cputime/NumFrames;