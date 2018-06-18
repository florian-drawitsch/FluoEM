function trafo = exportTransformation( obj, outputPath )
%EXPORTTRANSFORMATION Exports transformations stored in the internal state
%   INPUT:  outputPath: (optional) str
%               If specified, the transformation structure is written to
%               the outputPath as a mat file
%   OUPUT:  trafo: struct
%               Structure holding the transformations
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

trafo = obj.transformations;

if exist('outputPath','var')
    save(outputPath, 'trafo');
end

end

