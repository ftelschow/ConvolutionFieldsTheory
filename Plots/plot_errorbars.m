function h = plot_errorbars( results, horzlines, xlab_name, xlims, ylab_name,...
                             ylims, legendplace, logplot, methods, scale, sfont, addf, ColScheme)
% wnfield( masksize, fibersize, mask ) plots results of different data as
% errorbars, put next to each other.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  varmask     Possible values are
%              - a 1 x D vector containing the size of the mask. The field
%                'mask' is then set to true( varmask ). 
%              - a T_1 x ... x T_D logical array containing the mask.
%  FWHMcor     a 1 x D vector containing the FWHM applied to correlate the
%              white noise
%  voxmap      a size varmask array representing a bijection of the domain
%
% Optional
%  FWHM        a 1 x D vector containing the FWHM applied after applying
%              the voxelmap
%  fibersize   a vector containing the size of the fiber. Default is 0,
%              i.e. the field is scalar.
%  xvals       a 1 x D cell array containing the xvals.
%              Default { 1:masksize(1), ..., 1:masksize(D) }.
%
%--------------------------------------------------------------------------
% OUTPUT
% obj  an object of class Fields representing white noise, which is not
%      masked. 
%
%--------------------------------------------------------------------------
% EXAMPLES
%--------------------------------------------------------------------------
% Author: Fabian Telschow
%--------------------------------------------------------------------------

if ~exist( 'legendplace', 'var' )
    legendplace = 1;
end


if ~exist( 'scale', 'var' )
    scale = 1;
end

if ~exist( 'sfont', 'var' )
    sfont = 22;
end

if ~exist( 'addf', 'var' )
    addf = 5;
end

if ~exist( 'horzlines', 'var' )
    horzlines = [];
elseif isnan( horzlines )
    horzlines = [];
end

if ~exist( 'ColScheme', 'Var' )
    % standard color schemes 'https://personal.sron.nl/~pault/'
    ColScheme  = [[68 119 170];...    % blue
                  [102 204 238];...   % cyan
                  [34 136 51];...     % green
                  [204 187 68];...    % yellow
                  [238 102 119];...   % red
                  [170 51 119]]/255;  % purple
elseif  isnan( ColScheme )
    % standard color schemes 'https://personal.sron.nl/~pault/'
    ColScheme  = [[68 119 170];...    % blue
                  [102 204 238];...   % cyan
                  [34 136 51];...     % green
                  [204 187 68];...    % yellow
                  [238 102 119];...   % red
                  [170 51 119]]/255;  % purple
end

%% Plot the errorbars
% number of x-axis values
N = length( results );

%%% Get the x-axis structures
% Names of the fields of the results structure
names = string(fieldnames( results{1} ));
L = length(names) - 2;

if ~exist( 'methods', 'var' )
    methods = 1:L;
else
    L = length( methods );
end

dd = 15;
N = length(xlims);
xvec  = (1:N) * dd; %nvec;
dL    = linspace(-1, 1, length(methods) );
names = names( 3:end );
names = names( methods );

%%% Cut colorscheme down to a reasonable size
ColScheme = ColScheme( round(linspace(1, size( ColScheme, 1 ),L)), : );

%%% Output size
WidthFig   = 1000;
HeightFig  = WidthFig * scale;

%%% Set everything into latex font
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

h = figure, clf, hold on;
    % Define size and location of the figure [xPos yPos WidthFig HeightFig]
    set(gcf, 'Position', [ 300 300 WidthFig HeightFig]);
    set(gcf,'PaperPosition', [ 300 300 WidthFig HeightFig])
    
    for n = 1:N
        xxvec = xvec(n) + dL;
        for l = 1:L
           if logplot
                ErrorBar = errorbar( xxvec(l), log10(mean(results{n}.(names(l) ))),...
                                     1.96 * log10(std(results{n}.(names(l) ))) / ...
                                     sqrt(length( results{n}.(names(l) ))), 'o' ); hold on;
           else
                ErrorBar = errorbar( xxvec(l), mean(results{n}.(names(l) )),...
                                     1.96 * std(results{n}.(names(l) )) / ...
                                     sqrt(length( results{n}.(names(l) ))), 'o' ); hold on;
           end
            set( ErrorBar,'Color', ColScheme(l,:), 'LineWidth', 2 ) 

        end
    end

    % Plot the theory values
    if length( horzlines ) == 1
        if logplot
            plot( [ xvec(1)-10 xvec(end)+10 ],[ log10(horzlines) log10(horzlines) ],...
                  'Color', [185 185 185]/255, 'LineWidth', 2 ), hold on
        else
            plot( [ xvec(1)-10 xvec(end)+10 ],[ horzlines horzlines ],...
                    'Color', [185 185 185]/255, 'LineWidth', 2 ), hold on
        end
    else
        xvec2  = (xvec(1) - dd/2):dd:(xvec(end) + dd/2);
        for k = 1:length(horzlines)
            xx = [ xvec2(k), xvec2(k+1) ];
            plot( xx, [ horzlines(k), horzlines(k)],...
                  'Color', [185 185 185] / 255,...
                  'LineWidth', 2 )
            hold on
        end
    end
    
    % Modify gloabal font size for this plot
    set(gca,'FontSize', sfont)

    % Change x-axis style
    xlim( [ xvec(1)-10 xvec(end)+10 ] )
    xticks( xvec )
    xticklabels( num2cell(string(xlims)) )
    h = xlabel( xlab_name, 'fontsize', sfont + addf );
    set( h, 'Interpreter', 'latex' );
    
    % Change y-axis style
    ylim( [ylims(1) ylims(end)] );
    
    % Change the y-coordinate ticks
    if length( ylims ) > 2
        yticks(ylims);
        yticklabels( num2cell(string(ylims)) );
    end
    
    h = ylabel( ylab_name, 'fontsize', sfont + addf );
    set(h, 'Interpreter', 'latex');

    % Add legend
    if isstring( legendplace ) || ischar( legendplace )
       names2 = fieldnames(results{1});
       names2 = names2(methods+2);
       legend( names2{:},...
                    'Location', legendplace );
        set(legend, 'fontsize', sfont);
        legend boxoff
    end
        
end
