classdef SkelReg
    %SkelReg facilitates working with correlated neurite skeleton representations
    % SkelReg allows for efficient control point-based skeleton registration,
    % as well as evaluation and visualisation of correlated skeleton tuples.
    % Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
    
    properties
        skeletons = struct();
        cp = trafo.Cp();
        affine = trafo.Affine();
        freeform = trafo.Freeform();
        parameters = struct();
    end
    
    methods
        
        function obj = SkelReg(nmlPathMoving, nmlPathFixed, commentPattern, idGenerator)
            %The SkelReg constructor loads two correlated skeleton files and
            % defines rules for parsing registration control points from the
            % comments embedded in the skeletons as well as for generating
            % unique ids from these comments allowing to match them.
            %   INPUT:  nmlPathMoving (optional): str
            %               Full path to webKnossos (.nml) file containing
            %               skeleton annotations and comments (registration
            %               source).
            %           nmlPathFixed (optional): str
            %               Full path to webKnossos (.nml) file containing
            %               skeleton annotations and comments (registration
            %               reference).
            %           commentPattern (optional): str
            %               Regular expression pattern specifying the
            %               pattern of skeleton comments to be read as
            %               control points
            %               (Default: commentPattern = '^b\d+$', reads all
            %               comments starting with the letter 'b' followed
            %               by one or more numeric digits, e.g. b7, b21,
            %               etc.)
            %           idGenerator (optional): function handle or anonymous
            %               function. Defines the rule creating table ids
            %               from webKnossos tree names and comments. These
            %               table ids are used for the table join
            %               operations matching the control point tables of
            %               the modalities to be registered.
            %               (Default: idGenerator = @(x,y) sprintf(...
            %                   '%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y)
            %               generates unique cp ids by appending the part
            %               of the tree name leading an underscore to the
            %               comment. The combination of tree name = 'ax1_lm'
            %               and comment 'b1' would lead to an id of
            %               'ax1_b1' using the default idGenerator)
            % Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
            
            % If passed, load skeletons.moving
            if exist('nmlPathMoving', 'var') && ~isempty(nmlPathMoving)
                obj = obj.skelReadFromNml(nmlPathMoving, 'moving') ;
            end
            
            % If passed, load skeletons.fixed
            if exist('nmlPathFixed', 'var') && ~isempty(nmlPathFixed)
                obj = obj.skelReadFromNml(nmlPathFixed, 'fixed') ;
            end
            
            % Define default commentPattern if required and assign to object
            if ~exist('commentPattern','var') || isempty(commentPattern)
                commentPattern = '^b\d+$';
            end
            obj.parameters.commentPattern = commentPattern;
            
            % Define default idGenerator if required and assign to object
            if ~exist('idGenerator','var') || isempty(idGenerator)
                idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
            end
            obj.parameters.idGenerator = idGenerator;
            
            % Read control points from skeletons
            obj = obj.cpReadFromSkel;
        end
        
        function pass = assertModalityAvailability(obj, modalityType, propertyType)
            %ASSERTMODALITYAVAILABILITY asserts the availability of the
            %specified modality type as a field of the specified
            %propertyType object property
            if ischar(propertyType)
                propertyType = {propertyType};
            end
            switch numel(propertyType)
                case 1
                    cond = @(x,y) ismember(x, fieldnames(obj.(y{1})));
                case 2
                    cond = @(x,y) ismember(x, fieldnames(obj.(y{1}).(y{2})));
                case 3
                    cond = @(x,y) ismember(x, fieldnames(obj.(y{1}).(y{2}).(y{3})));
            end
            msg = ['Modality type: ''',modalityType,''' is not available in the ',...
                sprintf('.%s', propertyType{:}), ' property. If you see',...
                ' this assertion failure when attempting to compute or',...
                ' apply a freeform (at_ft) transformation, try to compute', ...
                ' an affine transformation first'];
            assert(cond(modalityType, propertyType), msg);
            pass = true;
        end
        
        function pass = assertTrafoAvailability(obj, trafoType)
            %ASSERTTRAFOAVAILABILITY asserts the availability of the
            %specified transformation
            switch trafoType
                case 'at'
                    cond = isfield(obj.affine.trafo, 'A');
                case 'at_ft'
                    cond = isfield(obj.freeform.trafo, 'grid');
            end
            msg = ['Trafo type ''',trafoType,''' not available. ', ...
                    'Please compute the respective transformation first'];
            assert(cond,msg)
            pass = true;
        end
        
        function pass = assertSkeletonAvailability(obj, trafoType)
            %ASSERTSKELETONAVAILABILITY asserts the availability of the
            %specified skeleton
            cond = @(x) isfield(obj.skeletons, x);
            msg = ['Skeleton type ''',trafoType,''' not available. ', ...
                'Please apply the respective transformation first'];
            assert(cond(trafoType),msg)
            pass = true;
        end
        
    end
    
    methods (Static = true)
        
        function pass = assertModalityType(modalityType)
            %ASSERTMODALITYTYPE asserts if the specified modalityType is
            %amongst the valid types
            validTypes = {'moving', 'fixed', 'moving_at', 'moving_at_ft'};
            cond = @(x) all(ismember(x, validTypes));
            msg = ['Modality type: ',modalityType,' is invalid. ', ...
                'Valid modality types are: ', sprintf('''%s'' ', validTypes{:})];
            assert(cond(modalityType), msg);
            pass = true;
        end
        
        function pass = assertTrafoType(trafoType)
            %ASSERTTRAFOTYPE asserts if the specified trafoType is
            %amongst the valid types
            validTypes = {'at', 'at_ft'};
            cond = @(x) all(ismember(x, validTypes));
            msg = ['Trafo type: ',trafoType,' is invalid. ', ...
                'Valid trafo types are: ', sprintf('''%s'' ', validTypes{:})];
            assert(cond(trafoType), msg);
            pass = true;
        end
        
        obj = load(loadPath);
        
    end
    
end

