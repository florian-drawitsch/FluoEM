function [bbox, bboxStr] = getBboxFromCenterPoint(centerPoint, bboxSize, voxelSize, shift)
%GETBBOXFROMCENTERPOINT returns a bounding box around a given center point
%   INPUT   centerPoint: [1x3] double
%               Coordinate of center point
%               Format: [x, y, z]
%           bboxSize: (optional) [1x3] double
%               Size of bounding box along the cardinal axes
%               Format: [size x, size y, size z] (in nanometer [nm])
%               (Default: [3000, 3000, 3000])
%           voxelSize: (optional) [1x3] double
%               Voxel size of respective data set
%               (Default: [11.24, 11.24, 30])
%           shift: (optional) [1x3] double
%               Relative shift vector to be applied to center point before 
%               computing the bounding box
%               (Default: [0, 0, 0])
%   OUTPUT  bbox: [1x6] double
%               Bounding box around center point
%               Format: xmin, ymin, zmin, xwidth, ywidth, zwidth
%           bboxStr: str
%               Bounding box around center point
%               Format: xmin, ymin, zmin, xwidth, ywidth, zwidth
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('bboxSize','var') || isempty(bboxSize)
    bboxSize = [3000, 3000, 3000];
end

if ~exist('voxelSize','var') || isempty(voxelSize)
    voxelSize = [11.24, 11.24, 30];
end

if ~exist('shift','var') || isempty(shift)
    shift = [0 0 0];
end

centerPoint = centerPoint + shift;
bboxSizeVx = bboxSize ./ voxelSize;

bboxE = round([...
    centerPoint(1) - bboxSizeVx(1)/2, ...
    centerPoint(2) - bboxSizeVx(2)/2, ...
    centerPoint(3) - bboxSizeVx(3)/2, ...
    centerPoint(1) + bboxSizeVx(1)/2, ...
    centerPoint(2) + bboxSizeVx(2)/2, ...
    centerPoint(3) + bboxSizeVx(3)/2, ...
    ]);

bbox = [bboxE(1:3), bboxE(4:6) - bboxE(1:3)];

bboxStr = sprintf('%d,%d,%d,%d,%d,%d', bbox);

end


