classdef Freeform < trafo.Trafo
    %FREEFORM Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Freeform()
        end
    end
    
    methods (Static = true)
        
        function points_ft = transformArray(points_at, grid, spacing, direction)
            %TRANSFORMARRAY Free-form transformation of array
            
            if ~exist('direction', 'var')
                direction = 'forward';
            end
            
            switch direction
                case 'forward'
                    g = 1;
                case 'inverse'
                    g = -1;
            end
            
            % Transform array
            points_ft = bspline_trans_points_double(g*grid, spacing, points_at);
        end
        
        function skel_ft = transformSkel( skel_at, grid, spacing, direction )
            %TRANSFORMSKEL Free-form transformation of skeleton object
            
            if ~exist('direction', 'var')
                direction = 'forward';
            end
            
            % Transform all trees
            skel_ft = skel_at;
            for treeIdx = 1:skel_at.numTrees
                nodes_ft = round(trafo.Freeform.transformArray(skel_at.nodes{treeIdx}(:,1:3), grid, spacing, direction));
                skel_ft = skel_ft.replaceNodes(treeIdx, nodes_ft);
            end           
        end
        
    end
end

