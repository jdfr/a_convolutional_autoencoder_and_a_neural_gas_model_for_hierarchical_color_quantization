function PerformanceMeasures = DemoTestGNFSegmentation(Model,TrainingWinners,TrainingErrors,ColorSpaceName,VideoName,NumFrames,DeltaFrames,VideoPath,GTPath,Lambda)

MinArea = 10;
PerformanceMeasures = zeros(7,0);
Cputime = 0;

switch ColorSpaceName,
    case {'RGB'}
        MyColorSpaceConversion = '';
    otherwise
        MyColorSpaceConversion = ['RGB->' ColorSpaceName];
end

for NdxFrame=1:NumFrames,
    
    if exist(sprintf(GTPath,DeltaFrames+NdxFrame),'file')
        fprintf('\t\t\tFrame with Ground truth %d\n',NdxFrame);
        
        % Obtain the test samples
        MyFrameOrig = imread(sprintf(VideoPath,DeltaFrames+NdxFrame)); 
        MyFrame = MyFrameOrig;
        if ~isempty(MyColorSpaceConversion),
            MyFrame = colorspace(MyColorSpaceConversion,MyFrame);            
        end
        MyFrame = NormalizarEspColor(double(MyFrame), ColorSpaceName);
        MyMatrixFrame = reshape(shiftdim(MyFrame,2),3,[]);            
        [i,j] = ind2sub([size(MyFrame,1) size(MyFrame,2)],[1:length(MyMatrixFrame)]);
        TestSamples = [MyMatrixFrame;Lambda*NormalizeData(i);Lambda*NormalizeData(j)];
        
        % DETECT THE FOREGROUND
        tic;
        [TestWinners,TestErrors] = TestGNG(Model,TestSamples);
        
        % Criterion 1 (Foreground pixels)
        ForegroundPixels = ((TrainingWinners == TestWinners) == 0);
        imMask1 = reshape(ForegroundPixels,size(MyFrame,1),size(MyFrame,2));       
        imMask1 = double(imMask1 >= 0.5);
        
        % Criterion 2 (Foreground pixels)
        ErrorDiff = abs(TrainingErrors - TestErrors);
%         BackgroundPixels = (ErrorDiff <= mean(ErrorDiff));
        MyThreshold = mean(ErrorDiff)+std(ErrorDiff);
        ForegroundPixels2 = (ErrorDiff > MyThreshold);
        imMask2 = reshape(ForegroundPixels2,size(MyFrame,1),size(MyFrame,2));       
        imMask2 = double(imMask2 >= 0.5);
        
        % Criteria 1 and 2 (Foreground pixels - Bacground pixels
        BackgroundPixels = (ErrorDiff <= MyThreshold);
        ForegroundPixels = (ForegroundPixels - BackgroundPixels) == 1;
        imMask3 = reshape(ForegroundPixels2,size(MyFrame,1),size(MyFrame,2));       
        imMask3 = double(imMask3 >= 0.5);
        
        Cputime = Cputime + toc;        

        % Fill holes (size 1) and remove objects with minimum area
        imMaskPost1 = bwmorph(imMask1,'close',5);
        imMaskPost1 = removeSpuriousObjects(imMaskPost1, MinArea);
        imMaskPost2 = bwmorph(imMask2,'close',5);
        imMaskPost2 = removeSpuriousObjects(imMaskPost2, MinArea);
        imMaskPost3 = bwmorph(imMask3,'close',5);
        imMaskPost3 = removeSpuriousObjects(imMaskPost3, MinArea);
        
        % Measure performance
        GroundTruthFrame = double(imread(sprintf(GTPath,DeltaFrames+NdxFrame)));        
        PerformanceMeasures(:,end+1) = EvaluatePerformance(imMaskPost3>40/255,GroundTruthFrame);
        
        % Plot frames
        fig = figure;
        set (fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
        
        subplot(2,4,1)
        imshow(MyFrameOrig);
        title('Original Frame');
        
        subplot(2,4,5)
        imshow(GroundTruthFrame);
        title('Ground Truth');
        
        subplot(2,4,2)
        imshow(imMask1);
        title('Criterion 1');
        
        subplot(2,4,6)
        imshow(imMaskPost1);
        title('Postprocessed');
        
        subplot(2,4,3)
        imshow(imMask2);
        title('Criterion 2');
        
        subplot(2,4,7)
        imshow(imMaskPost2);
        title('Postprocessed');
        
        subplot(2,4,4)
        imshow(imMask3);
        title('Criterion 3');
        
        subplot(2,4,8)
        imshow(imMaskPost3);
        title('Postprocessed');
        
        fprintf('\nPress any key to continue\n');
        pause
        close
    end
end
PerformanceMeasures(1,end+1) = Cputime/NumFrames;