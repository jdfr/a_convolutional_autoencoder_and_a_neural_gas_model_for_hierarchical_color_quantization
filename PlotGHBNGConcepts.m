function Out = PlotGHBNGConcepts(varargin)

%Out = PlotGHBNGConceptsMulti(varargin{:});
Out = PlotGHBNGConceptsSingle(varargin{:});
%Out = PlotGHBNGConceptsSingleAllPhotos(varargin{:});

%for JAJALINA in picturesque Lena Lake House bird woman building snow street night mall bike chicks; do python pruebaconv1.py --encode --matpath "convP8H1/${JAJALINA}_convautoenc_R3_H1_N4_D0_P8_E20000_best.mat" --weightpath "convP8H1/${JAJALINA}_convautoenc_R3_H1_N4_D0_P8_E20000_best.pt" --imgpath all/gray.png --basename "tests/${JAJALINA}_convautoenc_R3_H1_N4_D0_P8_E20000_best_gray" --device "cuda:0"; done


end

function Modelos = PlotGHBNGConceptsSingleAllPhotos(photonames, Modelos)
%photonames = {'picturesque', 'Lena', 'Lake', 'House', 'bird', 'woman', 'building', 'snow', 'street', 'night', 'mall', 'bike', 'chicks'}; Modelos = PlotGHBNGConcepts(photonames, cell(13,1)); save('tests/otherphotosN4.mat', 'photonames', 'Modelos');
for k=1:numel(photonames)
  Modelos{k} = PlotGHBNGConceptsSingle(photonames{k}, Modelos{k}, 4, 0, 1);
end
end

function Modelo = PlotGHBNGConceptsSingle(photoname, Modelo, N, margin, col)

%Modelo4 = PlotGHBNGConcepts('Baboon', Modelo4, 4, 0, 1);

unitsToPrint = [];
unitsToPrint = {{1, 1, []}};
unitsToPrint = {{2, 1, []}, {2, 2, []}, {2, 3, []}, {2, 4, []}};
%picturesque
unitsToPrint = {{1, 1, {[1.13950192812079	-1.82917568629940	-0.544748796140611	-1.19451359611810	1.47027938145683	0.157737497507620	-0.636875731675739	-1.77035179982717	1.82075748797279	1.47942924438474	-1.24799245292816	0.744823740951154	2.21230543972177	-0.132576296604116], [2.38036949753710	-1.30407657159514	-1.86134592978934	0.932287685478856	0.917008012104553	-0.442882918208316	2.24105215798855	1.61412413002006	-1.40856457625655	-0.473442264956920	-0.320645531213901	-1.72949201914518	1.99422498499284	1.00868605235037]}}};
%picturesque
unitsToPrint = {{1, 1, {[1.13950192812079	-1.82917568629940	-0.544748796140611	-1.50035113904572	1.78127523334555	-0.642056815041243	-0.636875731675739	-1.77035179982717	1.82075748797279	1.47942924438474	-1.82356092747322	0.744823740951154	2.17208955737321	0.283408369102707], [2.38036949753710	-1.30407657159514	-1.86134592978934	0.494609794362061	1.12900125123493	-0.759246261574904	2.24105215798855	1.61412413002006	-1.40856457625655	-0.473442264956920	-0.378611387451183	-1.72949201914518	2.22612530017978	1.57680698549813]}}};
%night
unitsToPrint = {{1, 1, {[-1.33605639196718	1.89479145490225	-1.12345911786307	-1.23030935110896	0.959862352354716	0.135771766682795	1.28984167264189	-1.04596658006892	0.00624518360561448	-0.0613651144654726	1.04048557341947	-1.91503748627259	0.912092944755052	-0.394013744116465], [1.36554943623493	1.21753151935487	-1.90848614743051	-0.835328401209563	1.25536097962393	-0.853731957220891	0.728399328093542	0.453559336608302	1.52349075010270	0.610375211105915	-1.82175862434743	0.336072212237902	-0.203341485835025	-1.75038885516517]}}};

posshift = [0,0];
RutaSalvar = 'tests/';
colors = {'gray', 'white', 'black'};
prefix = ['margin' num2str(margin) '_' colors{col} '_' photoname '_N' num2str(N) '_DivSE_'];
encodedColorPath = ['tests/' photoname '_convautoenc_R3_H1_N' num2str(N) '_D0_P8_E20000_best_' colors{col} '.mat'];
basenameForDecoder = ['convP8H1/' photoname '_convautoenc_R3_H1_N' num2str(N) '_D0_P8_E20000_best'];
Modelo = PlotGHBNGConceptsReal(Modelo, N, posshift, margin, prefix, encodedColorPath, basenameForDecoder, RutaSalvar, unitsToPrint);

