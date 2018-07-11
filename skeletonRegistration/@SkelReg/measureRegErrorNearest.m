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
%   OUTPUT: reg_error_nearest: struct
%               Struct containing the measured errors

if ~exist('reg_type', 'var')
    reg_type = 'lm_at';
end

end

