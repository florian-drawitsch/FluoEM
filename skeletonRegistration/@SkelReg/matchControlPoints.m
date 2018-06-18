function obj = matchControlPoints(obj)
%MATCHCONTROLPOINTS Matches control points by performing an inner join on
% all available separate control point tables.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

skeletons_available = fieldnames(obj.skeletons);

for i = 1:numel(skeletons_available)-1
    
    if i == 1
        table_left = obj.controlPoints.(skeletons_available{i});
        table_right = obj.controlPoints.(skeletons_available{i+1});
        % Perform inner join of first two available control points tables
        obj.controlPoints.matched = innerjoin(table_left, table_right, 'Key', 'id');
        % Adapt variable names
        variable_names = obj.controlPoints.matched.Properties.VariableNames;
        variable_names = cellfun(@(x) regexprep(x, '_table_left', ['_',skeletons_available{i}]), variable_names, 'UniformOutput', false);
        variable_names = cellfun(@(x) regexprep(x, '_table_right', ['_',skeletons_available{i+1}]), variable_names, 'UniformOutput', false);
        obj.controlPoints.matched.Properties.VariableNames = variable_names;
        
    else
        table_left = obj.controlPoints.matched;
        table_right = obj.controlPoints.(skeletons_available{i+1});
        % Adapt variable names of new table
        variable_names = table_right.Properties.VariableNames;
        variable_names(2:end) = cellfun(@(x) [x,'_',skeletons_available{i+1}], variable_names(2:end), 'UniformOutput', false);
        table_right.Properties.VariableNames = variable_names;
        % Perform inner join with matched table
        obj.controlPoints.matched = innerjoin(table_left, table_right, 'Key', 'id');
    end
    
end

if isfield(obj.controlPoints, 'matched') && isempty(obj.controlPoints.matched)
    warning([...
        'No control points could be matched. Please check whether ',...
        'trees are consistently named in nml files, as well as if ',...
        'commentPattern and/or idGenerator argument passed to ',...
        'skelReg.controlPointRead are chosen properly',...
        ]);
end

end
