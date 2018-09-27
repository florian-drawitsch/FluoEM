classdef Cp
    %CP class handles control points
    % Control points are read from skeleton objects 
    % Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
    
    properties
        points = struct();
        pointsDeleted = struct();
    end
    
    methods
        function obj = Cp()
            %The Cp constructor creates an empty cp object.
            % To populate it with control points, invoke the
            % readFromSkel method.
        end
        
        function pass = assertModalityType(obj, modalityType)
            %ASSERTMODALITYTYPE asserts the existence of the passed
            %modality type(s) amongst the fielnames of the points property
            tabs_available = fieldnames(obj.points);
            cond = @(x) all(ismember(x, tabs_available));
            msg = 'One or more of the passed modalityType(s) is not available in the points property';
            assert(cond(modalityType), msg);
            pass = true;
        end
    end
    
    methods (Static = true)        
        obj = load(loadPath)
    end
    
end

