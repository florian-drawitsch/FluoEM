function [bboxT, bboxTstr] = transformBbox( obj, bbox, transformationMode )
%TRANSFORMBBOX Transforms a bounding box using available precomputed
%transformations
%   INPUT   bbox: [1x6] double
%               Target bounding box to be transformed.
%               Format: xmin, ymin, zmin, xwidth, ywidth, zwidth
%           transformationMode: (Optional) str
%               Transformation mode to be applied, 'affine' or 'free-form'.
%               (Default: 'affine')
%   OUTPUT  bboxT: [1x6] double
%               Transformed bounding box
%               Format: xmin, ymin, zmin, xwidth, ywidth, zwidth
%   Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('transformationMode', 'var')
    transformationMode = 'affine';
end

target = [...
    bbox(1), bbox(2), bbox(3);...
    bbox(1) + bbox(4), bbox(2) + bbox(5), bbox(3) + bbox(4) ...
    ];

targetT = applyAffine( obj, target );

if strcmp(transformationMode,'free-form')
    targetT = applyFreeForm( obj, targetT );
end

bboxT = round([...
    targetT(1,:), targetT(2,:) - targetT(1,:) ...
    ]);

bboxTstr = sprintf('%d, %d, %d, %d, %d, %d', bboxT);

end

