function [fh, ax] = plotGraph(obj, savePath, saveFormat)
%PLOTGRAPH Produces a figure showing the number of remaining neighbors for
%each tree of the reference skeleton indicated as a line plot
%   INPUT:  savePath (optional): str
%               If passed the output figure is written to the specified
%               savePath
%               (Default: none)
%           saveFormat (optional): str
%               If passed the figure is saved in the specified format. This
%               format option is passed to matlab's print function. Check
%               print's documentation to check for supported format
%               strings.
%               (Default: '-dpdf')
% Author: Florian Drawitsch: <florian.drawitsch@brain.mpg.de>

if exist('savePath', 'var')
    saveFig = true;
else
    saveFig = false;
end

% Make Plot
figure
fh = gcf;
set(fh,'defaultAxesColorOrder',[[0 0 0];[.25 .25 .75]]);
ax = gca;

% Left Axis
yyaxis left
for treeIdx = 1:obj.skelRef.numTrees
    neighborCounts = obj.results.neighborCountsAll{treeIdx};
    if neighborCounts(end) > 0
        highlight = [obj.results.distToOriginAll{treeIdx}(end) neighborCounts(end)];
        scatter(highlight(1),highlight(2)+1,5,'v','MarkerEdgeColor',[1 0 0]);
    end
    plot(obj.results.distToOriginAll{treeIdx},neighborCounts+obj.options.plotAddY,'-','Color',get(gca,'YColor'),'LineWidth',0.2);
    hold on
end
ylim([0.9 obj.skelTar.numTrees+10]);
set(gca,'YScale','log');
yrTicks = [10^0,10^1,10^2];
yrTickLabels = {'10^0','10^1','10^2'};
set(gca,'YTick',yrTicks,'YTickLabel',yrTickLabels);
ylabel({'Axons in nhood'});
xlabel('d_{unique}(um)');
xTicks = [0, 50, 100] .* 1E3;
xTickLabels = {'0','50','100'};
set(gca,'XTick',xTicks,'XTickLabel',xTickLabels);
xlim([0 obj.options.plotRangeX(2)*1E3]);

% Right Axis
yyaxis right;
plot([obj.results.uniqueFracTable.binDists(2:end)' obj.results.uniqueFracTable.binDists(end)'+obj.options.binSize] ,obj.results.uniqueFracTable.binFracs./obj.skelRef.numTrees,'-','Color',get(gca,'YColor'),'LineWidth',0.5);
hold on;
line([-10 obj.options.plotRangeX(2)*1E3],[0.9 0.9],'LineStyle','--','LineWidth',0.5);
hold on;
line([obj.results.dropTable.dunique90 obj.results.dropTable.dunique90].*1E3,[0 1],'LineStyle','--','LineWidth',0.5);
yrTicks = [0,1];
yrTickLabels = cellfun(@(x) num2str(x),num2cell(yrTicks),'UniformOutput',0);
set(gca,'YTick',yrTicks,'YTickLabel',yrTickLabels);
ylabel('Unique axon fraction');
ylim([0 1.01]);
xlabel('Dist to origin (um)');

% Format Plot
fh = util.fig.setFigureHandle(fh, 'Width', 6, 'Height', 5);
ax = util.fig.setAxisHandle(ax, 0);

% Save Plot if specified
if saveFig
    print(fh, savePath, saveFormat)
    close(fh)
end

end

