classdef SkelReg
%SkelReg facilitates working with correlated neurite skeleton representations 
% SkelReg allows for efficient control point-based skeleton registration,
% as well as evaluation and visualisation of correlated skeleton tuples.
% 
% CONSTRUCTOR INPUT:    fpathEM (optional): Full path to webKnossos
%                           skeleton (.nml) file containing EM annotations
%                           (registration reference). File selection dialog
%                           box is opened when not provided.
%                       fpathLM (optional): Full path to webKnossos
%                           skeleton (.nml) file containing LM annotations
%                           (registration target). File selection dialog
%                           box is opened when not provided.
%
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
%         Max Planck Institute for Brain Research | Frankfurt | Germany
    
    properties
        paths = struct();
        skeletons = struct();
        controlPoints = struct();
        transformations = struct();
    end
    
    methods
        function obj = SkelReg(fpathEM, fpathLM)
            % Open dialog box if fpathEM is not provided
            if ~exist('fpathEM','var') || isempty(fpathEM)
                [file, path] = uigetfile('*.nml','Select webKnossos (.nml) file containing EM skeleton tracings');
                fpathEM = fullfile(path,file);
            end
            obj.paths.fpathEM = fpathEM;
            % Construct skeleton object
            obj.skeletons.em = Skeleton(obj.paths.fpathEM);
            
            % Open dialog box if fpathLM is not provided
            if ~exist('fpathLM','var') || isempty(fpathLM)
                [file, path] = uigetfile('*.nml','Select webKnossos (.nml) file containing LM skeleton tracings');
                fpathLM = fullfile(path,file);
            end
            obj.paths.fpathLM = fpathLM;
            % Construct skeleton object
            obj.skeletons.lm = Skeleton(fpathLM);

            % Construct control point table
            obj = readControlPoints(obj);
            obj = matchControlPoints(obj);
        end
    end
    
    methods (Static)
        commentsTable = comments2table(skel, columnSuffix, commentPattern, idGenerator)
        skel = table2comments(skel, commentsTable);
    end
end

