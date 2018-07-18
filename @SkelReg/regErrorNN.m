function reg_error_nearest = regErrorNN( obj, reg_type, num_samples, rand_seed )
%MEASUREREGERRORNN Measures registration error based on randomly
%sampled skeleton nodes and their nearest registered neighbor node
% The error is computed as the root mean square of the euclidean distances
% between randomly sampled nodes on the em skeleton trees and the
% respective closest node on a locally densely interpolated piece of the
% registered lm skeleton
%   INPUT:  reg_type (optional): str
%               Registration type for which cp based error should be
%               measured. Either 'lm_at' or 'lm_at_ft'
%               (Default: 'lm_at')
%           num_samples (optional): int
%               Number of sample nodes to be drawn from each skeleton tree
%           rand_seed (optional): int
%               Seed for random number generator used to draw the node
%               samples
%   OUTPUT: reg_error_nearest: struct
%               Struct containing the measured errors

if ~exist('reg_type', 'var')
    reg_type = 'lm_at';
end

if ~exist('num_samples', 'var')
    num_samples = 30;
end

if ~exist('rand_seed', 'var')
    rand_seed = 0;
end

% Set random number generator seed and draw sample indices
rng(rand_seed, 'twister');
rand_sample_inds = arrayfun(@(x) randi([1 size(obj.skeletons.em.nodes{x},1)], num_samples, 1), 1:obj.skeletons.em.numTrees, 'Uni', false); 

% Check if reg_type is available
if ~isfield(obj.skeletons,reg_type)
    warning(['No matched cps were found for the registration type ',reg_type,'. Make sure to compute a valid registration first.'])
    reg_error_nearest = [];
    return;
end    

% Get tree correspondence information
name_stumps_em = cellfun(@(x) regexprep(x, '^(\w*)_.*$','$1'), obj.skeletons.em.names, 'Uni', false);
name_stumps_lmt = cellfun(@(x) regexprep(x, '^(\w*)_.*$','$1'), obj.skeletons.(reg_type).names, 'Uni', false);
tree_corr_inds_lmt = cellfun(@(x) find(strcmp(name_stumps_lmt, x)), name_stumps_em);

% Measure reg error nearest
% For each em tree
tree_sample_errors = cell(obj.skeletons.em.numTrees,1);
for tree_idx_em = 1:obj.skeletons.em.numTrees
    tree_nodes_em = obj.skeletons.em.nodes{tree_idx_em}(:,1:3);
    tree_idx_lmt = tree_corr_inds_lmt(tree_idx_em);
    tree_nodes_lmt = obj.skeletons.(reg_type).nodes{tree_idx_lmt}(:,1:3);
    % For each sample
    tree_sample_errors{tree_idx_em} = zeros(1,num_samples);
    for sample_idx = 1:num_samples
        % Get sample em node
        sample_idx_val = rand_sample_inds{tree_idx_em}(sample_idx);
        sample_node_em = tree_nodes_em(sample_idx_val,:);
        % Find closest node on reg type skeleton
        closest_node_lmt_idx = obj.skeletons.(reg_type).getClosestNode(sample_node_em, tree_idx_lmt);
        closest_nodes_lmt_inds = obj.skeletons.(reg_type).reachableNodes(tree_idx_lmt, closest_node_lmt_idx, 1, 'up_to');
        closest_nodes_lmt = tree_nodes_lmt(closest_nodes_lmt_inds, 1:3);
        closest_nodes_lmt_intp = interpArray3(closest_nodes_lmt, 10);
        % Measure euclidean distance to closest interpolated node
        min_dist = min(normList(closest_nodes_lmt_intp - sample_node_em, obj.skeletons.em.scale));
        tree_sample_errors{tree_idx_em}(sample_idx) = min_dist;
    end
end

% Construct output
reg_error_nearest.all = rmsList(cell2mat(tree_sample_errors'));
for tree_idx_em = 1:obj.skeletons.em.numTrees
    reg_error_nearest.(name_stumps_em{tree_idx_em}) = rmsList(tree_sample_errors{tree_idx_em});
end

end

