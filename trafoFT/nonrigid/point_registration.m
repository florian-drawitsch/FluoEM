function [O_trans,Spacing,Xreg]=point_registration(sizeI,Xmoving,Xstatic, initialSpacing, Options)
% This function creates a 2D or 3D b-spline grid, which transform space to
% fit a set of points Xmoving to set of corresponding points in  Xstatic. 
% Usefull for:
% - For image-registration based on corresponding landmarks like in
% Sift or OpenSurf (see Mathworks). 
% - 2D and 3D Spline based Data gridding and surface fitting
% - Smooth filtering of 2d / 3D Point data.
%
%   [O_trans,Spacing,Xreg]=point_registration(sizeI,Xstatic,Xmoving,Options);
%
% Inputs,
%   sizeI : The size of the (virtual) image/space which will be warped
%            With the b-spline grid
%   Xmoving : List with 2D or 3D points N x 2, or N x 3, these points will be
%            warped be the fitted b-sline grid to transform to the 
%            static points in Xstatic
%   Xstatic : List with 2D or 3D points N x 2, or N x 3, corresponding with Xmoving
%   Options : Struct with options, see below.
%
% Outputs,
%   Grid: The b-spline controlpoints, can be used to transform another
%       image in the same way: I=bspline_transform(Grid,I,Spacing);
%   Spacing: The uniform b-spline knot spacing
%   Xreg: The points in Xmoving transformed by the fitted b-spline grid.
%
% Options,
%   Options.Verbose: Display Debug information 0,1 or 2
%   Options.MaxRef : Maximum number of grid refinements steps (default 5)
%
%  Function is written by D.Kroon University of Twente (August 2010)

% Disable warning
warning('off', 'MATLAB:maxNumCompThreads:Deprecated')

% Process inputs
defaultoptions=struct('Verbose',false,'MaxRef',5);
if(~exist('Options','var')), Options=defaultoptions;
else
    tags = fieldnames(defaultoptions);
    for i=1:length(tags), if(~isfield(Options,tags{i})), Options.(tags{i})=defaultoptions.(tags{i}); end, end
    if(length(tags)~=length(fieldnames(Options)))
        warning('register_images:unknownoption','unknown options found');
    end
end

% Calculate max refinements steps
MaxItt=min(floor(log2(sizeI(1:3)/2)));

% set b-spline grid spacing in x,y and z direction
Spacing=[2^MaxItt 2^MaxItt 2^MaxItt];

if exist('initialSpacing','var') 
    Spacing = repmat(initialSpacing,[1 3]);
end

% Make an initial uniform b-spline grid
O_ref = make_init_grid(Spacing,sizeI);

% Calculate difference between the points
R=Xstatic-Xmoving;

% Initialize the grid-update needed to b-spline register the points
O_add=zeros(size(O_ref));

% Loop through all refinement itterations
for i=1:Options.MaxRef
    if(Options.Verbose)
        disp('.');
        disp(['Iteration : ' num2str(i) '/' num2str(Options.MaxRef)]);
        disp(['Grid size : ',num2str(size(O_ref))]);
    end
    
    % Make a b-spline grid which minimizes the difference between the
    % corresponding points
    O_add=bspline_grid_fitting(O_add,Spacing,R,Xmoving);
    
    % Warp the points
    Xreg=bspline_trans_points_double((O_ref+O_add),Spacing,Xmoving);
    
    % Calculate the remaining difference between the points
    R=Xstatic-Xreg;
    if(Options.Verbose)
        err=sqrt(sum(R.^2,2));
        disp(['Mean Distance : ',num2str(mean(err))]);
    end
    
    if(i<Options.MaxRef)
        % Refine the update-grid and reference grid
        switch(size(Xstatic,2))
            case 2
                O_add = refine_grid(O_add,Spacing,sizeI(1:2));
                [O_ref ,Spacing]=refine_grid(O_ref,Spacing,sizeI(1:2));
            case 3
                O_add = refine_grid(O_add,Spacing,sizeI);
                [O_ref ,Spacing]=refine_grid(O_ref,Spacing,sizeI);
        end
    end
end
% The final transformation grid, is the reference grid with update-grid
% added
O_trans=O_ref+O_add;
 