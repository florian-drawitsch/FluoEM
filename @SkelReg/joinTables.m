function tablesJoined = joinTables(tableLeft, tableRight, typeLeft, typeRight)
%JOINTABLES Performs an inner join operation on the two provided comments 
% tables using 'id' as key and appends the provided table type to the
% remaining column names
%   INPUT   tableLeft: Comments table to go left in join
%           tableRight: Comments table to go right in join
%           typeLeft: Left table type (e.g. 'em')
%           typeRight: Right table type (e.g. 'lm')
%   OUTPUT  tablesJoined: Joined tables

% Perform join
tablesJoined = innerjoin(tableLeft, tableRight, 'Key', 'id')

% Rename columns according to provided types
colnames = tablesJoined.Properties.VariableNames;
colnames = cellfun(@(x) regexprep(x,'tableLeft',typeLeft), colnames, 'UniformOutput', false);
colnames = cellfun(@(x) regexprep(x,'tableRight',typeRight), colnames, 'UniformOutput', false);
tablesJoined.Properties.VariableNames = colnames;

end

