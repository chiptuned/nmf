close all force;
clear variables;
addpath(genpath(pwd));

%% Param�tres � modifier
f_c = 1000;
n_dict = 4;
music = 'audioSource_mix.wav';
N_win = 2^11;

%% Partie spectro
[audio, fe] = audioread(music);
size(audio)
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
V = stft_abs;
W = rand(size(V,1), n_dict);
H = rand(n_dict, size(V,2));

% Bregman? https://en.wikipedia.org/wiki/Bregman_divergence

% Pour l'affichage sur la figure
figure(2);
handle = affiche_nmf(W, H, t, f, f_c);
pause;

beta = 1; % euclidien=2
for ind = 1:50
    W_p = W;
    W = W.*((((W*H).^(beta-2).*V)*H')./((W*H).^(beta-1)*H'));
    H = H .* ((W_p'*((W_p*H).^(beta-2).*V))./(W_p'*(W_p*H).^(beta-1)));

    handle(1).CData = H;
    handle(2).CData = W;
    handle(3).CData = W*H;
    drawnow;
end

pause(1)
for ind = 1:n_dict
    spectro = W(:,ind)*H(ind,:);
    figure(3);
    aff_spectro(10*log10(spectro+1), t, f, f_c, 1);
    title('Spectrogramme du premier �lement du dictionnaire en fonction de ses activations')
    new_stft = spectro.*exp(1i*stft_angle);
    % A corriger le istft qui prend un NWIN ~ NFFT
    [new_x, new_t] = istft(new_stft, N_lap, N_fft, fe);
    %fprintf('Appuyez sur une touche pour �couter le signal %d\n',ind);
    %pause
    fprintf('Ecoute du signal %d\n',ind);
    sound(new_x,fe);
    pause(t(end)+0.5);
end

% timestamp 32.971 � 35.917 bass guitar batterie
% TIMESTAMP 2,43.727 � 2,45.203 bass batterie
