function [] = LKCsim_Article_Timing( D, out, path )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   fwhm_switch  logical true means that fwhm is fixed in this simulation,
%                false means that Nsubj is fixed
%   field_name   either "stationary" or "nonstationary"
%   mask_name    either "box" or "sphere"
%   D            dimension of the domain
% Optional
%   Msim         number of MC runs. Default 1e3.
%   out          string or numeric
%
%--------------------------------------------------------------------------
% OUTPUT
% obj  an object of class Fields representing white noise, which is not
%      masked. 
%
%--------------------------------------------------------------------------
%% Check input
%--------------------------------------------------------------------------
if ~exist( 'out', 'var' )
    out = "";
end

if ~exist( 'path', 'var' )
%    path = '/vols/Scratch/ukbiobank/nichols/SelectiveInf/ConvolutionFieldsTheory/';
%    path = '/home/fabian/Seafile/Code/matlabToolboxes/ConvolutionFieldsTheory/';
    path = '~/MatlabToolboxes/ConvolutionFieldsTheory/';
end

if isnumeric( out )
    out = num2str( out );
end

Msim = 100;

%--------------------------------------------------------------------------
%% Prepare workspace
%--------------------------------------------------------------------------
% Add the toolbox to the path 
% path_toolbox = '/home/drtea/matlabToolboxes/RFTtoolbox';
path_toolbox = '~/MatlabToolboxes/RFTtoolbox';
addpath(genpath(path_toolbox))

% Add path to simulation code
addpath( strcat( path, 'Simulations' ) )

% Add path for results
path_results = strcat( path, 'Results/' );


%--------------------------------------------------------------------------
%% Parameters for the Simulations 
%--------------------------------------------------------------------------
switch D
    case 1
        % Length of the domain
        T = 100;

        % Dimension of domain
        dim   = [ T 1 ];
        
        % Resolution for obtaining the true LKCs
        theory_res = 21;
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = mask_box;
        mask_sphere( [ 1:3 (T-3):T ] ) = 0;
        mask_sphere = ~mask_sphere;
        
    case 2
        % Length of the domain
        T = 30;

        % Dimension of domain
        dim   = [ T T ];
        
        % Resolution for obtaining the true LKCs
        theory_res = 11;
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = true( dim );
        mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
        
    case 3
        % Length of the domain
        T = 20;

        % Dimension of domain
        dim   = [ T T T ];
        
        % Resolution for obtaining the true LKCs
        theory_res = 7;
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = true( dim );
        mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
        mask_sphere = dilate_mask( mask_sphere, 1 );
end

% Amount of bootstrap replicates for bHPE
Mboot = 2e3;

% FWHM
fwhm = 3;

% Vector for sample size dependence
Nsubj = 100;

% Vector for resadd dependence
Resadd = [ 1 3 5 ];

% String for output
outname = "Sim_Timing_LKCestims";

% Name of scenario
mask  = mask_box;

%--------------------------------------------------------------------------
%% Simulations of LKCs of Random Fields
%--------------------------------------------------------------------------
%%%%%% Dependence on sample size
[results, theoryL, sim_time] = LKCsimulation_Timing(...
                                              Msim,...
                                              Nsubj,...
                                              fwhm,...
                                              Resadd,...
                                              mask,...
                                              theory_res, Mboot );

save( strcat( path_results, outname, '_D',...
              num2str(D), out,'.mat' ),...
              'D', 'fwhm', 'Nsubj', 'fwhm', 'Resadd',...
              'dim', 'Mboot', 'Msim', 'theoryL',...
              'results', 'sim_time' );     
clear fwhm results theoryL sim_time
