function [skelLMTT, vecField, ffdSpacing, initialSpacing] = trafoSkelFTCP(skelLMT, skelEM, CPsLMT, CPsEM, initialSpacing, iterations)

if ~exist('initialSpacing','var')
    initialSpacing = 32768;
end

if ~exist('iterations','var')
    iterations = 4;
end


%% Transform into real world coordinates [nm]
A = [skelLMT.scale(1), 0, 0, 0; 0, skelLMT.scale(2), 0, 0; 0, 0, skelLMT.scale(3), 0; 0, 0, 0, 1];
skelLMRT = trafo3_transformSkeletonClass( skelLMT, A, [1 1 1] );
CPsLMRT = trafo3_affineTransformSparseArray( CPsLMT, A );
A = [skelEM.scale(1), 0, 0, 0; 0, skelEM.scale(2), 0, 0; 0, 0, skelEM.scale(3), 0; 0, 0, 0, 1];
skelEMR = trafo3_transformSkeletonClass( skelEM, A, [1 1 1] );
CPsEMR = trafo3_affineTransformSparseArray( CPsEM, A );


%% Free-Form Trafo
outerBboxEM = skelEMR.getBbox;
outerBboxEM = [outerBboxEM(:,1) - initialSpacing, outerBboxEM(:,2) + initialSpacing];
[ffdGridInitial,ffdSpacing,Xreg] = computeFreeFormTrafo( CPsEMR, CPsLMRT, outerBboxEM(:), initialSpacing, iterations );
[ffdGridInitialRef,ffdSpacing,Xreg] = computeFreeFormTrafo( CPsEMR, CPsEMR, outerBboxEM(:), initialSpacing, iterations );
vecField = ffdGridInitial - ffdGridInitialRef;
skelLMRTT = ffd_transformSkeletonClass( skelLMRT, ffdGridInitial, ffdSpacing );
skelLMRTT.parameters.experiment.name = skelEMR.parameters.experiment.name;


%% Transform back into EM voxels
A = 1./[skelEM.scale(1), 0, 0, 0; 0, skelEM.scale(2), 0, 0; 0, 0, skelEM.scale(3), 0; 0, 0, 0, 1];
A(A==inf) = 0;
skelLMTT = trafo3_transformSkeletonClass( skelLMRTT, A, skelEM.scale );