function xyz_i = interpArray3( xyz, f )
%INTERPARRAY3 Performs fast linear interpolation between adjacent points in 3D
%   INPUT:  xyz: [N x 3] double
%               Points in 3D space. Interpolation is performed between
%               xyz(i) and xyz(i+1) with i = 1:size(xyz,1)-1
%           f: double
%               Interpolation factor
%           xyz_i: [~N*f x 3] double
%               Points in 3D space with added interpolated values
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

lv = linspace(0,1,f+2)';
lv_core = lv(2:end-1);
cache = cell(size(xyz,1)-1,1);

% Compute interpolated points
for i = 1:size(xyz,1)-1
    p1 = xyz(i,:);
    p2 = xyz(i+1,:);
    p12i = unique(p1 + floor((p2 - p1).*lv_core), 'rows');
    cache{i} = p12i;
end

% Construct output
target_size = sum(cellfun(@(x) size(x,1), cache)) + size(xyz,1);
xyz_i = zeros(target_size,3);
idx_i_end = 0;
for idx_o = 1:size(xyz,1)-1
    idx_i_start = idx_i_end + 1;
    idx_i_end = idx_i_start + size(cache{idx_o},1);
    xyz_i(idx_i_start:idx_i_end, :) = [xyz(idx_o,:); cache{idx_o}];
end
xyz_i(end,:) = xyz(end,:);

end

