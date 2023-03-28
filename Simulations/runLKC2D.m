function runLKC2D(run)
%Need total runs: 28
% Tests voxelwise coverage on the simulations
D = 2;
fwhm_vec = [ 1 2 3 4 5 6 ];
nsubj = 100;

% D = dim_vec(mod(run,3));
fwhm = fwhm_vec(mod(run,7));
if mod(run,4) <= 1
    field_type = "stationary";
else
    field_type = "nonstationary";
end

if mod(run,4) == 1 || mod(run,4) == 3
    mask_name = "sphere";
else
    mask_name = "box";
end

saveloc = './FWER_results/';

if nsubj > 1 % don't run the nsubj = 1 case (just included to make things prime)
    store_data = FWERsim_Article( D, fwhm, nsubj, field_type, mask_name, 5000);
    saveloc = [saveloc, char(field_type), '_', char(mask_name), '/'];
    saveloc = [saveloc, 'D_', num2str(D), '_nsubj_', num2str(nsubj), '_fwhm_', num2str(fwhm)];
    save(saveloc, 'store_data')
end

end