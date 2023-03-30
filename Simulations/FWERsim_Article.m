function store_data = FWERsim_Article( D, fwhm_vec, nsubj_vec, field_type, ...
                                                        mask_name, niters )
% FWERSIM_Article( D, fwhm_vec, nsubj_vec, field_type, mask_name, niters )
% performs simulations for the convolution theory papers
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% D         an integer between 1 and 3 giving the dimension
% fwhm_vec  a vector each entry of which is a different FWHM with which to 
%           smooth
% nsubj_vec a vector each entry of which is a different number of subjects 
%           to used
% field_type  either "stationary" or "nonstationary"
% mask_name either "box" or "sphere"
% Optional
% niters    the number of iterations with which to test the coverage.
%           Default is 5000
%--------------------------------------------------------------------------
% OUTPUT
% store_data    a cell array of size length(fwhm_vec) by length(nsubj_vec)
%               each entry of which is the coverage data for the specificed
%               FWHM and number of subjects
%--------------------------------------------------------------------------
% EXAMPLES
% store_data = FWERsim_Article( 1, [1,3], 10, "stationary", "box", 1000)
% store_data = FWERsim_Article( 2, 3, 10, "stationary", "box", 100)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

addpath(genpath("~/MatlabToolboxes/RFTtoolbox"))

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'niters', 'var' )
   % Default value
   niters = 5000;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
switch D
    case 1
        % Length of the domain
        T = 100;

        % Dimension of domain
        dim   = [ T 1 ];
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = mask_box;
        mask_sphere( [2 4 8 9 11 15 20:22 40:45 60 62 64 65 98:100] ) = 0;
        mask_sphere = ~mask_sphere;
        
    case 2
        % Length of the domain
        T = 20;

        % Dimension of domain
        dim   = [ T T ];
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = true( dim );
        mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
        mask_sphere = dilate_mask( mask_sphere, 1 );
        
    case 3
        % Length of the domain
        T = 20;

        % Dimension of domain
        dim   = [ T T T ];
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = true( dim );
        mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
        mask_sphere = dilate_mask( mask_sphere, 1 );
end

% Name of scenario
if strcmp( field_type, "stationary" )
    case_name = "_stationary";
    % Field does not get masked before application of convolutions to prevent
    % non-stationary effects caused by the boundary.
    mask_lat = false;
elseif strcmp( field_type, "nonstationary" )
    case_name = "_nonstationary";
    % Field does not get masked before application of convolutions to prevent
    % non-stationary effects caused by the boundary.
    mask_lat = true;
else
    error('The specified field_type is not an option')
end

if strcmp( mask_name, "box" )
    case_name = strcat( case_name, "_box" );
    % Get the mask
    mask = mask_box;
elseif strcmp( mask_name, "sphere" )
    case_name = strcat( case_name, "_sphere" );
    % Get the mask
    mask = mask_sphere;
else
    error('The specified mask_name is not an option')
end

store_data = cell(length(fwhm_vec), length(nsubj_vec));
for I = 1:length(fwhm_vec)
    resadd = 1;
    params = ConvFieldParams(repmat(fwhm_vec(I),D), resadd, ceil( resadd / 2 ), mask_lat);
    spfn = @(nsubj) wfield( mask, nsubj );
    for J = 1:length(nsubj_vec)
        store_data{I,J} = record_coverage( spfn, nsubj_vec(J), params, niters );
    end
end

end

