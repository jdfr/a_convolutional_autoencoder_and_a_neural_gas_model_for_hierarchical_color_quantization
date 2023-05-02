function [Handle] = PlotGNFModel2DDistribution(Model,NomFich,SaveImg,NdxStep)


if SaveImg,
    Handle = figure;    
    Image = fliplr(rot90(double(rgb2gray(imread(NomFich)))/255,2));
    imshow(Image);
    hold on
    Ejes = axis(gca);
    Ejes([1 3]) = round(Ejes([1 3]));
    Ejes([2 4]) = floor(Ejes([2 4]))-1;
    axis tight;
    axis xy;
    PlotGNFScaled(Model,Ejes);
    hold off
    axis off
    title(sprintf('Time Step: %d',NdxStep));

    NomFichSalida = ['GNF_' strrep(NomFich,'.jpg','') '_' num2str(NdxStep)];
%     hgsave(gcf,[NomFichSalida '.fig']);    
    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperOrientation','portrait');
    set(gcf,'PaperPositionMode','manual');
    set(gcf,'PaperSize',[12 10]);
    set(gcf,'PaperPosition',[0 0 12 10]);    
    saveas(gcf,[NomFichSalida '.png'],'png');
%     fprintf('\nPress any key to continue\n');
%     pause
end
close
