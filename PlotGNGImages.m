% Plot a GNG where each prototype can be displayed as an image
function [Handle]=PlotGNGImages(Model,NumRowsImages,NumColsImages)
% Inputs:
%   Model= the trained GNG model
%   NumRowsImages= the number of rows of each image
%   NumColsImages= the number of columns of each image


Handle=figure;
hold on
colormap gray

Connections=biograph(Model.Connections);
dolayout(Connections);


%plot(Model.Means(1,:),Model.Means(2,:),'or')

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))      
        NdxNeighbors=find(Model.Connections(NdxUnit,:));
        for NdxMyNeigh=1:numel(NdxNeighbors)
            line([Connections.Nodes(NdxUnit).Position(1) Connections.Nodes(NdxNeighbors(NdxMyNeigh)).Position(1)]+NumColsImages/2,...
                [Connections.Nodes(NdxUnit).Position(2) Connections.Nodes(NdxNeighbors(NdxMyNeigh)).Position(2)]+NumRowsImages/2);
        end
    end
end

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))
        MyPos=Connections.Nodes(NdxUnit).Position;
        MyImage=flipud(reshape(Model.Means(:,NdxUnit),[NumRowsImages NumColsImages]));
        imagesc(MyPos(1),MyPos(2),MyImage,[-0.2 1.25]);        
    end
end

hold off

