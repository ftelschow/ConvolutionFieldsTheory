%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%    Theory of Convolution Fields: Plots of the article
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
addpath("/home/drtea/matlabToolboxes/TheoryConvFields/Plots")

%%% Add path for results
path_wd      = "/home/drtea/matlabToolboxes/TheoryConvFields/";
path_pics    = strcat( path_wd, "Pics/" );
path_results = strcat( path_wd, "SimulationResults/" );

%% ------------------------------------------------------------------------
% 1D plots
%%% General parameters
xlab_name = 'Sample Size [{\it N}]';
ylab_name = '$\mathcal{L}_1$';
scale = 0.85;
logplot = 0;
sfont = 30;

%%% Cube example fixed FWHM
sim_name = "Sim_LKCestims__D1_stationary_fixedFWHM";
load( strcat( path_results, sim_name ) )
ylims     = [ 54 54.5 55 55.5 56 ];
xlims     = Nsubj;


h = plot_errorbars( results, theoryL, xlab_name, xlims, ylab_name,...
                             ylims, "southeast", logplot, [1 3 4 5], scale, sfont );

set( gcf, 'papersize', [4 4*scale] )
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
print( strcat( path_pics, sim_name ), '-dpng' )
hold off;

%%% Sphere example fixed FWHM
sim_name = "Sim_LKCestims__D1_stationary_fixedFWHM_sphere";
load( strcat( path_results, sim_name ) )
ylims     = [ 21 22.2 ];

h = plot_errorbars( results, theoryL, xlab_name, xlims, ylab_name,...
                             ylims, "southeast", logplot, [1 3 4 5], scale, sfont );

set( gcf, 'papersize', [4 4*scale] )
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
print( strcat( path_pics, sim_name ), '-dpng' )
hold off;

%%% Fixed nsubj
xlab_name = 'FWHM';
xlims = FWHM;
logplot = 1;
%%% Cube example
sim_name = "Sim_LKCestims__D1_stationary_fixednsubj";
load( strcat( path_results, sim_name ) )
ylims     = log10([ min(theoryL)-5 max(theoryL)+5 ]);

h = plot_errorbars( results, log10(theoryL), xlab_name, xlims, ylab_name,...
                             ylims, "northeast", logplot, [1 3 4 5], scale, sfont );

set( gcf, 'papersize', [4 4*scale] )
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
print( strcat( path_pics, sim_name ), '-dpng' )
hold off;

%%% Sphere example
sim_name = "Sim_LKCestims__D1_stationary_fixednsubj_sphere";
load( strcat( path_results, sim_name ) )
ylims     = log10([ min(theoryL)-20 max(theoryL)+5 ]);

h = plot_errorbars( results, log10(theoryL), xlab_name, xlims, ylab_name,...
                             ylims, "northeast", logplot, [1 3 4 5], scale, sfont );

set( gcf, 'papersize', [4 4*scale] )
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
print( strcat( path_pics, sim_name ), '-dpng' )
hold off;