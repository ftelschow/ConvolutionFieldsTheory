run = str2num( getenv( 'SGE_TASK_ID' ) );
% Need total runs: 6
% Runs LKC estimation in 1D on the Oxford server

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

% dimension of the domain in this simulation
D = 2;

% call the function simulating the LKCs
LKCsim_Article( fwhm_switch, field_name, mask_name, D )