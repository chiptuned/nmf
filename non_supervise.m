close all force;
clear variables;
addpath('fonctions');
addpath('data');

%% Paramètres à modifier
f_c = 1000;
n_dict = 4;
music = 'audioSource_mix.wav';
N_win = 2^11;

%% Partie spectro
[audio, fe] = audioread(music);
N_lap = N_win/2;
N_fft = N_win;
[ stft, t, f ] = mystft(audio,N_win,N_lap,N_fft,fe);
stft_abs = abs(stft);
stft_angle = angle(stft);
stftlog = 10*log10(stft_abs+1);

figure(1);
aff_spectro(stft_abs, t, f, f_c, 1);
title(['Surf du spectrogramme. N_{win} = ', num2str(N_win), ', N_{lap} = ', num2str(N_lap), ...
	' et N_{fft} = ', num2str(N_fft)]);

%% NMF par beta-divergence
[W, H, costs] = nmf_unsupervised(stft_abs, 1, n_dict, 50, t, f, f_c, 2);

affichage_ecoute_nmf( audio, W, H, f_c, N_win, N_lap, N_fft, fe );

figure;
plot(costs)
title('Cout de la NMF en fonction des itérations')
