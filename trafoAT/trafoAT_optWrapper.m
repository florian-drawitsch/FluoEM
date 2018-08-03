function [ lsqs ] = trafoAT_wrapper( movingPoints, fixedPoints, scaleVector )
%TRAFO3O_WRAPPER Summary of this function goes here
%   Detailed explanation goes here
A = absorWrapper( movingPoints, fixedPoints, scaleVector );
[ movingPointsT ] = trafoAT_transformArray( movingPoints, A);
lsq = (sum(((fixedPoints - movingPointsT).^2),2)).^0.5;
lsqs = sum(lsq);


