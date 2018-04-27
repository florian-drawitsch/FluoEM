function [ obj ] = registerAffine( obj )
%REGISTER Summary of this function goes here
%   Detailed explanation goes here


obj.skelLM_AT = trafoSkelATCP(obj.skelLM, obj.skelEM, obj.controlPointsMatched.xyz_lm, obj.controlPointsMatched.xyz_em)




end

