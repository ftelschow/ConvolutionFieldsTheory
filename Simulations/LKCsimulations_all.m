%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%    Theory of Convolution Fields: LKC estimation
%%%%
%%%%    DESCRIPTION:
%%%%    This script simulates LKC estimates of convolution fields in 2D to
%%%%    reproduce the simulation results in Section ??? in Telschow et al
%%%%    (2020)
%%%%    It compares the noval LKC estimator to the bHPE from Telschow et al
%%%%    (2019) and the standard isotropic estimate
%%%%
%%%%    The main part of the code is included in the RFTtoolbox developed
%%%%    by Sam Davenport and Fabian Telschow.
%%%%
%%%%    Sources:
%%%%        Telschow, et al. (2019)
%%%%            "Estimation of Expected Euler Characteristic Curves of
%%%%             Nonstationary Smooth Gaussian Random Fields."
%%%%             arXiv preprint arXiv:1908.02493 (2019).
%%%%        Telschow, et al. (2020)
%%%%            "Exact FWER control using Convolution Random Fields."
%%%%             arXiv preprint arXiv:1908.02493 (2020).
%%%%        RFTtoolbox
%%%%            https://github.com/sjdavenport/RFTtoolbox
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
%% Prepare Workspace
%--------------------------------------------------------------------------
% Clear the current workspace
clear all
close all

server = ~true;

%----- BEGIN Change the next lines to make it run with your local installation!
if ~server
    % Add the RFTtoolbox to working path
    addpath( genpath("/home/drtea/matlabToolboxes/RFTtoolbox/") )

    % Add path to simulation code
    addpath( "/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/Simulations" )

    % Add path for results
    path_wd = "/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/Results/";
    
else
    path_CFthy = '/vols/Scratch/ukbiobank/nichols/SelectiveInf/ConvolutionFieldsTheory/';
    
    % Add the RFTtoolbox to working path
    addpath( genpath("/home/drtea/matlabToolboxes/RFTtoolbox/") )

    % Add path to simulation code
    addpath( [ path_CFthy, 'Simulations' ] )

    % Add path for results
    path_wd = [path_CFthy, 'Results'];
end

%----- END


%--------------------------------------------------------------------------
%% Parameters for the Simulations 
%--------------------------------------------------------------------------
%----- BEGIN Change the next lines to choose the dimension of the simulation!
% Dimension of Domain
D = 1;
% D = 2; 
% D = 3;

% Amount of Monte Carlo simulations
Msim = 2;
%----- END

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
        theory_res = 7;
        
        % Get the masks
        mask_box = true( dim );
        mask_sphere = true( dim );
        mask_sphere = bndry_voxels( logical( mask_sphere ), 'full' );
        
    case 3
        % Length of the domain
        T = 30;

        % Dimension of domain
        dim   = [ T T T ];
        
        % Resolution for obtaining the true LKCs
        theory_res = 7;
end

% Amount of bootstrap replicates for bHPE
Mboot = 1e3;

% Vector for FWHM dependence
FWHM = [ 1 1.5 2 3 4 5 6 ];

% Vector for sample size dependence
Nsubj = [ 20 50 100 150 ];

% Vector for resadd dependence
Resadd = [ 1 3 5 ];

% Methods compared in this simulation 
methods = struct( 'convE', true, 'bHPE', [ Mboot, 1 ], ...
                  'kiebelE', 1, 'formanE', 1 );
              
% String for output
outname = "Sim_LKCestims_";


%--------------------------------------------------------------------------
%% Simulations Stationary Random Field on Box 
%--------------------------------------------------------------------------
% Field does not get masked before application of convolutions to prevent
% non-stationary effects caused by the boundary.
mask_lat = false;

% Get the mask
mask = mask_box;

% Name of scenario
case_name = "_stationary_box";

%%%%%% Dependence on sample size
fwhm = FWHM(4);
[ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                Nsubj,...
                                                fwhm,...
                                                Resadd,...
                                                methods,...
                                                mask,...
                                                mask_lat,...
                                                theory_res );

save( strcat( path_wd, outname, '_D', num2str(D), case_name, '_fixedFWHM.mat' ),...
                  'D', 'fwhm', 'methods', 'Nsubj', 'fwhm', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );     
clear fwhm results theoryL sim_time

%%%%%% Dependence on FWHM
nsubj = Nsubj(2);
[ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                nsubj,...
                                                FWHM,...
                                                Resadd,...
                                                methods,...
                                                mask,...
                                                mask_lat,...
                                                theory_res );

save( strcat( path_wd, outname, '_D', num2str(D), case_name, '_fixednsubj.mat' ),...
                  'D', 'nsubj', 'methods', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );
clear nsuj results theoryL sim_time mask mask_lat


%--------------------------------------------------------------------------
%% Simulations Stationary Random Field on Sphere
%--------------------------------------------------------------------------
% Field does not get masked before application of convolutions to prevent
% non-stationary effects caused by the boundary.
mask_lat = false;

% Get the mask
mask = mask_sphere;

% Name of scenario
case_name = "_stationary_sphere";

%%%%%% Dependence on sample size
fwhm = FWHM(4);
[ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                Nsubj,...
                                                fwhm,...
                                                Resadd,...
                                                methods,...
                                                mask,...
                                                mask_lat,...
                                                theory_res );

save( strcat( path_wd, outname, '_D', num2str(D), case_name, '_fixedFWHM.mat' ),...
                  'D', 'fwhm', 'methods', 'Nsubj', 'fwhm', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );
clear fwhm results theoryL sim_time
              
%%%%%% Dependence on FWHM
nsubj = Nsubj(2); 
[ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                nsubj,...
                                                FWHM,...
                                                Resadd,...
                                                methods,...
                                                mask,...
                                                mask_lat,...
                                                theory_res );

save( strcat( path_wd, outname, '_D', num2str(D), case_name, '_fixednsubj.mat' ),...
                  'D', 'methods', 'nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );
clear nsuj results theoryL sim_time mask mask_lat


%--------------------------------------------------------------------------
%% Simulations Non-Stationary Random Field on Sphere
%--------------------------------------------------------------------------
% Field does not get masked before application of convolutions to prevent
% non-stationary effects caused by the boundary.
mask_lat = true;

% Get the mask
mask = mask_sphere;

% Name of scenario
case_name = "_nonstationary_sphere";

%%%%%% Dependence on sample size
fwhm = FWHM(4);
[ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                Nsubj,...
                                                fwhm,...
                                                Resadd,...
                                                methods,...
                                                mask,...
                                                mask_lat,...
                                                theory_res );

save( strcat( path_wd, outname, '_D', num2str(D), case_name, '_fixedFWHM.mat' ),...
                  'D', 'methods', 'Nsubj', 'fwhm', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );     
clear fwhm results theoryL sim_time

%%%%%% Dependence on FWHM
nsubj = Nsubj(2);
[ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                nsubj,...
                                                FWHM,...
                                                Resadd,...
                                                methods,...
                                                mask,...
                                                mask_lat,...
                                                theory_res );

save( strcat( path_wd, outname, '_D', num2str(D), case_name, '_fixednsubj.mat' ),...
                  'D', 'methods', 'nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'sim_time' );
clear nsuj results theoryL sim_time mask mask_lat