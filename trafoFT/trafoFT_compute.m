function [O_trans,Spacing,Xreg] = trafoFT_compute( CPsEM, CPsLM, bbox, initialSpacing, iterations )
%COMPUTEFREEFORMTRAFO Summary of this function goes here
%   Detailed explanation goes here

globMin = bbox(1:3);
globMax = bbox(4:6);
globDim = globMax - globMin;

options.Verbose = 0;
options.MaxRef = iterations;
[O_trans,Spacing,Xreg] = point_registration(globDim+globMin,CPsLM,CPsEM,initialSpacing,options);

end

