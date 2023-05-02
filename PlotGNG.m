function [Handle]=PlotGNG(Model)

Handle=figure;
hold on
plot(Model.Means(1,:),Model.Means(2,:),'or')

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))
        NdxNeighbors=find(Model.Connections(NdxUnit,:));
        for NdxMyNeigh=1:numel(NdxNeighbors)
            line([Model.Means(1,NdxUnit) Model.Means(1,NdxNeighbors(NdxMyNeigh))],...
                [Model.Means(2,NdxUnit) Model.Means(2,NdxNeighbors(NdxMyNeigh))]);
        end
    end
end

hold off

