classdef Affine < trafo.Trafo
    %AFFINE Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Affine(pointsMoving, pointsFixed, scaleMoving, scaleFixed)
            %AFFINE Construct an instance of this class
            %   Detailed explanation goes here
            
            if ~exist('scaleMoving', 'var') || isempty(scaleMoving)
                scaleMoving = [1 1 1];
            end
            
            if ~exist('scaleFixed', 'var') || isempty(scaleFixed)
                scaleFixed = [1 1 1];
            end
            
            [obj.trafo.A, obj.trafo.regParams, obj.trafo.lsqsInit, obj.trafo.lsqsOpt] = trafo.Affine.compute(pointsMoving, pointsFixed, scaleMoving, scaleFixed);
            
        end
    end
    
    methods (Static)
        [A, regParams, lsqsInit, lsqsOpt] = compute(pointsMoving, pointsFixed, movingScale, fixedScale);
    end
end

