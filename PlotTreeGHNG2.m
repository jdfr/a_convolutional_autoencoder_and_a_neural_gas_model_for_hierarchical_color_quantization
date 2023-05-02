function [PlotHandle]=PlotTreeGHNG2(Model,GlobalMean,NumRowsImg,NumColsImg,ImageSize)
% Plot a GHPSOG model as a tree, with the mean vectors at the nodes
% This is for input data which has NOT been previously reduced by global PCA
% It is also needed that the mean vectors can be plotted as grayscale images
% Inputs:
%   Model=GHNG model
%   GlobaMean=Global mean of the input distribution before global PCA
%   NumRowsImg=Number of rows of the images which represent the mean
%   vectors
%   NumColsImg=Number of columns of the images which represent the mean
%   vectors
%   ImageSize=Relative size of each mini-image; must be between 0 and 1
%   
% Output:
%   PlotHandle=Handle of the generated plot

[Images Parents Coords] = CreateParentList(Model,NumColsImg,NumRowsImg,...
    {reshape(GlobalMean,NumColsImg,NumRowsImg)},[0],[0;1-ImageSize],1,3,ImageSize);
XCoord=Coords(1,:);
YCoord=Coords(2,:);
ValidNodes = find(YCoord>0);

PlotHandle = figure;
axis off
hold on
for NdxNode=ValidNodes,    
    subplot('Position',[XCoord(NdxNode) YCoord(NdxNode) ImageSize ImageSize]);
    subimage(Images{NdxNode});
    axis off
    hold on
    if Parents(NdxNode)>0,
        annotation('line',[XCoord(NdxNode)+0.6*ImageSize XCoord(NdxNode)]-0.4*ImageSize,...
            [YCoord(NdxNode) YCoord(NdxNode)]+0.5*ImageSize);
        annotation('line',[XCoord(NdxNode) XCoord(NdxNode)]-0.4*ImageSize,...
            [YCoord(NdxNode) YCoord(Parents(NdxNode))-0.4*ImageSize]+0.5*ImageSize);
    end    
end

end
%% Subfunction CreateParentList
function [ImagesOut,ParentsOut,CoordsOut] = CreateParentList(Model,NumColsImg,NumRowsImg,ImagesIn,ParentsIn,CoordsIn,NdxMyParent,MaxLevel,ImageSize)

ParentsOut = ParentsIn;
ImagesOut = ImagesIn;
CoordsOut = CoordsIn;
if isempty(Model) || MaxLevel==0    
    return
end

NdxValidNeurons = find(isfinite(Model.Means(1,:)));

for NdxNeuro=NdxValidNeurons,
    ParentsOut(end+1) = NdxMyParent;
%     ImagesOut{end+1} = rot90(fliplr(reshape(GlobalMean+Uq*Model.Means(:,NdxNeuro),NumColsImg,NumRowsImg)));  
    ImagesOut{end+1} = reshape(Model.Means(:,NdxNeuro),NumColsImg,NumRowsImg);
    CoordsOut(:,end+1) = [CoordsOut(1,NdxMyParent)+ImageSize;1-(1+size(CoordsOut,2))*ImageSize];
    if (isfield(Model,'Child')),
        [ImagesOut,ParentsOut,CoordsOut] = CreateParentList(Model.Child{NdxNeuro},NumColsImg,NumRowsImg,ImagesOut,ParentsOut,CoordsOut,numel(ParentsOut),MaxLevel-1,ImageSize);   
    end
end
    
end


