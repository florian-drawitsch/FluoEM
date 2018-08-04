function [ A, regParams ] = trafoAT_start( CPsEM, CPsLM, scaleEM, scaleLM )
%COMPUTEOPTIMALAFFINETRAFO Summary of this function goes here
%   Detailed explanation goes here

% Compute ratio of nominal scales
scaleVector = scaleLM./scaleEM;

% Compute affine transformation
[A, regParams] = trafoAT_compute(CPsLM, CPsEM, scaleVector);

end

