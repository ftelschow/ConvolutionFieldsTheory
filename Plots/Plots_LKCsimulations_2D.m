%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%    Theory of Convolution Fields: Plots of the article D = 2
%%%%
%%%%    DESCRIPTION:
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
addpath(genpath("~/Seafile/Code/matlabToolboxes/RFTtoolbox/"))
addpath("~/Seafile/Code/matlabToolboxes/ConvolutionFieldsTheory/Plots")

%%% Add path for results
path_wd      = "~/Seafile/Code/matlabToolboxes/ConvolutionFieldsTheory/";
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
sim_name = "Sim_LKCestims_D2_stationary_box_fixedFWHM";

I = 5;

for i = 1:I
    % Load the results
    load(strcat(path_results, sim_name, num2str(i), ".mat"))
    if i == 1
        results_tot = results;
    else
        for l = 1:numel(results)
            names = string(fieldnames(results{l}));
            names = names(3:end);
            for k = 1:length(names)
                results_tot{l}.(names(k)) = [ results_tot{l}.(names(k)); results{l}.(names(k)) ];
            end
        end
    end
end

xlab_name = 'Sample Size [{\it N}]';

ylims = cell([1 2]);
ylims{1} = round(theoryL(1)-10):2:round(theoryL(1)+10);
ylims{2} = round(theoryL(2)-20):5:round(theoryL(2)+60);
xlims     = Nsubj;

for LKCnum = 1:2
for r = Resadd
    i = find(Resadd==r);
    h = plot_errorbars( results(:,i), theoryL(LKCnum), ...
                        xlab_name, xlims, ylab_name, ...
                        ylims{LKCnum}, LKCnum, "northeast", ...
                        logplot, [1 3 4 5 6], scale, sfont );
    l = title( strcat( num2str(D), "D Stationary: FWHM = ", num2str(fwhm),...
                       " Resadd = ", num2str(r), " LKC", num2str(LKCnum) ));
    set( l, 'Interpreter', 'latex' );
    
    set( gcf, 'papersize', [4 4*scale] )
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
    print( strcat( path_pics, sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end
end


%% ------------------------------------------------------------------------

for r = Resadd
    i = find(Resadd==r);
    h = plot_errorbars( results(:,i), theoryL, ...
                        xlab_name, xlims, ylab_name, ...
                        ylims, "northeast", ...
                        logplot, [1 3 4 5 6], scale, sfont );
    l = title( strcat( "1D Stationary: FWHM = ", num2str(fwhm),...
                       " Resadd = ", num2str(r) ));
    set( l, 'Interpreter', 'latex' );
    
    set( gcf, 'papersize', [4 4*scale] )
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
    print( strcat( path_pics, sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end

%%% Sphere example
sim_name = "Sim_LKCestims_D1_nonstationary_sphere_fixedFWHM";
load( strcat( path_results, sim_name ) )

%
rangey = [2.8 3.6];
dy     = 0.2;
n      = diff( rangey ) / dy + 1;
ylims  = linspace( rangey(1), rangey(2), n );


for r = Resadd
    i = find(Resadd==r);
    h = plot_errorbars( results(:,i), theoryL, ...
                        xlab_name, xlims, ylab_name, ...
                        ylims, "northeast", ...
                        logplot, [1 3 4 5 6], scale, sfont );
    l = title( strcat( "1D non-Stationary: FWHM = ", num2str(fwhm),...
                       " Resadd = ", num2str(r) ));
    set( l, 'Interpreter', 'latex' );
    
    set( gcf, 'papersize', [4 4*scale] )
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [ fig_pos(3) fig_pos(4) ];
    print( strcat( path_pics, sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end

%% ------------------------------------------------------------------------
% Fixed nsubj
%%% Cube example
sim_name = "Sim_LKCestims_D1_stationary_box_fixednsubj";
load( strcat( path_results, sim_name ) )
xlab_name = 'FWHM';
xlims = FWHM;
logplot = 1;

ylims = log10([ min(theoryL)-4 max(theoryL)+ 30 ]);

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
    print( strcat( path_pics, sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end

%%% Sphere example
sim_name = "Sim_LKCestims_D1_nonstationary_sphere_fixednsubj";
load( strcat( path_results, sim_name ) )

xlab_name = 'FWHM';
ylab_name = '$\mathcal{L}_1$';
xlims = FWHM;
ylims     = log10([ min(theoryL)-0.2 max(theoryL)+5 ]);
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
    print( strcat( path_pics, sim_name, "_resadd", num2str(r) ), '-dpng' )
    hold off;
end
close all