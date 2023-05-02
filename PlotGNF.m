function [Handle]=PlotGNF(Model)

Handle=figure;
hold on
plot(Model.Means(1,:),Model.Means(2,:),'or','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',5)

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))
        NdxNeighbors=find(Model.SpanningTree(NdxUnit,:));
        for NdxMyNeigh=1:numel(NdxNeighbors)
            line([Model.Means(1,NdxUnit) Model.Means(1,NdxNeighbors(NdxMyNeigh))],...
                [Model.Means(2,NdxUnit) Model.Means(2,NdxNeighbors(NdxMyNeigh))],'Color',[1 1 0],'LineWidth',2);
        end
    end
end

hold off

