close all force;
clear variables;
addpath(genpath(pwd));

%% Partie spectro
[audio, fe] = audioread('audioSource_mix.wav');
N_win = 2^10;
N_lap = N_win/2;
N_fft = 2^10;
[ stft, t, f ] = mystft(audio,N_win,N_lap,N_fft,fe);
stft_abs = abs(stft);
stft_angle = angle(stft);
stftlog = 10*log10(stft_abs+1);

figure;
surf(t, f, stftlog)
shading interp;
axis xy;
axis([t(1) t(end) f(1) 1E3])
hold on;

title(['Surf du spectrogramme. N_{win} = ', num2str(N_win), ', N_{lap} = ', num2str(N_lap), ...
	' et N_{fft} = ', num2str(N_fft)]);
xlabel('Temps en secondes');
ylabel('Fréquences en Hertz');
colormap jet;
hold on; 

%% Partie NMF

% On récupère la matrice a faire en nmf
f_c = 1000;
%idx_f_c = find((f-f_c)>0);
%V = flipud(stftlog(1:idx_f_c(1),:));
V = flipud(stft_abs(:,:));

n_dict = 3;
W = rand(size(V,1), 3);
H = rand(3, size(V,2));

% for ind = 1:30
%     W = W .* (V*H')./((W*H)*H');
%     H = H .* (W'*V)./(W'*(W*H));
%     positionV1 = [0.1,0.1,0.1,0.6];
%     positionV2 = [0.3,0.1,0.6,0.6];
%     positionV3 = [0.3,0.8,0.6,0.1];
%     subplot('Position',positionV3)
%     imagesc(H);
%     subplot('Position',positionV1)
%     imagesc(W);
%     subplot('Position',positionV2)
%     imagesc(W*H);
%     pause(0.2)
% end

% Mon gros beta divergence ... sinon, ils ne voleraient pas

beta  = 2; % euclidien
W = rand(size(V,1), 3);
H = rand(3, size(V,2));
figure;
for ind = 1:50
    W_p = W;
    W = W.*((((W*H).^(beta-2).*V)*H')./((W*H).^(beta-1)*H'));
    H = H .* ((W_p'*((W_p*H).^(beta-2).*V))./(W_p'*(W_p*H).^(beta-1)));
    positionV1 = [0.1,0.1,0.1,0.6];
    positionV2 = [0.3,0.1,0.6,0.6];
    positionV3 = [0.3,0.8,0.6,0.1];
    subplot('Position',positionV3)
    imagesc(H);
    subplot('Position',positionV1)
    imagesc(W);
    subplot('Position',positionV2)
    imagesc(W*H);
    pause(0.2)
end

% breggman

for ind = 1:n_dict
    spectro = flipud(W(:,ind)*H(ind,:));
    figure
    imagesc(spectro)
    new_stft = spectro.*exp(1i*stft_angle);
    [new_x, new_t] = istft(new_stft, N_lap, N_fft, fe);
    fprintf('Appuyez sur une touche pour écouter le signal %d\n',ind);
    pause
    sound(new_x,fe);
end

% timestamp 32.971 à 35.917 bass guitar batterie
% TIMESTAMP 2,43.727 à 2,45.203 bass batterie

    
