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

% Set on which machine the code runs.
% CAUTION: this needs to ne adapted for reproducing the results from the
% article!
server = true;

if server
    % Add the RFTtoolbox to working path
    addpath( genpath("~/projects/RFTtoolbox/") )

    % Add path for results
    path_wd = "~/projects/ConvolutionFieldsTheory/Results/";
else
    % Add the RFTtoolbox to working path
    addpath( genpath("/home/drtea/matlabToolboxes/RFTtoolbox/") )

    % Add path for results
    path_wd = "/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/Results/";
end


%--------------------------------------------------------------------------
%% Parameters for the Simulations 
%--------------------------------------------------------------------------
% Dimension of Domain
D = 2;

% Amount of Monte Carlo simulations
Msim = 3;

% Length of the domain
T = 30;

% Dimension of domain
dim   = [ T T ];

% Amount of bootstrap replicates for bHPE
Mboot = 1e3;

% Vector for FWHM dependence
FWHM = [ 1 1.5 2 3 4 5 6 ];

% Vector for sample size dependence
Nsubj = [ 20 50 100 150 ];

% Vector for resadd dependence
Resadd = [ 0 1 2 3 ];

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

%%%%%% Dependence on sample size
% FWHM used in this simulation
f = FWHM(4);

% Get the mask
pad  = ceil( 4 * FWHM2sigma(f) );
mask = true( dim );
mask = logical( pad_vals( mask, pad) );

% Get the theoretical value of the LKC
params = ConvFieldParams( [ f, f ], 7,...
                                  ceil( 7 / 2 ), mask_lat );
theoryL = LKC_wncfield_theory( mask, params );

% Get cell for output results
results = cell( [ length( Nsubj ) length( Resadd ) ] );

tic
for n = 1:length( Nsubj )
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( [ f, f ], Resadd(r),...
                                  ceil( Resadd(r) / 2 ), mask_lat );
        % Get the simulation results 
        results{n,r} = simulate_LKCests( Msim, Nsubj(n), methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_stationary_box_fixedFWHM.mat' ),...
                  'D', 'f', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'simulation_time' );
clear simulation_time pad f mask params r n results theoryL
      

%%%%%% Dependence on FWHM
% Sample size used in this simulation
nsubj = Nsubj(2);

% Get cell for output results
results = cell( [ length( FWHM ) length( Resadd ) ] );

% Initialize theoretical value
theoryL = zeros( [ length( FWHM ) D ] );

tic
for f = 1:length( FWHM )
    % Get the mask
    pad  = ceil( 4 * FWHM2sigma(f) );
    mask = true( dim );
    mask = logical( pad_vals( mask, pad ) );

    % Get the theoretical value of the LKC
    params = ConvFieldParams( [ FWHM(f), FWHM(f) ], 7,...
                                  ceil( 7 / 2 ), mask_lat );
    theoryL(f,:) = LKC_wncfield_theory( mask, params );
    
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( [ FWHM(f), FWHM(f) ], Resadd(r),...
                                    ceil( Resadd(r) / 2 ), mask_lat );
        % Get the simulation results 
        results{f,r} = simulate_LKCests( Msim, nsubj, methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_stationary_box_fixednsubj.mat' ),...
                  'D', 'nsubj', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'simulation_time' );

              
%--------------------------------------------------------------------------
%% Simulations Stationary Random Field on Sphere
%--------------------------------------------------------------------------
% Field does not get masked before application of convolutions to prevent
% non-stationary effects caused by the boundary.
mask_lat = false;

%%%%%% Dependence on sample size
% FWHM used in this simulation
f = FWHM(4);

% Get the mask
pad  = ceil( 4 * FWHM2sigma(f) );
mask = true( dim );
mask = bndry_voxels( logical( pad_vals( mask, pad) ), 'full' );

% Get the theoretical value of the LKC
params = ConvFieldParams( [ f, f ], 7,...
                              ceil( 7 / 2 ), mask_lat );
theoryL = LKC_wncfield_theory( mask, params );

