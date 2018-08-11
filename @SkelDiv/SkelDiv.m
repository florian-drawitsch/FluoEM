classdef SkelDiv
    %SKELDIV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        skelRef = Skeleton();
        skelTar = Skeleton();
        options = struct();
        results = struct();
    end
    
    methods
        function obj = SkelDiv(nmlPathRef, nmlPathTar, bboxOrigin, varargin)
            %SKELDIV Construct an instance of this class
            %   Detailed explanation goes here
            
            % Assert and assign required inputs
            % nmlPathRef
            SkelDiv.assertNmlPath(nmlPathRef);
            obj.skelRef = Skeleton(nmlPathRef);
            
            % nmlPathTar
            SkelDiv.assertNmlPath(nmlPathTar);
            if strcmp(nmlPathRef, nmlPathTar)
                obj.options.refTarIdent = true;
                obj.skelTar = obj.skelRef;
            else
                obj.options.refTarIdent = false;
                obj.skelTar = Skeleton(nmlPathTar);
            end
            
            % bboxOrigin
            SkelDiv.assertBbox(bboxOrigin)
            obj.options.bboxOrigin = bboxOrigin;
            
            % Assert and assign optional arguments
            p = inputParser;
            
            % bboxRestrictActive
            default.bboxRestrictActive = false;
            check.bboxRestrictActive = @(x) islogical(x);
            p.addOptional('bboxRestrictActive', default.bboxRestrictActive, check.bboxRestrictActive);
            
            % bboxRestrictExtent
            default.bboxRestrictExtent = false;
            check.bboxRestrictExtent = @(x) isnumeric(x);
            p.addOptional('bboxRestrictExtent', default.bboxRestrictExtent, check.bboxRestrictExtent);
            
            % ellipsoidRadii
            default.ellipsoidRadii = [5000 5000 5000];
            check.ellipsoidRadii = @(x) isequal(size(x), [1 3]);
            p.addOptional('ellipsoidRadii', default.ellipsoidRadii, check.ellipsoidRadii);
            
            % binSize
            default.binSize = 2500;
            check.binSize = @(x) isnumeric(x);
            p.addOptional('binSize', default.binSize, check.binSize);
            
            % verbose
            default.verbose = false;
            check.verbose = @(x) islogical(x);
            p.addOptional('verbose', default.verbose, check.verbose);
            
            % plotRangeX
            default.plotRangeX = [0 100];
            check.plotRangeX = @(x) isequal(size(x), [1 2]);
            p.addOptional('plotRangeX', default.plotRangeX, check.plotRangeX);
            
            % plotAddY
            default.plotAddY = 1;
            check.plotAddY = @(x) isnumeric(x);
            p.addOptional('plotAddY', default.plotAddY, check.plotAddY);
            
            % Assign to object
            p.parse(varargin{:});
            fields = fieldnames(p.Results);
            for i = 1:numel(fields)
                obj.options.(fields{i}) = p.Results.(fields{i});
            end
        end
    end
    
    methods (Static = true)
        
        function pass = assertNmlPath(nmlPath)
            [~, ~, nmlExt] = fileparts(nmlPath);
            cond = @(x,y) isfile(x) && strcmp(y,'.nml');
            msg = [nmlPath, ' is not a valid file path to a .nml file.'];
            assert(cond(nmlPath, nmlExt), msg);
            pass = true;
        end
        
        function pass = assertBbox(bbox)
            cond = @(x) isequal(size(x), [1 6]);
            msg = 'Invalid bbox dimensions. Bbox must be of size [1 x 6]';
            assert(cond(bbox), msg);
            pass = true;
        end
        
        du = dUnique( dropToZeroDists, percentile );
        [uniqueFraction, uniqueFractionBins] = uniqueFraction( neighborCountsAll, distToOriginAll, binSize );
        nodesRefNeighbors = ellipsoidNhood( skelRef, skelRefTreeIdx, skelTar, skelTarTreeInds, ellipsoidRadii );
        [neighborCounts, neighborIDs, distToOrigin] = axonPersistence( skelRef, skelRefIdx, nodesRefNeighbors, origin );
        
    end
end

