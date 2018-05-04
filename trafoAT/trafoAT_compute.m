function [ A, regParams ] = trafoAT_compute( CPsEM, CPsLM, scaleEM, scaleLM, relativeSearchRange )
%COMPUTEOPTIMALAFFINETRAFO Summary of this function goes here
%   Detailed explanation goes here

scaleVector = [scaleEM(1)/scaleLM(1) scaleEM(2)/scaleLM(2) scaleEM(3)/scaleLM(3)].^-1;
[A, regParams, lsqs, lsqsOpt] = trafoAT_optimize(CPsLM, CPsEM, scaleVector, relativeSearchRange);
disp(['Optimimal transform: lsqs: ',num2str(lsqs),' -> lsqsOpt: ',num2str(lsqsOpt)])

end

