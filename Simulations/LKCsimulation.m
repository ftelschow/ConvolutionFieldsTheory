function [ results, theoryL, sim_time ] = LKCsimulation( Msim,...
                                                         Nsubj,...
                                                         FWHM,...
                                                         Resadd,...
                                                         methods,...
                                                         mask,...
                                                         mask_lat,...
                                                         theory_res )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%
% Optional
%
%--------------------------------------------------------------------------
% OUTPUT
% obj  an object of class Fields representing white noise, which is not
%      masked. 
%
%--------------------------------------------------------------------------
%% Check input
%--------------------------------------------------------------------------
% Ensure that the simulation is stratified along FWHM or Nsubj
if length( FWHM ) ~= 1 && length( Nsubj ) ~= 1 
    error( "Either FWHM or Nsubj need to have length 1" )
end

% Get the dimension from the mask input
sM = size( mask );
if length( sM ) > 2
    D = length( sM );
else
    if sM( 2 ) == 1
        D = 1;
    else
        D = 2;
    end
end

%% Dependence on sample size for fixed FWHM
%--------------------------------------------------------------------------
tic
if( length( FWHM ) == 1 )
    % Get cell for output results
    results = cell( [ length( Nsubj ) length( Resadd ) ] );
    
    % FWHM used in this simulation
    fvec = repmat( FWHM, [ 1, D ] );
    
    % Pad zeros to the mask if you do not want to have bdry effects
    pad  = ceil( 4 * FWHM2sigma( FWHM ) );
    mask = logical( pad_vals( mask, pad ) );

    % Get the theoretical value of the LKC
    params = ConvFieldParams( fvec,...
                              theory_res,...
                              ceil( theory_res / 2 ),...
                              mask_lat );
    theoryL = LKC_wncfield_theory( mask, params );

    for n = 1:length( Nsubj )
        for r = 1:length( Resadd )
            % Get parameters for the convolution fields
            params = ConvFieldParams( fvec,...
                                      Resadd( r ),...
                                      ceil( Resadd( r ) / 2 ),...
                                      mask_lat );
            % Get the simulation results
            results{n,r} = simulate_LKCests( Msim,...
                                             Nsubj( n ),...
                                             methods,...
                                             params,...
                                             mask );
        end
    end
end
sim_time = toc;

%% Dependence on FWHM for fixed sample size
%--------------------------------------------------------------------------
if( length( Nsubj ) == 1 )
    % Get cell for output results
    results = cell( [ length( FWHM ) length( Resadd ) ] );

    % Initialize theoretical value
    theoryL = zeros( [ length( FWHM ) D ] );

    tic
    for f = 1:length( FWHM )
        % FWHM used in this simulation
        fvec = repmat( FWHM(f), [ 1, D ] );
        
        % Pad zeros to the mask if you do not want to have boundary effects
        pad   = ceil( 4 * FWHM2sigma( FWHM(f) ) );
        maskp = logical( pad_vals( mask, pad) );
        
        % Get the theoretical value of the LKC
        params = ConvFieldParams( fvec,...
                                  theory_res,...
                                  ceil( theory_res / 2 ),...
                                  mask_lat );
        theoryL(f,:) = LKC_wncfield_theory( mask, params );

        for r = 1:length( Resadd )
            % Get parameters for the convolution fields
            params = ConvFieldParams( fvec,...
                                      Resadd(r),...
                                      ceil( Resadd(r) / 2 ),...
                                      mask_lat );
                                  
            % Get the simulation results 
            results{f,r} = simulate_LKCests( Msim,...
                                             Nsubj,...
                                             methods,...
                                             params,...
                                             maskp );
        end
    end
    sim_time = toc

end