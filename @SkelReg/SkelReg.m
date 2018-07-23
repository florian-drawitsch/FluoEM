classdef SkelReg
%SkelReg facilitates working with correlated neurite skeleton representations 
% SkelReg allows for efficient control point-based skeleton registration,
% as well as evaluation and visualisation of correlated skeleton tuples. 
%   CONSTRUCTOR:
%   INPUT:  fpathLM (optional): str
%               Full path to webKnossos skeleton (.nml) file containing
%               LM annotations (registration target). 
%           fpathEM (optional): str
%               Full path to webKnossos skeleton (.nml) file containing EM
%               annotations (registration reference). 
%           commentPattern (optional): str
%               Regular expression pattern specifying which webKnossos
%               skeleton comments should be read as control points
%           idGenerator (optional): function handle or anonymous function
%               Defines the rule creating table ids from webKnossos tree
%               names. These table ids are used for the table join
%               operations matching the control point tables of the
%               modalities to be registered.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
%         Department of Connectomics
%         Max Planck Institute for Brain Research | Frankfurt | Germany    
    
    properties
        paths = struct();
        skeletons = struct();
        controlPoints = struct();
        transformations = struct();
    end
    
    methods
        function obj = SkelReg(fpathLM, fpathEM, commentPattern, idGenerator)
            
            % If path is provided construct LM skeleton object         
            if exist('fpathLM', 'var')
                obj.paths.fpathLM = fpathLM;
                obj.skeletons.lm = Skeleton(obj.paths.fpathLM);
            end
            
            % If path is provided construct EM skeleton object
            if exist('fpathEM', 'var')
                obj.paths.fpathEM = fpathEM;
                obj.skeletons.em = Skeleton(obj.paths.fpathEM);
            end

            % Define default commentPattern
            if ~exist('commentPattern','var') || isempty(commentPattern)
                commentPattern = '^b\d+$';
            end
            
            % Define default idGenerator for control point Tables
            if ~exist('idGenerator','var') || isempty(idGenerator)
                idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
            end
            
            % Construct control point tables
            obj = cpReadFromSkel(obj, commentPattern, idGenerator);
            obj = cpMatch(obj);
        end
    end
    
    methods (Static)
        commentsTable = comments2table(skel, columnSuffix, commentPattern, idGenerator)
        skel = table2comments(skel, commentsTable);
    end
end

