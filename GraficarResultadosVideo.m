clear

% Generamos las configuraciones válidas
[Alfa,Beta] = ndgrid(0:0.1:1);
Gamma = 1-Alfa-Beta;
Configuraciones = zeros(size(Alfa,1),size(Beta,1),size(Gamma,1));
Configuraciones(:,:,1) = Alfa;
Configuraciones(:,:,2) = Beta;
Configuraciones(:,:,3) = Gamma;
Configuraciones(:,:,4:11) = [];
Configuraciones = reshape(Configuraciones,11*11,3);
NdxValidos = Configuraciones(:,3)>0;
Configuraciones = Configuraciones(NdxValidos,:);

NumConfig = size(Configuraciones,1);
load('ConfigEspacioColor.mat','TotalAccuracy','TotalFmeasure');
Videos = {'Campus','Curtain','Escalator','Fountain','LevelCrossing','OneShopOneWait1cor',...
    'Video2','Video4','WaterSurface','Lobby','LightSwitch'};
EspaciosColor = {'HSL','HSV','Lab','Luv','RGB','YCbCr'};

% MyAlpha = unique(Configuraciones(:,1));
% MyAlpha = repmat(MyAlpha,1,length(MyAlpha));
% MyBeta = unique(Configuraciones(:,2));
% MyBeta = repmat(MyBeta',length(MyBeta),1);
% [Alpha,Beta] = ndgrid(0:0.1:1);
% Gamma=1-Alpha-Beta;
% ConfiguracionesValidas = (Gamma>=0);

% [Alpha,Beta] = ndgrid(0:0.1:1);
[Alpha2,Beta2] = ndgrid(0:0.01:1);
for NdxEspacioColor=1:length(EspaciosColor),

    % Accuracy
    F = TriScatteredInterp(Configuraciones(:,1),Configuraciones(:,2),mean(squeeze(TotalAccuracy(NdxEspacioColor,:,:)))');
    
%     DatosInterpolados = F(Alpha,Beta);
%     h = mesh(Alpha,Beta,DatosInterpolados);
%     title(EspaciosColor{NdxEspacioColor});
%     xlabel('Alpha');
%     ylabel('Beta');
%     zlabel('Accuracy');
% %     saveas(h,[EspaciosColor{NdxEspacioColor} '_Accuracy_1.fig'],'fig');    
%     set(gcf,'PaperUnits','centimeters');
%     set(gcf,'PaperOrientation','portrait');
%     set(gcf,'PaperPositionMode','manual');
%     set(gcf,'PaperSize',[12 10]);
%     set(gcf,'PaperPosition',[0 0 12 10]);
% %     axis off;
%     saveas(gcf,[EspaciosColor{NdxEspacioColor} '_Accuracy_1.pdf'],'pdf'); 
    
    DatosInterpolados = F(Alpha2,Beta2);
    h = mesh(Alpha2,Beta2,DatosInterpolados);
    title(EspaciosColor{NdxEspacioColor});
    xlabel('Alpha');
    ylabel('Beta');
    zlabel('Accuracy');
    zlim([0 1]);
    saveas(h,[EspaciosColor{NdxEspacioColor} '_Accuracy_2.fig'],'fig');
    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperOrientation','portrait');
    set(gcf,'PaperPositionMode','manual');
    set(gcf,'PaperSize',[12 10]);
    set(gcf,'PaperPosition',[0 0 12 10]);
%     axis off;
    saveas(gcf,[EspaciosColor{NdxEspacioColor} '_Accuracy_2.pdf'],'pdf');
    
    % Fmeasure
    F = TriScatteredInterp(Configuraciones(:,1),Configuraciones(:,2),mean(squeeze(TotalFmeasure(NdxEspacioColor,:,:)))');
    
%     DatosInterpolados = F(Alpha,Beta);
%     h = mesh(Alpha,Beta,DatosInterpolados);
%     title(EspaciosColor{NdxEspacioColor});
%     xlabel('Alpha');
%     ylabel('Beta');
%     zlabel('F-Measure');
% %     saveas(h,[EspaciosColor{NdxEspacioColor} '_Fmeasure_1.fig'],'fig');
%     set(gcf,'PaperUnits','centimeters');
%     set(gcf,'PaperOrientation','portrait');
%     set(gcf,'PaperPositionMode','manual');
%     set(gcf,'PaperSize',[12 10]);
%     set(gcf,'PaperPosition',[0 0 12 10]);
% %     axis off;
%     saveas(gcf,[EspaciosColor{NdxEspacioColor} '_Fmeasure_1.pdf'],'pdf');
    
    DatosInterpolados = F(Alpha2,Beta2);
    h = mesh(Alpha2,Beta2,DatosInterpolados);
    title(EspaciosColor{NdxEspacioColor});
    xlabel('Alpha');
    ylabel('Beta');
    zlabel('F-Measure');
    zlim([0 1]);
    saveas(h,[EspaciosColor{NdxEspacioColor} '_Fmeasure_2.fig'],'fig');
    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperOrientation','portrait');
    set(gcf,'PaperPositionMode','manual');
    set(gcf,'PaperSize',[12 10]);
    set(gcf,'PaperPosition',[0 0 12 10]);
%     axis off;
    saveas(gcf,[EspaciosColor{NdxEspacioColor} '_Fmeasure_2.pdf'],'pdf');
end
