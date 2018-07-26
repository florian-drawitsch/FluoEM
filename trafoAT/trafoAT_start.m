function [ A, regParams ] = trafoAT_start( CPsEM, CPsLM, scaleEM, scaleLM, relativeSearchRange )
%COMPUTEOPTIMALAFFINETRAFO Summary of this function goes here
%   Detailed explanation goes here

scaleVector = [scaleEM(1)/scaleLM(1) scaleEM(2)/scaleLM(2) scaleEM(3)/scaleLM(3)].^-1;
[A, regParams] = trafoAT_compute(CPsLM, CPsEM, scaleVector, relativeSearchRange);

end

