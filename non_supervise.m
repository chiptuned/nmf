close all force;
clear variables;
addpath(genpath(pwd));

f_c = 1000;

%% Partie spectro
[audio, fe] = audioread('audioSource_mix.wav');
N_win = 2^11;
N_lap = N_win/2;
N_fft = 2^14;
[ stft, t, f ] = mystft(audio,N_win,N_lap,N_fft,fe);
stft_abs = abs(stft);
stft_angle = angle(stft);
stftlog = 10*log10(stft_abs+1);

figure(1);
imagesc(t, f, stft_abs)
shading interp;
axis xy;
axis([t(1) t(end) f(1) f_c])
hold on;

title(['Surf du spectrogramme. N_{win} = ', num2str(N_win), ', N_{lap} = ', num2str(N_lap), ...
	' et N_{fft} = ', num2str(N_fft)]);
xlabel('Temps en secondes');
ylabel('Fréquences en Hertz');
colormap jet;
hold on; 

%% NMF par beta-divergence
n_dict = 4;
V = stft_abs;
W = rand(size(V,1), n_dict);
H = rand(n_dict, size(V,2));

% Bregman? https://en.wikipedia.org/wiki/Bregman_divergence

% Pour l'affichage sur la figure
dict_axis = 1:n_dict;

figure(2);
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
ylabel('Fréquence en Hz');
colormap jet;

subplot('Position', posV2)
im3 = imagesc(t, f, W*H);
shading interp;
axis xy;
xlabel('Temps en secondes');
axis([t(1) t(end) f(1) f_c])
colormap jet;
pause;

beta = 1; % euclidien=2
for ind = 1:50
    W_p = W;
    W = W.*((((W*H).^(beta-2).*V)*H')./((W*H).^(beta-1)*H'));
    H = H .* ((W_p'*((W_p*H).^(beta-2).*V))./(W_p'*(W_p*H).^(beta-1)));

    im1.CData = H;
    im2.CData = W;
    im3.CData = W*H;
    drawnow;
end

% for ind = 1:n_dict
%     spectro = flipud(W(:,ind)*H(ind,:));
%     figure
%     imagesc(spectro)
%     new_stft = spectro.*exp(1i*stft_angle);
%     % A corriger le istft qui prend un NWIN ~ NFFT
%     [new_x, new_t] = istft(new_stft, N_lap, N_fft, fe);
%     fprintf('Appuyez sur une touche pour écouter le signal %d\n',ind);
%     pause
%     sound(new_x,fe);
% end

% timestamp 32.971 à 35.917 bass guitar batterie
% TIMESTAMP 2,43.727 à 2,45.203 bass batterie
