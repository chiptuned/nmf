function [ audio_new ] = affichage_ecoute_nmf_supervised( audio, W, H, n_dict_tracks, f_c, N_win, N_lap, N_fft, fe )

n_dict = size(W,2);
[ stft_audio, t, f ] = mystft(audio,N_win,N_lap,N_fft,fe);
stft_angle = angle(stft_audio); 
figure;
dict = cumsum(n_dict_tracks);
dict = [0, dict, n_dict];
audio_new = [];
for ind = 1:numel(dict)-1
    spectro = W(:,(dict(ind)+1):dict(ind+1))*H((dict(ind)+1):dict(ind+1),:);
    aff_spectro(10*log10(spectro+1), t, f, f_c, 1);
    title(['Spectrogramme de l''élement ', num2str(ind), ...
        ' du dictionnaire en fonction de ses activations'])
    new_stft = spectro.*exp(1i*stft_angle);
    % A corriger le istft qui prend un NWIN ~ NFFT
    [new_x, ~] = istft(new_stft, N_lap, N_fft, fe);
    %fprintf('Appuyez sur une touche pour écouter le signal %d\n',ind);
    %pause
    fprintf('Ecoute du signal %d\n',ind);
    filename = ['supervised-', num2str(n_dict),'-', num2str(ind),'.wav'];
    audiowrite(filename,new_x,fe);
    sound(new_x,fe);
    pause(t(end)+0.5);
    audio_new = [audio_new,new_x(:)];
end