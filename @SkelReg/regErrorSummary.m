function reg_error = regErrorSummary( obj, reg_types, num_samples, rand_seed )
%MEASUREREGISTRATIONERROR Measures various registration error metrics
%   Detailed explanation goes here

if ~exist('reg_types','var')
    reg_types = {'lm_at', 'lm_at_ft'};
end

if ~exist('num_samples','var')
    num_samples = 30;
end
    
if ~exist('rand_seed','var')
    rand_seed = 0;
end

% Compute Registration Error Metrics
for reg_type_idx = 1:numel(reg_types)
    reg_type = reg_types{reg_type_idx};
    if isfield(obj.skeletons,reg_type)
        reg_error.(reg_type).cp = obj.regErrorCP(reg_type);
        reg_error.(reg_type).nn = obj.regErrorNN(reg_type, num_samples, rand_seed);
    else
        warning(['Registration type ',reg_type,' not found. Make sure to compute a valid registration first.'])
    end
end

% Produce skelPlots
figure('Name','Registration Error Summary')
error_reg_types = fieldnames(reg_error);
sp_idx = 0;
for rt_idx = 1:numel(error_reg_types)
    error_reg_type = error_reg_types{rt_idx};
    error_measure_types = fieldnames(reg_error.(error_reg_type));
    for mt_idx = 1:numel(error_measure_types)
        sp_idx = sp_idx + 1;
        error_measure_type = error_measure_types{mt_idx};
        re = reg_error.(error_reg_type).(error_measure_type);
        re_x = 1:numel(fieldnames(re));
        re_labels = fieldnames(re);
        re_y = structfun(@(x) x, re);
        ax = subskelPlot(numel(error_reg_types), numel(error_measure_types),sp_idx);
        bar(re_x, re_y);
        ax.XTick = re_x;
        ax.XTickLabel = re_labels;
        ax.XTickLabelRotation = 90;
        ax.Title.String = regexprep([error_reg_type, ' ', error_measure_type], '_', '\\_');
    end
end

