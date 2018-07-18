function [skelLMTT, grid, vectorField, spacingConsequent, spacingInitial] = trafoFT_start(skelLMT, skelEM, CPsLMT, CPsEM, spacingInitial, iterations)

if ~exist('spacingInitial','var') || isempty(spacingInitial)
    spacingInitial = 32768;
end

if ~exist('iterations','var') || isempty(iterations)
    iterations = 4;
end

% Transform into real world coordinates [nm]
A = [...
    skelLMT.scale(1), 0, 0, 0;...
    0, skelLMT.scale(2), 0, 0;...
    0, 0, skelLMT.scale(3), 0;...
    0, 0, 0, 1];

skelLMRT = trafoAT_transformSkeleton(skelLMT, A, [1 1 1]);
CPsLMRT = trafoAT_transformArray(CPsLMT, A);
A = [skelEM.scale(1), 0, 0, 0; 0, skelEM.scale(2), 0, 0; 0, 0, skelEM.scale(3), 0; 0, 0, 0, 1];
skelEMR = trafoAT_transformSkeleton(skelEM, A, [1 1 1]);
CPsEMR = trafoAT_transformArray(CPsEM, A);

% Free-Form Trafo
outerBboxEM = skelEMR.getBbox;
outerBboxEM = [outerBboxEM(:,1) - spacingInitial, outerBboxEM(:,2) + spacingInitial];
grid = trafoFT_compute( CPsEMR, CPsLMRT, outerBboxEM(:), spacingInitial, iterations );
[gridInitial,spacingConsequent] = trafoFT_compute( CPsEMR, CPsEMR, outerBboxEM(:), spacingInitial, iterations );
vectorField = grid - gridInitial;
skelLMRTT = trafoFT_transformSkeleton( skelLMRT, grid, spacingConsequent );
skelLMRTT.parameters.experiment.name = skelEMR.parameters.experiment.name;

% Transform back into EM voxels
A = 1./[skelEM.scale(1), 0, 0, 0; 0, skelEM.scale(2), 0, 0; 0, 0, skelEM.scale(3), 0; 0, 0, 0, 1];
A(A==inf) = 0;
skelLMTT = trafoAT_transformSkeleton(skelLMRTT, A, skelEM.scale);

end