end

function ModelosByN = PlotGHBNGConceptsMulti(margin, col, varargin)

%ModelosByN = PlotGHBNGConcepts(1, 1, {[],[],[],Modelo4}); save('tests/baboon_models_N1234.mat', 'ModelosByN'); ModelosByN = PlotGHBNGConcepts(0, 1, ModelosByN); for m=[1 0]; for c=[2 3]; ModelosByN = PlotGHBNGConcepts(m, c, ModelosByN); end; end;

posshift = [0,0];
prefix = '';
RutaSalvar = [prefix 'tests/'];
colors = {'gray', 'white', 'black'};
if nargin==0
  ModelosByN = {[],[],[],[]};
else
  ModelosByN = varargin{1};
end
for N=1:4
  prefixOutput = ['margin' num2str(margin) '_' colors{col} '_Baboon_N' num2str(N) '_DivgSE_'];
  encodedColorPath = [prefix 'tests/Baboon_convautoenc_R3_H1_N' num2str(N) '_D0_P8_E20000_best_' colors{col} '.mat'];
  basenameForDecoder = [prefix 'convP8H1/Baboon_convautoenc_R3_H1_N' num2str(N) '_D0_P8_E20000_best'];
  Modelo = PlotGHBNGConceptsReal(ModelosByN{N}, N, posshift, margin, prefixOutput, encodedColorPath, basenameForDecoder, RutaSalvar, []);
  if isempty(ModelosByN{N})
    ModelosByN{N} = Modelo;
  end
end

end

function Modelo = PlotGHBNGConceptsReal(Modelo, N, posshift, margin, FileName, grayEncodedPath, basenameForDecoder, RutaSalvar, unitsToPrint)

grayautoenc = load(grayEncodedPath).autoenc;
encodedOrigGray = double(grayautoenc.encoded);

if isempty(Modelo)
  autoenc = load([basenameForDecoder '.mat']).autoenc;
  encodedOrig = double(autoenc.encoded);
  Muestras = reshape(shiftdim(encodedOrig,2),size(encodedOrig,3),[]);

  NumEpocas = 2;
  Divergences={'Squared Euclidean','Generalized I-Divergence','Itakura-Saito','Exponential Loss','Logistic Loss'};
  MaxNeurons = 50; % Maximum number of neurons in each graph
  TauGHBNG = 0.1;
  Lambda = 100;
  EpsilonB = 0.2;
  EpsilonN = 0.006;
  Alpha = 0.5;
  AMax = 50;
  D = 0.995;

  MyDivergence=Divergences{1};

  Modelo = TrainGHBNG(Muestras,NumEpocas,MyDivergence,MaxNeurons,TauGHBNG,Lambda,EpsilonB,EpsilonN,Alpha,AMax,D,1);
end

printLargeGraph = true;

if printLargeGraph
  patchsize=12;
  shiftpatch = [-patchsize*2.2, -22];%4;
  figsize = [0 0 0.57 0.9];
else
  denom1=2;
  denom2=2.8;
  patchsize=12/denom2;
  shiftpatch = [-patchsize*2.2, -22/denom2];
  figsize = [0 0 0.57/denom1 0.9/denom1];
end

PlotGHBNGConceptsRec(Modelo,N,1,1,FileName, encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, shiftpatch, posshift, margin, figsize, unitsToPrint);

%PlotGHBNGConceptsRec(Modelo,N,1,1,FileName, encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, [0 0], margin, figsize, unitsToPrint);

%PlotGHBNGConceptsRec(Modelo,N,1,1,[FileName 'center_'  ], encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, [0 0], margin, figsize, unitsToPrint);
%PlotGHBNGConceptsRec(Modelo,N,1,1,[FileName 'shiftx1_' ], encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, [1 0], margin, figsize, unitsToPrint);
%PlotGHBNGConceptsRec(Modelo,N,1,1,[FileName 'shifty1_' ], encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, [0 1], margin, figsize, unitsToPrint);
%PlotGHBNGConceptsRec(Modelo,N,1,1,[FileName 'shiftxy1_'], encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, [1 1], margin, figsize, unitsToPrint);
end

function PlotGHBNGConceptsRec(Model,N,Level,Parents,FileName, encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, shiftpatch, posshift, margin, figsize, unitsToPrint)

