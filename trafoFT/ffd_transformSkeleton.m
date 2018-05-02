function [ krk_outputT, gradField, gradFieldSpacing ] = ffd_transformSkeleton( krk_output, trafoLocal )
%FFD_TRANSFORMSKELETON Performs B-Spline based free form deformation on
%skeleton 
%
%   Inputs:
%   krk_output: read/parseNml output
%   trafoLocal: Struct array containing fields gridSpacing,
%   offsetPerPathlength, affectedVertices, offsets
%   
%   Outputs:
%   krk_outputT: Transformed skeleton
%   gradField: Transformation Gradient Field
%
%   Depends on nonAffineTransformation Toolbox written by D. Kroon

% Read Parameters from Struct
gridSpacing = trafoLocal.gridSpacing;
offsetPerPathlength = trafoLocal.offsetPerPathlength;
affectedVertices = trafoLocal.affectedVertices;
offsets = trafoLocal.offsets;
initialSpacing = 2^nextpow2(max(gridSpacing));

% Determine skeleton dimensions
for i = 1:length(krk_output)
    maxsa(i,:) = max(krk_output{1,i}.nodes(:,1:3));
    minsa(i,:) = min(krk_output{1,i}.nodes(:,1:3));
end
maxs = max(maxsa);
mins = min(minsa);
dims = maxs - mins;

% Make Reference Grid
gridLims = [mins-gridSpacing/2; maxs+gridSpacing/2];
gridDims = abs(gridLims(1,:)-gridLims(2,:));

Xstatic = trafoLocal.Xstatic;
Xmoving = trafoLocal.Xmoving;

options.Verbose = 1;
options.MaxRef = nextpow2(initialSpacing)-7;

% Compute B-Spline Transformation Field
[O_trans,Spacing,Xreg] = point_registration(gridDims+mins,Xmoving,Xstatic,initialSpacing,options);

% Visualize Transformation Field Offsets as heatmap
[O_ref,Spacing,Xreg] = point_registration(gridDims+mins,Xstatic,Xstatic,initialSpacing,options);
gradField = O_trans - O_ref;
gradFieldSpacing = Spacing;


% Transform Skeleton
krk_outputT = krk_output;
for skel = 1:size(krk_output,2)
    nodes = krk_output{1,skel}.nodes(:,1:3);
    nodesT = round(bspline_trans_points_double(O_trans,Spacing,nodes));
    krk_outputT{1,skel}.nodes(:,1:3) = nodesT;
    krk_outputT{1,skel}.nodesNumDataAll(:,3:5) = nodesT(:,1:3);
    for struct = 1:size(krk_output{1,skel}.nodesAsStruct,2)
        krk_outputT{1,skel}.nodesAsStruct{1,struct}.x = nodesT(struct,1);
        krk_outputT{1,skel}.nodesAsStruct{1,struct}.y = nodesT(struct,2);
        krk_outputT{1,skel}.nodesAsStruct{1,struct}.z = nodesT(struct,3);
    end
end
    

function [ grid ] = makeGrid( corner1, corner2, spacing )
%MAKEGRID Creates N x 3 matrix containing vertices of grid

dims = (corner2 - corner1)./spacing;

i = 0;
for xi = 0:dims(1)
    for yi = 0:dims(2)
        for zi = 0:dims(3)
            i = i + 1;
            grid(i,1) = corner1(1)+ xi * spacing(1);
            grid(i,2) = corner1(2)+ yi * spacing(2);
            grid(i,3) = corner1(3)+ zi * spacing(3);
        end
    end
end

