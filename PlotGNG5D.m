function [Handle]=PlotGNG5D(Model,Flag)

Handle = [];
hold on

if Flag,
    DimShift = 2;
else
    DimShift = 0;    
end

plot3(Model.Means(1+DimShift,:),Model.Means(2+DimShift,:),Model.Means(3+DimShift,:),'or','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',5);

for NdxUnit=1:Model.MaxUnits
    if isfinite(Model.Means(1,NdxUnit))
        NdxNeighbors=find(Model.Connections(NdxUnit,:));
        for NdxMyNeigh=1:numel(NdxNeighbors)
            line([Model.Means(1+DimShift,NdxUnit) Model.Means(1+DimShift,NdxNeighbors(NdxMyNeigh))],...
                [Model.Means(2+DimShift,NdxUnit) Model.Means(2+DimShift,NdxNeighbors(NdxMyNeigh))],...
                [Model.Means(3+DimShift,NdxUnit) Model.Means(3+DimShift,NdxNeighbors(NdxMyNeigh))],'Color',[1 1 0],'LineWidth',2);
        end
    end
end

hold off