classdef Freeform < trafo.Trafo
    %FREEFORM defines the 3D freeform transformation class
    % It encompasses the properties and methods needed to compute 3D free-
    % form transformations and to apply them to arrays of points or
    % skeleton objects
    % Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
    
    methods
        function obj = Freeform()
            %The Freeform constructor creates an empty freeform object.
            % Use it's compute method to compute a freeform transformation
            % and the applyToArray or applyToSkel methods to apply it to an
            % array or a skeleton object, respectively.
        end
    end
    
    methods (Static = true)
        
        function points_at_ft = transformArray(points_at, scale, grid, spacing)
            %TRANSFORMARRAY freeform transforms arrays of points
            % Note that the freeform transformation is usually defined 
            % relative to an already affine ('at') pre-transformed reference. 
            %   INPUT:  points_at: [N x 3] double
            %               (Affine pre-transformed) points to be freeform
            %               transformed 
            %           scale: [1 x 3] double
            %               Nominal voxel size in the coordinate space in
            %               which the transformation is to be performed
            %           grid: [N x M x L] double
            %               Freeform deformation grid
            %           spacing: [1 x 3] double
            %               Spacing of the deformation grid nodes
            %   OUTPUT: points_at_ft: [N x 3] double
            %               Freeform transformed points
            
            % Affine transform from voxel space to nm space
            A = diag([scale, 1]);
            points_at_nm = trafo.Affine.transformArray(points_at, A, 'forward');
            
            % Free-form transform array
            points_at_ft_nm = bspline_trans_points_double(grid, spacing, points_at_nm);
            
            % Affine transform back from nm space to voxel space
            points_at_ft = trafo.Affine.transformArray(points_at_ft_nm, A, 'inverse');
        end
        
        function skel_at_ft = transformSkel( skel_at, scale, grid, spacing )
            %TRANSFORMSKEL freeform transforms a skeleton object
            % Note that the freeform transformation is usually defined 
            % relative to an already affine ('at') pre-transformed reference. 
            %   INPUT:  skel_at: skeleton object
            %               (Affine pre-transformed) skeleton object to be 
            %               freeform transformed
            %           scale: [1 x 3] double
            %               Nominal voxel size in the coordinate space in
            %               which the transformation is to be performed
            %           grid: [N x M x L] double
            %               Freeform deformation grid
            %           spacing: [1 x 3] double
            %               Spacing of the deformation grid nodes
            %   OUTPUT: skel_at_ft: skeleton object
            %               Freeform transformed skeleton object
            
            % Transform all trees
            skel_at_ft = skel_at;
            for treeIdx = 1:skel_at.numTrees
                nodes_ft = round(trafo.Freeform.transformArray(skel_at.nodes{treeIdx}(:,1:3), scale, grid, spacing));
                skel_at_ft = skel_at_ft.replaceNodes(treeIdx, nodes_ft);
            end
        end
        
    end
end

