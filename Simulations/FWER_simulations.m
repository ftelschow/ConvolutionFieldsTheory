function [ results, theoryL, sim_time ] = FWER_simulations( Msim,...
    nsubj_vec,...
    FWHM_vec,...
    resadd_vec,...
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
if length( FWHM_vec ) ~= 1 && length( nsubj_vec ) ~= 1
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
for I = 1:nsubj_vec
    nsubj = nsubj_vec(I);
    for J = 1:length(FWHM_vec)
        FWHM = FWHM_vec(J);
        for K = 1:length(resadd_vec)
            resadd = resadd_vec(K);
            
            % Get cell for output results
            results = cell( [ length( nsubj ) length( resadd ) ] );
            
            % FWHM used in this simulation
            fvec = repmat( FWHM, [ 1, D ] );
            
            % Pad zeros to the mask if you do not want to have bdry effects
            pad  = ceil( 4 * FWHM2sigma( FWHM ) );
            mask = logical( pad_vals( mask, pad ) );
            
            % Set the params for the simulation
            params = ConvFieldParams( fvec,...
                resadd,...
                ceil( resadd / 2 ),...
                mask_lat );
            
            spfn = @(nsubj) wfield( mask, nsubj );
            
            % Get the simulation results
            results{n,r} = simulate_LKCests( Msim,...
                nsubj_vec( n ),...
                methods,...
                params,...
                mask );
            
            FWHM = 3; sample_size = 20; nvox = 100; resadd = 3;
            spfn = @(nsubj) wfield( nvox, nsubj ); niters = 1000;
            params = ConvFieldParams( FWHM, resadd );
            record_coverage( spfn, sample_size, params, niters)
            
        end
    end
end

if( length( FWHM_vec ) == 1 )
    
end


end