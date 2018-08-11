function [fh, ax] = plot(obj, savePath)
%PLOT Summary of this function goes here
%   Detailed explanation goes here

if exist('savePath', 'var')
    saveFig = true;
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
ylabel({'Axons in neighborhood'});
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

if saveFig
    print(fh, savePath)
    close(fh)
end

end

