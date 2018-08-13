classdef SkelDiv
    %SkelDiv facilitates measuring skeleton divergence 
    % The skelDiv object holds a reference skeleton object and a target 
    % skeleton object with both arbitrary numbers of trees as well as a
    % origin bounding box defining the commong origin of these trees.
    % It can be used both to perform all-to-all divergence measurements
    % (see FluoEM Fig. 2) as well as one-to-all divergence measurements
    % used for correspondence matching (see Fluo Fig. 4)
    % Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
    
    properties
        skelRef = Skeleton();
        skelTar = Skeleton();
        options = struct();
        results = struct();
    end
    
    methods
        function obj = SkelDiv(nmlPathRef, nmlPathTar, bboxOrigin, varargin)
            %SKELDIV Constructs a skelDiv object
            %   INPUT:  nmlPathRef: str
            %               Path to reference .nml file containing the
            %               reference skeleton object
            %           nmlPathTar: str
            %               Path to target .nml file containing the target
            %               skeleton object
            %           bboxOrigin: [1 x 6] double
            %               Common bounding box from which the skeleton
            %               trees originate
            %   INPUT (varargin: name, value pairs)
            %           bboxRestrictActive (optional): boolean
            %               If active, all skeleton nodes outside the
            %               specified diameter (see bboxRestrictExtent)
            %               relative to the bboxOrigin center point are
            %               pruned away before starting the divergence
            %               measurement
            %               (Default: false)
            %           bboxRestrictExtent (optional): double
            %               Restriction diameter around the bboxOrigin
            %               center point in nm
            %               (Default: 1E5)
            %           ellipsoidRadii (optional): [1 x 3] double
            %               Cardinal axes radii defining the neighbor
            %               criterion ellipsoid in nm
            %               (Default: [5000 5000 5000]
            %           binSize (optional): double
            %               Bin size defining the magnitude of euclidean 
            %               distance intervals into which nodes are lumped
            %               in nm
            %               (Default: 2500)
            %           verbose (optional): boolean
            %               If true, progress information is displayed
            %               during divergence measurement
            %               (Default: false)
            %           plotRangeX (optional): [1 x 2] double
            %               Euclidean distance range for which should be 
            %               plotted in um
            %               (Default: [0 100]
            %           plotAddY (optional): double
            %               Constant added to y scale of plot
            %               (Default: 0)
            
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
            default.bboxRestrictExtent = 1E5;
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
            default.plotAddY = 0;
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

