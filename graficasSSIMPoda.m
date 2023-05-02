% Script que genera la grafica del SSIM:
layers = [1 2 3 4];
mseBaboon = [0.79 0.94 0.98 0.99];
mseHouse = [0.85 0.95 0.99 0.99];
mseLake = [0.80 0.93 0.98 0.99];
mseLena = [0.81 0.94 0.98 0.99];


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

plot(layers, mseBaboon,'color', 'red')
hold on,
plot(layers, mseHouse, 'color', 'green')

plot(layers, mseLake, 'color', 'blue')
plot(layers, mseLena, 'color', 'mag')

% plot(layers, mseBaboon)
% hold on,
% plot(layers, mseHouse)
% 
% plot(layers, mseLake)
% plot(layers, mseLena)

%legend({'Baboon','House','Lake','Lena'},'Location','southeast')

xlabel('Number of neuron layers')
ylabel('SSIM value')

title('SSIM Values vs #Layers')

grid

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[8 7]);
set(gcf,'PaperPosition',[0 0 8 7]);
set(gca,'fontsize',10);
%saveas(gcf,'Mifigura.fig','fig');
saveas(gcf,'graficaSSIMPoda.pdf','pdf');

%plot(layers, mseBaboon, layers, mseHouse,layers, mseLake,layers, mseLena), legend('Baboon','House','Lake','Lena');