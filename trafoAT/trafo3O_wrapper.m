function [ lsqs ] = trafo3O_wrapper( movingPoints, fixedPoints, scaleVector )
%TRAFO3O_WRAPPER Summary of this function goes here
%   Detailed explanation goes here
[ A, regParams ] = trafo3_absorWrapper( movingPoints, fixedPoints, scaleVector );
[ movingPointsT ] = trafo3_affineTransformSparseArray( movingPoints, A);
lsq = (sum(((fixedPoints - movingPointsT).^2),2)).^0.5;
lsqs = sum(lsq);


