close all force;
clearvars -except tracks fe musiques;
addpath('fonctions');
addpath('data');

if ~exist('tracks','var')
    [tracks, fe, musiques ] = get_tracks;
end

tracks_to_keep = [2,4,10];
% timestamp 32.971 à 35.917 bass guitar batterie
% TIMESTAMP 2,43.727 à 2,45.203 bass batterie
t_int = [32, 36]; % seconds
[ cutted ] = djing(tracks, tracks_to_keep, fe, t_int(1), t_int(2));

%%% On va faire une NMF des tracks 2 et 4 et verifier leur présence dans le
%%% mix (track 10)
tracks_to_nmf = [1, 2];
n_dict_tracks = [4, 4];
N_win = 2^11;
N_lap = N_win/2;
N_fft = N_win;
W_tracks = [];
f_c = 1000;
beta = 1;
nb_iter = 50;
for ind = 1:numel(tracks_to_nmf)
    [ stft, t, f ] = mystft(cutted(:,ind),N_win,N_lap,N_fft,fe);
    [W_track, H_track, ~] = nmf_unsupervised(abs(stft), beta, n_dict_tracks(ind), ...
        nb_iter, t, f, f_c, 0);
    W_tracks = [W_tracks, W_track];
end

[ stft_mix, t, f ] = mystft(cutted(:,end),N_win,N_lap,N_fft,fe);

aff_spectro(abs(stft_mix), t, f, f_c, 1);
title(['Surf du spectrogramme. N_{win} = ', num2str(N_win), ', N_{lap} = ', num2str(N_lap), ...
	' et N_{fft} = ', num2str(N_fft)]);
n_dict_noise = 10;
[W, H, costs] = nmf_supervised(abs(stft_mix), W_tracks, beta, n_dict_noise, nb_iter, t, f, f_c, 1);

affichage_ecoute_nmf( cutted(:,end), W, H, f_c, N_win, N_lap, N_fft, fe )


