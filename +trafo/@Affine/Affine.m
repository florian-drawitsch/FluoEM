classdef Affine < Trafo
    %AFFINE Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Affine(movingPoints, fixedPoints, movingScale, fixedScale, movingName, fixedName)
            %AFFINE Construct an instance of this class
            %   Detailed explanation goes here
            
            if Trafo.assertPoints(movingPoints, fixedPoints) && trafo.assertScale(movingScale, fixedScale)
                obj.transformation = compute(movingPoints, fixedPoints, movingScale, fixedScale);
            end
            
        end
    end
    
    methods (Static)
        transformation = compute(movingPoints, fixedPoints, movingScale, fixedScale);
    end
end

