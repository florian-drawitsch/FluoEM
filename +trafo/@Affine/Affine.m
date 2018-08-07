classdef Affine < trafo.Trafo
    %AFFINE Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Affine()
        end
    end
    
    methods (Static)
        points_at = transformArray(points, A, direction);
        skel_at = transformSkel(skel, A, scaleNew, direction);
    end
end

