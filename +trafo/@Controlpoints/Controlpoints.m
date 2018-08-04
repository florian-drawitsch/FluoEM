classdef Controlpoints
    %CONTROLPOINTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cps = struct();
        attributes = struct();
    end
    
    methods
        function obj = Controlpoints(movingSource,fixedSource)
            %CONTROLPOINTS Construct an instance of this class
            %   Detailed explanation goes here

        end
        
     methods (Static)
         cpTable = readFromSkel(skel, commentPattern, idGenerator)
     end
        
    end
end

