classdef Cp
    %CONTROLPOINTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        points = struct();
    end
    
    methods
        function obj = Cp(sourceMoving, sourceFixed, varargin)
            %CONTROLPOINTS Construct an instance of this class
            %   Detailed explanation goes here
            
            % Parse varargin
            p = inputParser;
            
            defaultCommentPattern = '^b\d+$';
            p.addOptional('commentPattern', defaultCommentPattern);
            
            defaultIdGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
            p.addOptional('idGenerator', defaultIdGenerator);
            
            defaultCsvColOrder = {'id','x','y','z'};
            p.addOptional('csvColOrder', defaultCsvColOrder);
            
            defaultExpNameMoving = 'moving';
            p.addOptional('expNameMoving', defaultExpNameMoving);
            
            defaultExpNameFixed = 'fixed';
            p.addOptional('expNameFixed', defaultExpNameFixed);
            
            defaultScaleMoving = [1 1 1];
            p.addOptional('scaleMoving', defaultScaleMoving);
                               
            defaultScaleFixed = [1 1 1];
            p.addOptional('scaleFixed', defaultScaleFixed);
            
            p.parse(varargin{:});
            
            
            % Read moving control points from given source type
            switch trafo.Cp.getSourceType(sourceMoving)
                case 'skel'
                    cpTabMoving = trafo.Cp.readFromSkel(sourceMoving, p.Results.commentPattern, p.Results.idGenerator);
                    
                case 'nml'
                    cpTabMoving = trafo.Cp.readFromSkel(Skeleton(sourceMoving), p.Results.commentPattern, p.Results.idGenerator);
                    
                case 'csv'
                    cpTabMoving = trafo.Cp.readFromCsv(sourceFixed, p.Results.csvColOrder, p.Results.expNameMoving, p.Results.scaleMoving);   
            end
            obj.points.moving = cpTabMoving;
            
            % Read fixed control points from given source type
            switch trafo.Cp.getSourceType(sourceFixed)
                case 'skel'
                    cpTabFixed = trafo.Cp.readFromSkel(sourceFixed, p.Results.commentPattern, p.Results.idGenerator);
                    
                case 'nml'
                    cpTabFixed = trafo.Cp.readFromSkel(Skeleton(sourceFixed), p.Results.commentPattern, p.Results.idGenerator);
                    
                case 'csv'
                    cpTabFixed = trafo.Cp.readFromCsv(sourceFixed, p.Results.csvColOrder, p.Results.expNameFixed, p.Results.scaleFixed);    
            end     
            obj.points.fixed = cpTabFixed;
            
            % Match control points
            obj = obj.match;
            
        end
    end
    
    
    
    methods (Static = true)
        sourceType = getSourceType(source)
        cpTable = readFromSkel(skel, commentPattern, idGenerator)
        cpTable = readFromCsv(fpath, csvColOrder, expName, scale)
    end
    
   
end

