% [tracks, fe, musiques ] = get_tracks;
% 
% [ cutted ] = djing(tracks, 2, fe, 32, 36);

W = [W_bass,W_drums];
V = stft_abs;
% W = fixe(:,1:2); % prendre la guitare et le piano par exemple
Wb = rand(size(W));
W = [W,Wb];
n_dict = size(W,2);
H = rand(n_dict, size(V,2));
handle = affiche_nmf(W, H, t, f, f_c);
costs = [];
beta = 1;
for ind = 1:50
    Hb = H(9:end,:);
    Wb = Wb.*((((Wb*Hb).^(beta-2).*V)*Hb')./((Wb*Hb).^(beta-1)*Hb'));
    W = [W(:,1:8),Wb];
    H = H .* ((W'*((W*H).^(beta-2).*V))./(W'*(W*H).^(beta-1)));
    
    handle(1).CData = H;
    handle(2).CData = W;
    handle(3).CData = W*H;
    costs = [costs, betaDiv(V,W*H,beta)];
    drawnow;
end




