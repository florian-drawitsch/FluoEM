function [grid, vectorField, spacingConsequent, spacingInitial] = trafoFT_start(CPsLMT, CPsEM, scaleLMT, scaleEM, spacingInitial, iterations)

if ~exist('spacingInitial','var') || isempty(spacingInitial)
    spacingInitial = 32768;
end

if ~exist('iterations','var') || isempty(iterations)
    iterations = 4;
end

% Transform into real world coordinates [nm]
A = diag([scaleLMT, 1]);
CPsLMRT = trafoAT_transformArray(CPsLMT, A);

A = diag([scaleEM, 1]);
CPsEMR = trafoAT_transformArray(CPsEM, A);

% Free-Form Trafo
outerBboxEM = [min(CPsEMR,[],1)', max(CPsEMR,[],1)'];
outerBboxEM = [outerBboxEM(:,1) - spacingInitial, outerBboxEM(:,2) + spacingInitial];
grid = trafoFT_compute( CPsEMR, CPsLMRT, outerBboxEM(:), spacingInitial, iterations );
[gridInitial, spacingConsequent] = trafoFT_compute( CPsEMR, CPsEMR, outerBboxEM(:), spacingInitial, iterations );
vectorField = grid - gridInitial;

end