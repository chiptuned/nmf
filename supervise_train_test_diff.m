close all force;
clearvars -except tracks fe musiques;
addpath('fonctions');
addpath('data');

if ~exist('tracks','var')
    [tracks, fe, musiques ] = get_tracks;
end

tracks_to_keep = [4,7];
% timestamp 32.971 à 35.917 bass guitar batterie
% TIMESTAMP 2,43.727 à 2,45.203 bass batterie
t_int = [32, 36]; % seconds
[ cutted ] = djing(tracks, tracks_to_keep, fe, t_int(1), t_int(2));
[ cutted_test ] = djing(tracks, tracks_to_keep, fe, 121, 129);

audio_V = mean(cutted_test,2);
% sound(audio_V, fe);
% pause;

%%% On va faire une NMF des tracks 2 et 4 et verifier leur présence dans le
%%% mix (track 10)
tracks_to_nmf = [1, 2];
n_dict_tracks  = [40, 40];
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
        filename = ['supervised-', num2str(ind),'.wav'];
    audiowrite(filename,cutted(:,ind),fe);
    W_tracks = [W_tracks, W_track];
end


[ stft_mix, t, f ] = mystft(audio_V,N_win,N_lap,N_fft,fe);
 
aff_spectro(abs(stft_mix), t, f, f_c, 1);
title(['Surf du spectrogramme. N_{win} = ', num2str(N_win), ', N_{lap} = ', num2str(N_lap), ...
	' et N_{fft} = ', num2str(N_fft)]);
n_dict_noise = 0;
[W, H, costs] = nmf_supervised(abs(stft_mix), W_tracks, beta, n_dict_noise, nb_iter, t, f, f_c, 2);
filename = ['supervised-mix.wav'];
audiowrite(filename,audio_V,fe);
audio_new = affichage_ecoute_nmf_supervised( audio_V, W, H, n_dict_tracks, f_c, N_win, N_lap, N_fft, fe );

%% calcul vite fait de ressemblance de signaux
d = abs(cutted_test(:,1))/sum(abs(cutted_test(:,1)));
newd = abs(audio_new(:,1))/sum(abs(audio_new(:,1)));
idx_max = min([numel(d), numel(newd)]);
bhat_d = -log(sum(sqrt(d(1:idx_max).*newd(1:idx_max))))

p = abs(cutted_test(:,2))/sum(abs(cutted_test(:,2)));
newp = abs(audio_new(:,2))/sum(abs(audio_new(:,2)));
bhat_p = -log(sum(sqrt(p(1:idx_max).*newp(1:idx_max))))

b = abs(audio_V)/sum(abs(audio_V));
newb = abs(audio_new(:,3))/sum(abs(audio_new(:,3)));
bhat_b = -log(sum(sqrt(b(1:idx_max).*newb(1:idx_max))))

bhat_test = -log(sum(sqrt(p(1:idx_max).*d(1:idx_max))))

figure;
plot(costs)
title('Cout de la NMF supervisée en fonction des itérations')


