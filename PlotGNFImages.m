% Plot a GNF where each prototype can be displayed as an image
function [Handle]=PlotGNFImages(Model,NumRowsImages,NumColsImages)
% Inputs:
%   Model= the trained GNF model
%   NumRowsImages= the number of rows of each image
%   NumColsImages= the number of columns of each image


Handle=figure;
hold on
colormap gray

SpanningTree=biograph(Model.SpanningTree);
dolayout(SpanningTree);


%plot(Model.Means(1,:),Model.Means(2,:),'or')

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))      
        NdxNeighbors=find(Model.SpanningTree(NdxUnit,:));
        for NdxMyNeigh=1:numel(NdxNeighbors)
            line([SpanningTree.Nodes(NdxUnit).Position(1) SpanningTree.Nodes(NdxNeighbors(NdxMyNeigh)).Position(1)]+NumColsImages/2,...
                [SpanningTree.Nodes(NdxUnit).Position(2) SpanningTree.Nodes(NdxNeighbors(NdxMyNeigh)).Position(2)]+NumRowsImages/2);
        end
    end
end

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))
        MyPos=SpanningTree.Nodes(NdxUnit).Position;
        MyImage=flipud(reshape(Model.Means(:,NdxUnit),[NumRowsImages NumColsImages]));
        imagesc(MyPos(1),MyPos(2),MyImage,[-0.2 1.25]);        
    end
end

hold off

