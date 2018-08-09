classdef Freeform < trafo.Trafo
    %FREEFORM Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Freeform()
        end
    end
    
    methods (Static = true)
        
        function points_at_ft = transformArray(points_at, scale, grid, spacing)
            %TRANSFORMARRAY Free-form transformation of array
                       
            % Affine transform from voxel space to nm space
            A = diag([scale, 1]);
            points_at_nm = trafo.Affine.transformArray(points_at, A, 'forward');
            
            % Free-form transform array
            points_at_ft_nm = bspline_trans_points_double(grid, spacing, points_at_nm);
            
            % Affine transform back from nm space to voxel space
            points_at_ft = trafo.Affine.transformArray(points_at_ft_nm, A, 'inverse');
        end
        
        function skel_at_ft = transformSkel( skel_at, scale, grid, spacing )
            %TRANSFORMSKEL Free-form transformation of skeleton object
            
            % Transform all trees
            skel_at_ft = skel_at;
            for treeIdx = 1:skel_at.numTrees
                nodes_ft = round(trafo.Freeform.transformArray(skel_at.nodes{treeIdx}(:,1:3), scale, grid, spacing));
                skel_at_ft = skel_at_ft.replaceNodes(treeIdx, nodes_ft);
            end           
        end
        
    end
end

