function [ handle ] = affiche_nmf(W, H, t, f, f_c, aff)

dict_axis = 1:size(H,1);

posV1 = [.1,.1,.1,.7];
posV2 = [.3,.1,.6,.7];
posV3 = [.3,.85,.6,.1];

subplot('Position', posV3)
im1 = imagesc(t, dict_axis, H);
title('Activations')
colormap jet;

subplot('Position', posV1)
im2 = imagesc(dict_axis, f, W);
ylim([f(1) f_c])
axis xy;
title('Dictionnaire')
colormap jet;

subplot('Position', posV2)
im3 = aff_spectro(W*H, t, f, f_c, aff);

handle = [im1, im2, im3];