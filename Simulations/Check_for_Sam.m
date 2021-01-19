%% Short check of parallelization for Sam
% If this runs through smoothly, I hope it will too on the server
%--------------------------------------------------------------------------
% BEGIN insert your local folder
path = "/home/drtea/matlabToolboxes/ConvolutionFieldsTheory/";
% END
addpath( strcat( path, 'Simulations' ) )

% Choose dimension of the domain
D = 1; % 2; %

% Number of runs by dimension
Drun = [ 4, 6 ];

% Loop over runs which will be parallel on the server
tic
for run = 1:Drun(D)
    switch D
        case 1
            % Setting for the different runs
            if run == 1
                fwhm_switch = 0;
                field_name  = "stationary";
                mask_name   = "box";
            elseif run == 2
                fwhm_switch = 1;
                field_name  = "stationary";
                mask_name   = "box";
            elseif run == 3
                fwhm_switch = 0;
                field_name  = "nonstationary";
                mask_name   = "sphere";
            elseif run == 4
                fwhm_switch = 1;
                field_name  = "nonstationary";
                mask_name   = "sphere";
            end
        case 2
            if run == 1
                fwhm_switch = 0;
                field_name  = "stationary";
                mask_name   = "box";
            elseif run == 2
                fwhm_switch = 1;
                field_name  = "stationary";
                mask_name   = "box";
            elseif run == 3
                fwhm_switch = 0;
                field_name  = "stationary";
                mask_name   = "sphere";
            elseif run == 4
                fwhm_switch = 1;
                field_name  = "stationary";
                mask_name   = "sphere";
            elseif run == 5
                fwhm_switch = 0;
                field_name  = "nonstationary";
                mask_name   = "sphere";
            elseif run == 6
                fwhm_switch = 1;
                field_name  = "nonstationary";
                mask_name   = "sphere";
            end
    end

    % call the function simulating the LKCs
    LKCsim_Article( fwhm_switch, field_name, mask_name, D, 2, "", path )
end
toc