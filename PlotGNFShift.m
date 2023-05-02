function [Handle]=PlotGNFShift(Model,DimShift)

Handle = [];
hold on

plot(Model.Means(1+DimShift,:),Model.Means(2+DimShift,:),'or','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',5);

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))
        NdxNeighbors=find(Model.SpanningTree(NdxUnit,:));
        for NdxMyNeigh=1:numel(NdxNeighbors)
            line([Model.Means(1+DimShift,NdxUnit) Model.Means(1+DimShift,NdxNeighbors(NdxMyNeigh))],...
                [Model.Means(2+DimShift,NdxUnit) Model.Means(2+DimShift,NdxNeighbors(NdxMyNeigh))],...
                'Color',[1 1 0],'LineWidth',2);
        end
    end
end

hold off