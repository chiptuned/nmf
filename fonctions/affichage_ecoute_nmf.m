function [ ] = affichage_ecoute_nmf( audio, W, H, f_c, N_win, N_lap, N_fft, fe )

n_dict = size(W,2);
[ stft_audio, t, f ] = mystft(audio,N_win,N_lap,N_fft,fe);
stft_angle = angle(stft_audio); 
figure;
for ind = 1:n_dict
    spectro = W(:,ind)*H(ind,:);
    aff_spectro(10*log10(spectro+1), t, f, f_c, 1);
    title(['Spectrogramme de l''élement ', num2str(ind), ...
        ' du dictionnaire en fonction de ses activations'])
    new_stft = spectro.*exp(1i*stft_angle);
    % A corriger le istft qui prend un NWIN ~ NFFT
    [new_x, new_t] = istft(new_stft, N_lap, N_fft, fe);
    %fprintf('Appuyez sur une touche pour écouter le signal %d\n',ind);
    %pause
    fprintf('Ecoute du signal %d\n',ind);
    sound(new_x,fe);
    pause(t(end)+0.5);
end