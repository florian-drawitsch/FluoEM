function reg_error_nearest = measureRegErrorNearest( obj, reg_type, num_samples, rand_seed )
%MEASUREREGERRORNEAREST Measures registration error based on randomly
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
    num_samples = 10;
end

if ~exist('rand_seed', 'var')
    rand_seed = 0;
end

% Set random number generator seed
rng(rand_seed, 'twister');



end

