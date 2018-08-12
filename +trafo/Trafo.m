classdef Trafo
    %TRAFO defines common properties and methods of transformation objects
    % It represents a minimal abstract superclass defining common 
    % properties and methods which it's Affine and Freeform subclasses 
    % inherit.
    % Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
    
    properties
        trafo = struct();
        attributes = struct();
    end
    
    methods
        function obj = Trafo()
            %The Trafo constructor creates an empty trafo object.
        end
        
        function save(obj, savePath)
            %SAVE Saves a trafo object to a mat file
            save(savePath, 'obj');
        end
    end
    
    methods (Static = true)
        function obj = load(loadPath)
            %LOAD Loads a trafo object from a mat file
            tmp = load(loadPath);
            obj = tmp.obj;
        end
    end
    
end

