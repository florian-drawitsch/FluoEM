classdef Affine < trafo.Trafo
    %AFFINE defines the 3D affine transformation class
    % It encompasses the properties and methods needed to compute 3D affine
    % transformations and to apply them to arrays of points or skeleton
    % objects
    % Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
    
    methods
        function obj = Affine()
            %The Affine constructor creates an empty affine object.
            % Use it's compute method to compute an affine transformation
            % and the applyToArray or applyToSkel methods to apply it to an
            % array or a skeleton object, respectively.
        end
    end
    
    methods (Static)
        
        function points_at = transformArray(points, A, direction)
            %TRANSFORMARRAY affine transforms arrays of points
            %   INPUT:  points: [N x 3] double
            %               Points to be transformed
            %           A: [4 x 4] double
            %               Transformation matrix of type
            %               [rs rs rs t, ...
            %                rs rs rs t, ...
            %                rs rs rs t, ...
            %                 0  0  0 1]
            %           direction (optional): str
            %               Direction of affine transformation.
            %               'forward' applies the affine transformation in
            %               the forward direction, 'inverse' applies it in
            %               the inverse direction
            %               (Default: 'forward')
            %   OUTPUT: points_at: [N x 3] double
            %               Affine transformed points
            
            if ~exist('direction', 'var')
                direction = 'forward';
            end
            
            if strcmp(direction,'inverse')
                A = inv(A);
            end
            
            % Pad points to allow for efficient matrix multiplication
            points = [points'; ones([1 size(points, 1)])];
            
            % Transform array
            points_at = A * points;
            
            % Crop points back to original size
            points_at = points_at(1:3, :)';
        end
        
        function skel_at = transformSkel( skel, A, scaleNew, datasetNew, direction )
            %TRANSFORMSKEL affine transforms a skeleton object
            %   INPUT:  skel: skeleton object
            %               Skeleton object to be transformed
            %           A: [4 x 4] double
            %               Transformation matrix of type
            %               [rs rs rs t, ...
            %                rs rs rs t, ...
            %                rs rs rs t, ...
            %                 0  0  0 1]
            %           scaleNew (optional): [1 x 3] double
            %               Nominal voxel size of the target reference frame
            %               to be written into the skeleton properties
            %               (Default: [1 1 1])
            %           datasetNew (optional): str
            %               Dataset name corresponding to the target
            %               reference frame
            %               (Default: '')
            %           direction (optional): str
            %               Direction of affine transformation.
            %               'forward' applies the affine transformation in
            %               the forward direction, 'inverse' applies it in
            %               the inverse direction
            %               (Default: 'forward')
            %   OUTPUT: skel_at: skeleton object
            %               Affine transformed skeleton object
            
            if ~exist('scaleNew','var') || isempty(scaleNew)
                scaleNew = [1 1 1];
            end
            
            if ~exist('datasetNew', 'var') || isempty(datasetNew)
                datasetNew = '';
            end
            
            if ~exist('direction','var')
                direction = 'forward';
            end
            
            % Transform all trees
            skel_at = skel;
            for treeIdx = 1:skel.numTrees
                nodes_at = round(trafo.Affine.transformArray(skel.nodes{treeIdx}(:,1:3), A, direction));
                skel_at = skel_at.replaceNodes(treeIdx, nodes_at);
            end
            
            % Adapt Scale
            skel_at = skel_at.adaptScale(scaleNew);
            
            % Adapt datasetName
            skel_at.parameters.experiment.name = datasetNew;
        end
    end
end
