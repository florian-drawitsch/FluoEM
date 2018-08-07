classdef Freeform < trafo.Trafo
    %FREEFORM Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Freeform(pointsMoving, pointsFixed, scaleMoving, scaleFixed, spacingInitial, iterations)
            %AFFINE Construct an instance of this class
            %   Detailed explanation goes here
            
            if ~exist('scaleMoving', 'var') || isempty(scaleMoving)
                scaleMoving = [1 1 1];
            end
            
            if ~exist('scaleFixed', 'var') || isempty(scaleFixed)
                scaleFixed = [1 1 1];
            end
            
            if ~exist('spacingInitial','var') || isempty(spacingInitial)
                spacingInitial = 32768;
            end
            
            if ~exist('iterations','var') || isempty(iterations)
                iterations = 4;
            end
            
            [obj.trafo.grid, obj.trafo.vectorField, obj.trafo.spacingInitial, obj.trafo.spacingConsequent] = trafo.Freeform.compute(pointsMoving, pointsFixed, scaleMoving, scaleFixed, spacingInitial, iterations);
            
        end
    end
    
    methods (Static)
        [grid, vectorField, spacingInitial, spacingConsequent] = compute(pointsMoving, pointsFixed, scaleMoving, scaleFixed, spacingInitial, iterations)
    end
end

