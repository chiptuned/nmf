function [ stft, t, f ] = mystft(x, nwin, nlap, nfft, fs)

nb_col = ceil((length(x)-nwin)/(nwin-nlap));
nb_row = (nfft/2)+1;
h = hamming(nwin);
stft = zeros(nb_row, nb_col);

for ii = 1:nb_col
    debut = 1+(ii-1)*(nwin-nlap);
    segx = x(debut:debut+nwin-1);
    seg = segx.*h;
    res_fft = fft(seg,nfft);
    stft(:,ii) = res_fft(1:nb_row);
end

t = linspace(length(x)/(fs*nb_col), length(x)/fs, nb_col);
f = linspace(fs/(2*nb_row), fs/2, nb_row);