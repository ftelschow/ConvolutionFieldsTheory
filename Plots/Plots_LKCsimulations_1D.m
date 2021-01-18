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
addpath("/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/Plots")

%%% Add path for results
path_wd      = "/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/";
path_pics    = strcat( path_wd, "Pics/" );
path_results = strcat( path_wd, "Results/" );

%%% General parameters
ylab_name = '$\mathcal{L}_1$';
scale = 0.85;
logplot = 0;
sfont = 30;

%% ------------------------------------------------------------------------
% Fixed FWHM
%%% Cube example
sim_name = "Sim_LKCestims_D1_stationary_fixedFWHM";
load( strcat( path_results, sim_name ) )

xlab_name = 'Sample Size [{\it N}]';

ylims     = round(theoryL-10):2:round(theoryL+10);
xlims     = Nsubj;

for r = Resadd
    i = find(Resadd==r);
    h = plot_errorbars( results(:,i), theoryL, ...
                        xlab_name, xlims, ylab_name, ...
                        ylims, "northeast", ...
                        logplot, [1 3 4 5 6], scale, sfont );
    l = title( strcat( "1D Stationary: FWHM = ", num2str(f),...
                       " Resadd = ", num2str(r) ));
    set( l, 'Interpreter', 'latex' );
    
    set( gcf, 'papersize', [4 4*scale] )
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
    print( strcat( "Pics/", sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end

%%% Sphere example
sim_name = "Sim_LKCestims_D1_nonstationary_fixedFWHM_sphere";
load( strcat( path_results, sim_name ) )
ylims     = 3.2:0.1:3.8;

for r = Resadd
    i = find(Resadd==r);
    h = plot_errorbars( results(:,i), theoryL, ...
                        xlab_name, xlims, ylab_name, ...
                        ylims, "northeast", ...
                        logplot, [1 3 4 5 6], scale, sfont );
    l = title( strcat( "1D non-Stationary: FWHM = ", num2str(f),...
                       " Resadd = ", num2str(r) ));
    set( l, 'Interpreter', 'latex' );
    
    set( gcf, 'papersize', [4 4*scale] )
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
    print( strcat( "Pics/", sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end

%% ------------------------------------------------------------------------
% Fixed nsubj
%%% Cube example
sim_name = "Sim_LKCestims_D1_stationary_fixednsubj";
load( strcat( path_results, sim_name ) )
xlab_name = 'FWHM';
xlims = FWHM;
logplot = 1;

ylims = log10([ min(theoryL)-5 max(theoryL)+5 ]);

for r = Resadd
    i = find(Resadd==r);
    h = plot_errorbars( results(:,i), log10(theoryL), xlab_name, xlims,...
                        ylab_name, ylims, "northeast", logplot,...
                        [1 3 4 5 6], scale, sfont );
    l = title( strcat( "1D Stationary: nsubj = ", num2str(nsubj),...
                       " resadd = ", num2str(r) ));
    set( l, 'Interpreter', 'latex' );
    
    set( gcf, 'papersize', [4 4*scale] )
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
    print( strcat( "Pics/", sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end

%%% Sphere example
sim_name = "Sim_LKCestims_D1_nonstationary_fixednsubj_sphere";
load( strcat( path_results, sim_name ) )

xlab_name = 'FWHM';
ylab_name = '$\mathcal{L}_1$';
xlims = FWHM;
ylims     = log10([ min(theoryL)-3 max(theoryL)+5 ]);
logplot = 1;

for r = Resadd
    i = find(Resadd==r);
    h = plot_errorbars( results(:,i), log10(theoryL), xlab_name, xlims,...
                        ylab_name, ylims, "northeast", logplot,...
                        [1 3 4 5 6], scale, sfont );
    l = title( strcat( "1D non-Stationary: nsubj = ", num2str(nsubj),...
                       " resadd = ", num2str(r) ));
    set( l, 'Interpreter', 'latex' );
    
    set( gcf, 'papersize', [4 4*scale] )
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
    print( strcat( "Pics/", sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end
close all