classdef Cp
    %CP class handles control points
    % Control points can be either read from skeleton objects or csv 
    % files. 
    
    properties
        points = struct();
    end
    
    methods
        function obj = Cp()
        end
    end
    
    methods (Static = true)
        sourceType = getSourceType(source)
        cpTable = parseSkel(skel, commentPattern, idGenerator)
        cpTable = parseCsv(fpath, csvColOrder, expName, scale)
        skel = writeToSkel(skel, cpTable)
    end
    
   
end

