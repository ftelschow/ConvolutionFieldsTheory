function [] = LKCsim_3D_L1true( Msim, out, path )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
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
    path = '/home/fabian/Seafile/Projects/2020_ConvolutionFieldsTheory/Code/';
end

if isnumeric( out )
    out = num2str( out );
end

% Amount of Monte Carlo simulations
if ~exist( 'Msim', 'var' )
    Msim = 1e2;
end

%--------------------------------------------------------------------------
%% Prepare workspace
%--------------------------------------------------------------------------
if ~exist( 'path', 'var' )
%    path = '/vols/Scratch/ukbiobank/nichols/SelectiveInf/ConvolutionFieldsTheory/';
%    path = '/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/';
    path = '~/MatlabToolboxes/ConvolutionFieldsTheory/';
end

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
% Length of the domain
T = 20;

% Dimension of domain
dim   = [ T T T ];
        
% Resolution for obtaining the true LKCs
theory_res = 1;
        
% Get the masks
mask_box = true( dim );
mask_sphere = true( dim );
mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
mask_sphere = dilate_mask( mask_sphere, 1 );

% Amount of bootstrap replicates for bHPE
Mboot = 1e2;

% Vector for FWHM dependence
FWHM = [ 1 2 3 4 5 6 ];

% Vector for sample size dependence
Nsubj = 20;

% Vector for resadd dependence
Resadd = 7;
              
% Methods compared in this simulation
methods = struct( 'bHPE', [ Mboot, 1 ] );
              
% String for output
outname = "Sim_LKC_true_";


%--------------------------------------------------------------------------
%% Simulations of LKCs of Random Fields
%--------------------------------------------------------------------------
case_name = "_nonstationary";
% Field does not get masked before application of convolutions to prevent
% non-stationary effects caused by the boundary.
mask_lat = true;

case_name = strcat( case_name, "_sphere" );
% Get the mask
mask = mask_sphere;

nsubj = Nsubj;
[ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                nsubj,...
                                                FWHM,...
                                                Resadd,...
                                                methods,...
                                                mask,...
                                                mask_lat,...
                                                theory_res );

save( strcat( path_results, outname, 'D3', case_name, '_fixednsubj_', out,'.mat' ),...
              'nsubj', 'methods', 'FWHM', 'Resadd',...
              'dim', 'Mboot', 'Msim', 'theoryL',...
              'results', 'sim_time' );
clear nsuj results theoryL sim_time mask mask_lat
end
