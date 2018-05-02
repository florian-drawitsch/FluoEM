function [T]=bspline_transform(O,I,Spacing,mode)
% Function bspline_transform, is a wrapper of the mex 
% bspline_transform_2d_double and bspline_transform_3d mex functions
%
% [Iout,T] = bspline_transform(O,Iin,Spacing,mode)
%
% inputs,
%   Iin :  Input image.
%   O  : Transformation grid of control points
%   Spacing : Are the b-spline grid knot spacings.
%   mode: If 0: linear interpolation and outside pixels set to nearest pixel
%            1: linear interpolation and outside pixels set to zero
%            2: cubic interpolation and outsite pixels set to nearest pixel
%            3: cubic interpolation and outside pixels set to zero
%
% outputs,
%   Iout : The Rueckert transformed image
%   T : The transformation images (in 2D Tx=T(:,:,1)), describing the
%             (backwards) translation of every pixel in x,y and z direction.
%
% Function is written by D.Kroon University of Twente (February 2009)

% Check if spacing has integer values
if(sum(Spacing-floor(Spacing))>0), error('Spacing must be a integer'); end
if(~exist('mode','var')), mode=0; end

[Iout,Tx,Ty,Tz]=bspline_transform_3d_single_woi(single(O(:,:,:,1)),single(O(:,:,:,2)),single(O(:,:,:,3)),single(I),single(Spacing(1)),single(Spacing(2)),single(Spacing(3)),single(mode));
T(:,:,:,1)=Tx; T(:,:,:,2)=Ty; T(:,:,:,3)=Tz;

end

