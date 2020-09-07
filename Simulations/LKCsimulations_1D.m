%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%    Theory of Convolution Fields: LKC estimation 1D simulations
%%%%
%%%%    DESCRIPTION:
%%%%    This script simulates LKC estimates of convolution fields in 1D to
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

%%% prepare workspace
clear all
close all

%%% Add the RFTtoolbox to working path
addpath(genpath("/home/drtea/matlabToolboxes/RFTtoolbox/"))

%%% Add path for results
path_wd = "/home/drtea/matlabToolboxes/TheoryConvFields/SimulationResults/";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %% Parameters for the simulation 
%--------------------------------------------------------------------------
% Dimension of Domain
D = 1;

% Amount of Monte Carlo simulations
Msim = 1e3;

% Length of the domain
T = 100;

% Dimension of domain
dim   = [ T 1 ];

% Amount of bootstrap replicates for bHPE
Mboot = 1e3;

% Vector for FWHM dependence
FWHM = [ 1 1.5 2 3 4 5 6 ];

% Vector for sample size dependence
Nsubj = [ 20 50 100 150 ];

% Vector for resadd dependence
Resadd = [ 1 3 5 ];

% Methods compared in this simulation 
methods = struct( 'convE', true, 'stationaryE', true, ...
                  'HPE', true, 'bHPE', [ Mboot, 1 ] );

% String for output
outname = "Sim_LKCestims_";


%% %% Stationary case 
%--------------------------------------------------------------------------
%% Dependence on sample size
% FWHM used in this simulation
f = FWHM(4);

% Get the mask
pad  = ceil( 4 * FWHM2sigma(f) );
mask = true( dim );
mask = logical( pad_vals( mask, pad) );

% Get the theoretical value of the LKC
theoryL = LKC_isogauss_theory( f, dim );

% Get cell for output results
results = cell( [ length( Nsubj ) length( Resadd ) ] );

tic
for n = 1:length( Nsubj )
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( f, Resadd(r),...
                                  ceil( Resadd(r) / 2 ), false );
        % Get the simulation results 
        results{n,r} = simulate_LKCests( Msim, Nsubj(n), methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_stationary_fixedFWHM.mat' ),...
                  'D', 'f', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results', 'simulation_time' );
%clear simulation_time pad f mask params r n results theoryL
              
%% Dependence on FWHM
% Sample size used in this simulation
nsubj = Nsubj(2);

% Get cell for output results
results = cell( [ length( FWHM ) length( Resadd ) ] );

% Initialize theoretical value
theoryL = zeros( [ length( FWHM ) 1 ] );

tic
for f = 1:length( FWHM )
    % Get the mask
    pad  = ceil( 4 * FWHM2sigma(f) );
    mask = true( dim );
    mask = logical( pad_vals( mask, pad ) );

    % Get the theoretical value of the LKC
    theoryL(f) = LKC_isogauss_theory( f, dim );
    
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( f, Resadd(r),...
                                  ceil( Resadd(r) / 2 ), false );
        % Get the simulation results 
        results{f,r} = simulate_LKCests( Msim, nsubj, methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_stationary_fixednsubj.mat' ),...
                  'D', 'nsubj', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results' );


%% %% Stationary case Sphere domain
%--------------------------------------------------------------------------
%% Dependence on sample size
% FWHM used in this simulation
f = FWHM(4);

% Get the mask
pad         = ceil( 4 * FWHM2sigma(f) );
mask        = true( dim );
mask(20:80) = false;
mask        = logical( pad_vals( mask, pad) );

% Get the theoretical value of the LKC
params  = ConvFieldParams( f, 7, ceil( 7 / 2 ), false );
theoryL = LKC_wncfield_theory( mask, params );

% Get cell for output results
results = cell( [ length( Nsubj ) length( Resadd ) ] );

tic
for n = 1:length( Nsubj )
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( f, Resadd(r),...
                                  ceil( Resadd(r) / 2 ), false );
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
              

%% Dependence on FWHM
% Sample size used in this simulation
nsubj = Nsubj(2);

% Get cell for output results
results = cell( [ length( FWHM ) length( Resadd ) ] );

% Initialize theoretical value
theoryL = zeros( [ length( FWHM ) 1 ] );

tic
for f = 1:length( FWHM )
    % Get the mask
    pad  = ceil( 4 * FWHM2sigma(f) );
    mask = true( dim );
    mask(20:80) = false;
    mask = logical( pad_vals( mask, pad ) );

    % Get the theoretical value of the LKC
    params = ConvFieldParams( FWHM(f), 7,...
                                  ceil( 7 / 2 ), false );
    theoryL(f) = LKC_wncfield_theory( mask, params );
    
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( f, Resadd(r),...
                                  ceil( Resadd(r) / 2 ), false );
        % Get the simulation results 
        results{f,r} = simulate_LKCests( Msim, nsubj, methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, '_D', num2str(D), '_stationary_fixednsubj_sphere.mat' ),...
                  'D', 'nsubj', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results' );