function [skelLMT, A] = trafoAT_start(skelLM, skelEM, CPsLM, CPsEM, relativeSearchRange)

if ~exist('relativeSearchRange','var')
    relativeSearchRange = 1;
end

% Affine Trafo
A = trafoAT_compute( CPsEM, CPsLM, skelEM.scale, skelLM.scale, relativeSearchRange );
skelLMT = trafoAT_transformSkeleton( skelLM, A, skelEM.scale );
skelLMT.parameters.experiment.name = skelEM.parameters.experiment.name;