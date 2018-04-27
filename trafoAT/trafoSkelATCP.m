function [skelLMT, A] = trafoSkelATCP(skelLM, skelEM, CPsLM, CPsEM, relativeSearchRange)

if ~exist('relativeSearchRange','var')
    relativeSearchRange = 1;
end

% Affine Trafo
[ A, regParams ] = computeOptimalAffineTrafo( CPsEM, CPsLM, skelEM.scale, skelLM.scale, relativeSearchRange );
skelLMT = trafo3_transformSkeletonClass( skelLM, A, skelEM.scale );
skelLMT.parameters.experiment.name = skelEM.parameters.experiment.name;