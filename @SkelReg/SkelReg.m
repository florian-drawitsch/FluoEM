classdef SkelReg
    %SKELREG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        skeletons = struct();
        parameters = struct();
        cp = trafo.Cp();
        trafoAT = trafo.Affine();
        trafoFT = trafo.Freeform();
    end
    
    methods
        
        function obj = SkelReg(fnameMoving, fnameFixed, commentPattern, idGenerator)
            %SKELREG Construct an instance of this class
            %   Detailed explanation goes here
            
            % If passed, load skeletons.moving
            if exist('fnameMoving', 'var') && ~isempty(fnameMoving)
                obj = obj.skelLoad(fnameMoving, 'moving') ;
            end
            
            % If passed, load skeletons.fixed
            if exist('fnameFixed', 'var') && ~isempty(fnameFixed)
                obj = obj.skelLoad(fnameFixed, 'fixed') ;
            end
            
            % Define default commentPattern
            if ~exist('commentPattern','var') || isempty(commentPattern)
                obj.parameters.commentPattern = '^b\d+$';
            end
            
            % Define default idGenerator for controlPoint Tables
            if ~exist('idGenerator','var') || isempty(idGenerator)
                obj.parameters.idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
            end
            
            % Read control points from skeletons
            obj = cpRead(obj);
        end
        
    end
    
    methods (Static = true)
        
        function pass = assertSkelType(skelType)
            validTypes = {'moving', 'fixed', 'moving_at', 'moving_at_ft'};
            msg = ['Skel type: ',skelType,' is invalid. ', ...
                'Valid skel types are: ', sprintf('''%s'' ', validTypes{:})];
            assert(all(ismember(skelType, validTypes)), msg);
            pass = true;
        end
        
    end
    
end

