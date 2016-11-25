function [ im ] = aff_spectro(spectro, t, f, f_c, issurf)
if issurf
    im = surf(t, f, spectro);
else
    im = imagesc(t, f, spectro);
end
shading interp;
axis xy;
xlabel('Temps en secondes');
ylabel('Fréquence en Hz');
axis([t(1) t(end) f(1) f_c])
colormap jet;