% Get cell for output results
results = cell( [ length( Nsubj ) length( Resadd ) ] );

tic
for n = 1:length( Nsubj )
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( [ f, f ], Resadd(r),...
                                  ceil( Resadd(r) / 2 ), mask_lat );
        % Get the simulation results 
        results{n,r} = simulate_LKCests( Msim, Nsubj(n), methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_stationary_fixedFWHM_sphere.mat' ),...
                  'D', 'f', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'simulation_time' );
clear simulation_time pad f mask params r n results theoryL
              
%%%%%% Dependence on FWHM
% Sample size used in this simulation
nsubj = Nsubj(2);

% Get cell for output results
results = cell( [ length( FWHM ) length( Resadd ) ] );

% Initialize theoretical value
theoryL = zeros( [ length( FWHM ) D ] );

tic
for f = 1:length( FWHM )
    % Get the mask
    pad  = ceil( 4 * FWHM2sigma(f) );
    mask = true( dim );
    mask = bndry_voxels( logical( pad_vals( mask, pad) ), 'full' );
    
    % Get the theoretical value of the LKC
    params = ConvFieldParams( [ FWHM(f), FWHM(f) ], 7,...
                                ceil( 7 / 2 ), mask_lat );
    theoryL(f,:) = LKC_wncfield_theory( mask, params );

    
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( [ FWHM(f) FWHM(f) ], Resadd(r),...
                                  ceil( Resadd(r) / 2 ), mask_lat );
        % Get the simulation results 
        results{f,r} = simulate_LKCests( Msim, nsubj, methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_stationary_fixednsubj_sphere.mat' ),...
                  'D', 'nsubj', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'simulation_time' );
           
              
%--------------------------------------------------------------------------
%% Simulations Stationary Random Field on Sphere
%--------------------------------------------------------------------------
% Field does not get masked before application of convolutions to prevent
% non-stationary effects caused by the boundary.
mask_lat = true;

%%%%%% Dependence on sample size
% FWHM used in this simulation
f = FWHM(4);

% Get the mask
pad  = ceil( 4 * FWHM2sigma(f) );
mask = true( dim );
mask = bndry_voxels( logical( pad_vals( mask, pad) ), 'full' );

% Get the theoretical value of the LKC
params = ConvFieldParams( [ f, f ], 7,...
                              ceil( 7 / 2 ), mask_lat );
theoryL = LKC_wncfield_theory( mask, params );

% Get cell for output results
results = cell( [ length( Nsubj ) length( Resadd ) ] );

tic
for n = 1:length( Nsubj )
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( [ f, f ], Resadd(r),...
                                  ceil( Resadd(r) / 2 ), mask_lat );
        % Get the simulation results 
        results{n,r} = simulate_LKCests( Msim, Nsubj(n), methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_nonstationary_sphere_fixedFWHM.mat' ),...
                  'D', 'f', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'simulation_time' );
clear simulation_time pad f mask params r n results theoryL
              
%%%%%% Dependence on FWHM
% Sample size used in this simulation
nsubj = Nsubj(2);

% Get cell for output results
results = cell( [ length( FWHM ) length( Resadd ) ] );

% Initialize theoretical value
theoryL = zeros( [ length( FWHM ) D ] );

tic
for f = 1:length( FWHM )
    % Get the mask
    pad  = ceil( 4 * FWHM2sigma(f) );
    mask = true( dim );
    mask = bndry_voxels( logical( pad_vals( mask, pad) ), 'full' );
    
    % Get the theoretical value of the LKC
    params = ConvFieldParams( [ FWHM(f), FWHM(f) ], 7,...
                              ceil( 7 / 2 ), mask_lat );
    theoryL(f,:) = LKC_wncfield_theory( mask, params );

    
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( [ FWHM(f) FWHM(f) ], Resadd(r),...
                                  ceil( Resadd(r) / 2 ), mask_lat );
        % Get the simulation results 
        results{f,r} = simulate_LKCests( Msim, nsubj, methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_nonstationary_sphere_fixednsubj.mat' ),...
                  'D', 'nsubj', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'simulation_time' );