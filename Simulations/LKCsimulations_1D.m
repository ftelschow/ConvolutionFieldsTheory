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
path_wd = "/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/Results/";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %% Parameters for the simulation 
%--------------------------------------------------------------------------
% Dimension of Domain
D = 1;

% Amount of Monte Carlo simulations
Msim = 150%1e3;

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
Resadd = [ 0 1 2 3 ];

% Indicate whether the data should be masked before applying the smoothing
mask_lat = false;

% Resolution increase used for theoretical estimator
res_theory = 51;

% Enlarge the domain or not?
enlarge_switch = false;
if enlarge_switch
    enlarge_theory = ceil(res_theory/2);
else
    enlarge_theory = 0;
end


% Methods compared in this simulation 
methods = struct( 'convE', true, 'bHPE', [ Mboot, 1 ], ...
                  'kiebelE', 1, 'formanE', 1 );

% String for output
outname = "Sim_LKCestims_";


%% %% Stationary case 
%--------------------------------------------------------------------------
%% Dependence on sample size
% FWHM used in this simulation
f = FWHM(3);

% Enlarge indicator
if enlarge_theory == 0
    enlarge = zeros( [ 1 length(Resadd) ] );
else
    enlarge = ceil( Resadd / 2);
end

% Get the mask
pad  = ceil( 4 * FWHM2sigma(f) );
mask = true( dim );
mask = logical( pad_vals( mask, pad) );

% Get the theoretical value of the LKC
theoryL_cont = LKC_isogauss_theory( f, dim );
params   = ConvFieldParams( f, res_theory, enlarge_theory, mask_lat );
theoryL  = LKC_wncfield_theory( mask, params );

% Get cell for output results
results = cell( [ length( Nsubj ) length( Resadd ) ] );

tic
for n = 1:length( Nsubj )
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( f, Resadd(r),...
                                  enlarge(r), mask_lat );
        % Get the simulation results 
        results{n,r} = simulate_LKCests( Msim, Nsubj(n), methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, 'D', num2str(D), '_stationary_fixedFWHM.mat' ),...
                  'D', 'f', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL', 'theoryL_cont',...
                  'results', 'simulation_time' );
clear simulation_time pad f mask params r n results theoryL theoryL_cont
              
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
    theoryL_cont(f) = LKC_isogauss_theory( f, dim );
    params     = ConvFieldParams( FWHM(f), res_theory, enlarge_theory, mask_lat );
    theoryL(f) = LKC_wncfield_theory( mask, params );
    
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( FWHM(f), Resadd(r),...
                                  enlarge(r), mask_lat );
        % Get the simulation results 
        results{f,r} = simulate_LKCests( Msim, nsubj, methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, 'D', num2str(D), '_stationary_fixednsubj.mat' ),...
                  'D', 'nsubj', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL', 'theoryL_cont',...
                  'results' );

clear simulation_time pad f mask params r results theoryL theoryL_cont


%% %% Non-Stationary case Sphere domain
%--------------------------------------------------------------------------
mask_lat = true;
%% Dependence on sample size
% FWHM used in this simulation
f = FWHM(4);

% Get the mask
pad         = ceil( 4 * FWHM2sigma(f) );
mask        = true( dim );
mask(5:95) = false;
mask        = logical( pad_vals( mask, pad) );

% Get the theoretical value of the LKC
params  = ConvFieldParams( f, res_theory, enlarge_theory, mask_lat );
theoryL = LKC_wncfield_theory( mask, params );

% Get cell for output results
results = cell( [ length( Nsubj ) length( Resadd ) ] );

tic
for n = 1:length( Nsubj )
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( f, Resadd(r),...
                                  enlarge(r), mask_lat );
        % Get the simulation results 
        results{n,r} = simulate_LKCests( Msim, Nsubj(n), methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, 'D', num2str(D), '_nonstationary_fixedFWHM_sphere.mat' ),...
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
    params = ConvFieldParams( FWHM(f), res_theory,...
                              enlarge_theory, mask_lat );
    theoryL(f) = LKC_wncfield_theory( mask, params );
    
    for r = 1:length( Resadd )
        % Get parameters for the convolution fields
        params = ConvFieldParams( FWHM(f), Resadd(r),...
                                  enlarge(r), mask_lat );
        % Get the simulation results 
        results{f,r} = simulate_LKCests( Msim, nsubj, methods,...
                                                  params, mask );
    end
end
simulation_time = toc

save( strcat( path_wd, outname, 'D', num2str(D), '_nonstationary_fixednsubj_sphere.mat' ),...
                  'D', 'nsubj', 'methods', 'Nsubj', 'FWHM', 'Resadd',...
                  'dim', 'Mboot', 'Msim', 'theoryL',...
                  'results' );