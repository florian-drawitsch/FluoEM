function obj = skelLoad(obj, fname, skelType)
%LOADSKEL Summary of this function goes here
%   Detailed explanation goes here

SkelReg.assertSkelType(skelType);

skel = Skeleton(fname);
obj.skeletons.(skelType) = skel;
obj.parameters.paths.skeletons.(skelType) = fname;

end

