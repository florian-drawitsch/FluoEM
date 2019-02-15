function errCP = regErrorCP(obj)
%MEASUREREGERRORCP Measures registration error based on control points
% The error is computed as the root mean square of the euclidean distances
% between the fixed control points and the respective affine or free-form
% registered moving_at or moving_at_ft control points
%   OUTPUT: reg_error_cp: struct
%               Struct containing the measured errors
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

tabs_available = fieldnames(obj.cp.points);
modalities_available = tabs_available...
    (ismember(tabs_available, {'moving_at', 'moving_at_ft'}));

for i = 1:numel(modalities_available)
    
    % Compute reg error
    diffs = obj.cp.points.matched.xyz_fixed - ...
        obj.cp.points.matched.(['xyz_',modalities_available{i}]);
    norms = util.normList(diffs, obj.skeletons.fixed.scale);
    
    % Construct cp struct
    cp.id = obj.cp.points.matched.id;
    cp.norm = norms;
    
    % Construct summary struct
    summary.median = median(norms);
    summary.mean = mean(norms);
    summary.std = std(norms);
    
    % Construct output tables
    errCP.(modalities_available{i}).cp = struct2table(cp);
    errCP.(modalities_available{i}).summary = struct2table(summary);
    errCP.(modalities_available{i}).unit = 'nm';
    
end

end
