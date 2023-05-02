% Script que genera la grafica del MSE:
layers = [1 2 3 4];
mseBaboon = [694.35 155.27 33.33 16.42];
mseHouse = [335.01 60.23 14.03 8.40];
mseLake = [394.73 95.36 21.69 10.99];
mseLena = [247.71 42.92 10.21 5.46];


% plot(layers, mseBaboon,'-s','MarkerSize',5,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red', 'color', 'red')
% hold on,
% plot(layers, mseHouse,'-o','MarkerSize',5,...
%    'MarkerEdgeColor','green','MarkerFaceColor','green', 'color', 'green')
% 
% plot(layers, mseLake,'-^','MarkerSize',5,...
%     'MarkerEdgeColor','blue','MarkerFaceColor','blue', 'color', 'blue')
% plot(layers, mseLena,'-v','MarkerSize',5,...
%     'MarkerEdgeColor','mag','MarkerFaceColor','mag', 'color', 'mag')
fig = figure;
% plot(layers, mseBaboon)
% hold on,
% plot(layers, mseHouse)
% 
% plot(layers, mseLake)
% plot(layers, mseLena)

plot(layers, mseBaboon,'color', 'red')
hold on,
plot(layers, mseHouse, 'color', 'green')

plot(layers, mseLake, 'color', 'blue')
plot(layers, mseLena, 'color', 'mag')

legendHandle = legend({'Baboon','House','Lake','Lena'}, 'Orientation','horizontal');

saveLegendToImage(fig, legendHandle, 'legendPodado', 'pdf');

% xlabel('Number of neuron layers')
% ylabel('MSE value')
% 
% title('MSE Values vs #Layers')
% 
% grid



% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperOrientation','portrait');
% set(gcf,'PaperPositionMode','manual');
% set(gcf,'PaperSize',[8 7]);
% set(gcf,'PaperPosition',[0 0 8 7]);
% set(gca,'fontsize',10);
% %saveas(gcf,'Mifigura.fig','fig');
% saveas(gcf,'legend.pdf','pdf');

%plot(layers, mseBaboon, layers, mseHouse,layers, mseLake,layers, mseLena), legend('Baboon','House','Lake','Lena');