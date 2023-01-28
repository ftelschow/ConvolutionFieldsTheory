function [ results, theoryL, sim_time ] = LKCsimulation_Timing( Msim,...
                                                         Nsubj,...
                                                         FWHM,...
                                                         Resadd,...
                                                         mask,...
                                                         theory_res,...
                                                         Mboot)
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


% Methods compared in this simulation
if D == 3
    methods = struct('convE', logical( [ 1 1 0 ] ),...
                     'bHPE', [ Mboot, 1 ], ...
                     'kiebelE', 1 );
else
    methods = struct('convE', true,...
                     'bHPE', [ Mboot, 1 ], ...
                     'kiebelE', 1);
end

Nmethods = length(fieldnames(methods));

% Get output vector for simulation time
sim_time = NaN*ones([Nmethods, length(Resadd)]);
              


%% Dependence on sample size for fixed FWHM
%--------------------------------------------------------------------------
    % Get cell for output results
    results = cell( [ Nmethods length( Resadd ) ] );
    
    % FWHM used in this simulation
    fvec = repmat( FWHM, [ 1, D ] );
    
    % Pad zeros to the mask if you do not want to have bdry effects
    pad  = ceil( 4 * FWHM2sigma( FWHM ) );
    mask = logical( pad_vals( mask, pad ) );

    % Get the theoretical value of the LKC
    params = ConvFieldParams( fvec,...
                              theory_res,...
                              ceil( theory_res / 2 ),...
                              true );
    theoryL = LKC_wncfield_theory( mask, params );

    for r = 1:length( Resadd )
        % Get the simulation results
        for i = 1:Nmethods
            if i == 1
                names_rm = ["bHPE", "kiebelE"];
            elseif i == 2
                names_rm = ["convE", "kiebelE"];
            else
                names_rm = ["convE", "bHPE"];
            end
            
        % Get parameters for the convolution fields
        if ~(i == 2 && D == 3)
            params = ConvFieldParams( fvec,...
                                      Resadd( r ),...
                                      ceil( Resadd( r ) / 2 ),...
                                      true );
        else
            params = ConvFieldParams( fvec,...
                                      Resadd( 1 ),...
                                      ceil( Resadd( 1 ) / 2 ),...
                                      true );
        end
            
            methods_i = rmfield(methods, names_rm(1));
            methods_i = rmfield(methods_i, names_rm(2));
            
            results = simulate_LKCests( Msim,...
                                        Nsubj,...
                                        methods_i,...
                                        params,...
                                        mask );
            sim_time(i,r) = results.simtime;
        end
    end
end