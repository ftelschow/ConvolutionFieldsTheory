function runLKC2D(run)
%Need total runs: 24
% Tests voxelwise coverage on the simulations
D = 2;
fwhm_vec = [ 1 2 3 4 5 6 ];
nsubj = 100;

% D = dim_vec(mod(run,3));
if run < 6
   field_type = "stationary";
   mask_name = "sphere";
elseif run < 12
    field_type = "stationary";
    mask_name = "box";
elseif run < 18
    field_type = "nonstationary";
    mask_name = "sphere";
else
    field_type = "nonstationary";
    mask_name = "box";
end

fwhm = fwhm_vec(mod(run,6)+1);

store_data = FWERsim_Article( D, fwhm, nsubj, field_type, mask_name, 1);

saveloc = ['~/MatlabToolboxes/ConvolutionFieldsTheory/Results/', ...
           char(field_type), '_', char(mask_name), '/', 'D_', num2str(D),...
           '_nsubj_', num2str(nsubj), '_fwhm_', num2str(fwhm)];
save(saveloc, 'store_data')

end
