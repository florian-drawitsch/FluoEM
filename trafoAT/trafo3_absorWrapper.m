function [ A, regParams ] = trafo3_absorWrapper( movingPoints, fixedPoints, scaleVector )
%TRAFO3_ABSORWRAPPER Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(scaleVector)
    A_scale = [
        scaleVector(1)  0               0               0
        0               scaleVector(2)  0               0
        0               0               scaleVector(3)  0
        0               0               0               1];
    
    [ movingPointsT ] = trafo3_affineTransformSparseArray( movingPoints, A_scale, 'forward' );
    
    [regParams,Bfit,ErrorStats]=trafo3_absor(movingPointsT',fixedPoints','doScale',0);
    
    regParams.s = scaleVector;
    
    A_rot_trans = [
        regParams.R     regParams.t
        0   0   0       1];
    
    A =  A_rot_trans * A_scale;
    
else
    
    [regParams,Bfit,ErrorStats]=trafo3_absor(movingPoints',fixedPoints','doScale',1);
    
    regParams.s = repmat(regParams.s,[1 3]);
    
    A = regParams.M;
    
end


end