if ~isempty(Model) && sum(isfinite(Model.Means(1,:)))>0 %&& (Level <= 1)

    printThisOne = isempty(unitsToPrint);
    thisLayout = [];
    if ~printThisOne
      parent = Parents(end);
      for k=1:numel(unitsToPrint)
        printThisOne = Level==unitsToPrint{k}{1} && parent==unitsToPrint{k}{2};
        if printThisOne
          thisLayout = unitsToPrint{k}{3};
          fprintf("Printing graph at level %d with parent %d\n", Level, parent);
          break;
        end  
      end
    end
    %printThisOne = Level>1;

    NdxValidNeurons  = find(isfinite(Model.Means(1,:)));
    ModelChildren    = Model.Child(NdxValidNeurons);

    if printThisOne
      name1  = [FileName num2str(Level) '_'  num2str(Parents)];
      name2  = strrep(name1, '_', '\_');
      Handle = figure('Name',name1,'units','normalized','outerposition',figsize, 'Visible', 'off');    
      axis equal;
      hold on
      
      Colors = distinguishable_colors(4);
      MyColor = Colors(Level,:);
      
      ModelMeans       = Model.Means(:, NdxValidNeurons);
      ModelConnections = Model.Connections(NdxValidNeurons, NdxValidNeurons);

      if false
        SpanningTree = graph(ModelConnections~=0);
        h = plot(SpanningTree);
        %h.XData = thisLayout{1};
        %h.YData = thisLayout{2};
        layout(h,'force');
        set(gcf,'WindowButtonDownFcn',@(f,~)edit_graph(f,h));
        hx=h.XData; hy=h.YData;
      end
      if isfield(Model, 'SpanningTree')
        SpanningTree = Model.SpanningTree;
      elseif isempty(thisLayout)
        %SpanningTree=biograph(ModelConnections);
        %%SpanningTree.LayoutType = 'equilibrium';
        %SpanningTree.LayoutScale = 10;
        %%SpanningTree.LayoutType = 'hierarchical';
        %SpanningTree.LayoutType = 'radial';
        %dolayout(SpanningTree);
        SpanningTree = graph(ModelConnections~=0);
        % Construct the graphics chart object without attaching to an axes or figure:
        method = 'circle';
        method = 'subspace';
        method = 'layered';
        method = 'force';
        h = matlab.graphics.chart.primitive.GraphPlot('BasicGraph', ...
                MLGraph(SpanningTree), 'Layout', method);
        % Get its XData and YData properties:
        X = h.XData;
        Y = h.YData;
      else
        X = thisLayout{1};
        Y = thisLayout{2};
      end
      for NdxUnit=1:numel(NdxValidNeurons)
          if isfinite(ModelMeans(1,NdxUnit))      
              
              MyPos=[X(NdxUnit) Y(NdxUnit)];
              %MyPos=SpanningTree.Nodes(NdxUnit).Position;
              
              % Draw edges
              NdxNeighbors=find(ModelConnections(NdxUnit,:));                        
              for NdxMyNeigh=1:numel(NdxNeighbors)
                  MyColor = 'k';
                  line([MyPos(1) X(NdxNeighbors(NdxMyNeigh))],...
                      [MyPos(2) Y(NdxNeighbors(NdxMyNeigh))],'Color',MyColor,'LineWidth',0.5);
                  %line([MyPos(1) SpanningTree.Nodes(NdxNeighbors(NdxMyNeigh)).Position(1)],...
                  %    [MyPos(2) SpanningTree.Nodes(NdxNeighbors(NdxMyNeigh)).Position(2)],'Color',MyColor,'LineWidth',0.5);
              end
          end
      end
      for NdxUnit=1:numel(NdxValidNeurons)
          if isfinite(ModelMeans(1,NdxUnit))      
              
              MyPos=[X(NdxUnit) Y(NdxUnit)];
              %MyPos=SpanningTree.Nodes(NdxUnit).Position;
              
              % Draw nodes            
              %[MyConceptFreq,MyConceptNdx] = max(ModelMeans(:,NdxUnit));                
              if isempty(ModelChildren{NdxUnit}) || Level>2                
                  MyColor = 'cyan';
                  plot(MyPos(1),MyPos(2),'o','LineWidth',1,'MarkerEdgeColor',MyColor,'MarkerFaceColor',MyColor, 'MarkerSize', 22);%,'MarkerSize',max(18*MyConceptFreq,12)); % node with layer color                
              else               
                  plot(MyPos(1),MyPos(2),'o','LineWidth',1,'MarkerEdgeColor','yellow','MarkerFaceColor','yellow', 'MarkerSize', 22);%,'MarkerSize',max(18*MyConceptFreq,12)); % yellow node                
              end
              text(MyPos(1),MyPos(2),num2str(NdxUnit),'Color',[0 0 0],'FontSize',18,'HorizontalAlignment','center');  % unit number                  
          end
      end
      ys = ylim;
      yspan = max(ys)-min(ys);
      xs = xlim;
      xspan = max(xs)-min(xs);
      
      for NdxUnit=1:numel(NdxValidNeurons)
          if isfinite(ModelMeans(1,NdxUnit))      
              
              MyPos=[X(NdxUnit) Y(NdxUnit)];
              %MyPos=SpanningTree.Nodes(NdxUnit).Position;
              
              centroid = ModelMeans(:,NdxUnit);
              %thispatch = zeros(3,3,3);
              thispatch = getPatch(centroid, encodedOrigGray, basenameForDecoder, RutaSalvar, posshift, N, margin);
              imagesc([MyPos(1)+xspan/shiftpatch(1),MyPos(1)+xspan/shiftpatch(1)+yspan/patchsize], [MyPos(2)+yspan/shiftpatch(2), MyPos(2)+yspan/shiftpatch(2)-yspan/patchsize], thispatch);
          end
      end

      hold off
      axis off
      %title(name2);
      %Figure2pdf(Handle, [RutaSalvar FileName num2str(Level) '_' num2str(Parents)],16,10);
      export_fig([RutaSalvar FileName num2str(Level) '_' num2str(Parents) '.pdf'], '-q101');
      close(Handle);
    end
    
    % Draw children in different figures
    for NdxUnit=1:length(ModelChildren)
        PlotGHBNGConceptsRec(ModelChildren{NdxUnit},N,Level+1,[Parents NdxUnit],FileName, encodedOrigGray, basenameForDecoder, RutaSalvar, patchsize, shiftpatch, posshift, margin, figsize, unitsToPrint);          
    end
