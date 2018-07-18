function obj = trafoImport( obj, trafo )
%IMPORTTRANSFORMATION Imports the transformation into the internal state
%   INPUT:  trafo: struct or str
%               The transformation to be imported can be provided either 
%               directly as transformation struct or as a path to a mat 
%               file holding the transformation struct          
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>     

if exist(trafo,'file') > 0
   load(trafo,'trafo'); 
end

if isa(trafo,'struct')
    obj.transformations = trafo;
else
    error(...
        ['Provided transformation should either be a transformation ',...
        'struct or a mat file containing the transformation struct. ',...
        'Export transformations using the trafoExport method',...
        ]);
end

end

