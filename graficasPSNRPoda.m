% Script que genera la grafica del PSNR:
layers = [1 2 3 4];
mseBaboon = [24.49 30.99 37.67 40.75];
mseHouse = [27.65 35.10 41.43 43.66 ];
mseLake = [26.94 33.11 39.54 42.49];
mseLena = [28.96 36.58 42.81 45.53];


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
ylabel('PSNR value')

title('PSNR Values vs #Layers')

grid

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperOrientation','portrait');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperSize',[8 7]);
set(gcf,'PaperPosition',[0 0 8 7]);
set(gca,'fontsize',10);
%saveas(gcf,'Mifigura.fig','fig');
saveas(gcf,'graficaPSNRPoda.pdf','pdf');

%plot(layers, mseBaboon, layers, mseHouse,layers, mseLake,layers, mseLena), legend('Baboon','House','Lake','Lena');