end
end

function thispatch = getPatch(centroid, encodedOrigGray, basenameForDecoder, RutaSalvar, posshift, N, margin)


position = round(size(encodedOrigGray,1)/2);
encoded = encodedOrigGray;
encoded(position+posshift(1), position+posshift(2), :) = centroid;

rnd = round(rand*1000000);
encodedpath = [RutaSalvar sprintf('tmp%d.mat', rnd)];
encodedimgpath = [RutaSalvar sprintf('tmp%d.png', rnd)];
save(encodedpath, 'encoded');
command = sprintf('conda run condaconvenv python pruebaconv1.py --decode --matpath %s --weightpath %s --encodedpath %s --resultpath %s', [basenameForDecoder '.mat'], [basenameForDecoder '.pt'], encodedpath, encodedimgpath);
system(command, '-echo');
ImgProt = imread(encodedimgpath);
delete(encodedpath);
delete(encodedimgpath);

centre = 256-2^N+1;
amplitude = 2^N+margin;
skip = 2^N;
limitX1 = centre-amplitude+posshift(1)*skip+1;
limitX2 = centre+amplitude+posshift(1)*skip;
limitY1 = centre-amplitude+posshift(2)*skip+1;
limitY2 = centre+amplitude+posshift(2)*skip;
thispatch = ImgProt(limitX1:limitX2,limitY1:limitY2,:);
%figure; imshow(thispatch);
end

function Figure2pdf(Handle,FileName,SizeX,SizeY)

%border=5;

%set(Handle,'PaperUnits','centimeters');
%set(Handle,'PaperOrientation','portrait');
%set(Handle,'PaperPositionMode','manual');
%set(Handle,'PaperSize',[SizeX SizeY]);
%set(Handle,'PaperPosition',[0-border 0-border SizeX+border SizeY+border]);
saveas(Handle,sprintf('%s.fig',FileName),'fig');
saveas(Handle,sprintf('%s.pdf',FileName),'pdf');

end

function edit_graph(f,h)
    
    % Figure out which node is closest to the mouse. 
    a = ancestor(h,'axes');
    pt = a.CurrentPoint(1,1:2);
    dx = h.XData - pt(1);
    dy = h.YData - pt(2);
    len = sqrt(dx.^2 + dy.^2);
    [lmin,idx] = min(len);
    
    % If we're too far from a node, just return
    tol = max(diff(a.XLim),diff(a.YLim))/20;    
    if lmin > tol || isempty(idx)
        return
    end
    node = idx(1);

    % Install new callbacks on figure
    f.WindowButtonMotionFcn = @motion_fcn;
    f.WindowButtonUpFcn = @release_fcn;

    % A ButtonMotionFcn that changes XData & YData
    function motion_fcn(~,~)
        newx = a.CurrentPoint(1,1);
        newy = a.CurrentPoint(1,2);
        h.XData(node) = newx;
        h.YData(node) = newy;
        drawnow;
    end

    % A ButtonUpFcn which stops dragging
    function release_fcn(~,~)
        f.WindowButtonMotionFcn = [];
        f.WindowButtonUpFcn = [];
    end
end


