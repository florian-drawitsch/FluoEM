classdef Affine < trafo.Trafo
    %AFFINE Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Affine()
        end
    end
    
    methods (Static)
        
        function points_at = transformArray(points, A, direction)
            %TRANSFORMARRAY Affine transformation of array
            
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
            %TRANSFORMSKEL Affine transformation of skeleton object
            
            if ~exist('scaleNew','var') || isempty(scaleNew)
                switch direction
                    case 'forward'
                        scaleNew = skel.scale./diag(A(1:3,1:3))';
                    case 'inverse'
                        scaleNew = skel.scale./diag(inv(A(1:3,1:3)))';
                end
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
