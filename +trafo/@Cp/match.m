function obj = match(obj)
%MATCH Matches control points by performing an inner join on
% all available separate control point tables.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

tabs_available = fieldnames(obj.points);
tabs_available(strcmp(tabs_available, 'matched')) = [];

for i = 1:numel(tabs_available)-1
    
    if i == 1 
        table_left = obj.points.(tabs_available{i});
        table_right = obj.points.(tabs_available{i+1});
        % Perform inner join of first two available control points tables
        obj.points.matched = innerjoin(table_left, table_right, 'Key', 'id');
        % Adapt variable names
        variable_names = obj.points.matched.Properties.VariableNames;
        variable_names = cellfun(@(x) regexprep(x, '_table_left', ['_',tabs_available{i}]), variable_names, 'UniformOutput', false);
        variable_names = cellfun(@(x) regexprep(x, '_table_right', ['_',tabs_available{i+1}]), variable_names, 'UniformOutput', false);
        obj.points.matched.Properties.VariableNames = variable_names;
    else
        table_left = obj.points.matched;
        table_right = obj.points.(tabs_available{i+1});
        % Adapt variable names of new table
        variable_names = table_right.Properties.VariableNames;
        variable_names(2:end) = cellfun(@(x) [x,'_',tabs_available{i+1}], variable_names(2:end), 'UniformOutput', false);
        table_right.Properties.VariableNames = variable_names;
        % Perform inner join with matched table
        obj.points.matched = innerjoin(table_left, table_right, 'Key', 'id');
    end
end

if isfield(obj.points, 'matched')
    obj.points.matched = sortrows(obj.points.matched);
end

end

