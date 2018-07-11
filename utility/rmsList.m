function rms = rmsList(x)
%RMSLIST Computes the root mean square of the input vector
%   INPUT:  x: [N x 1] double
%               Input vector for which rms should be computed
%   OUPUT:  rms: double
%               Root mean square of the input vector

rms = sqrt(sum(x.^2)/length(x));

end

