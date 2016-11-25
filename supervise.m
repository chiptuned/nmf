


V = stft_abs;
W = fixe(:,1:2); % prendre la guitare et le piano par exemple
Wb = rand(size(V,1), n_dict);
W = [W,Wb];
H = rand(n_dict, size(V,2));

for ind = 1:50
    Hb = H(:,end);
    Wb = Wb.*((((Wb*Hb).^(beta-2).*V)*Hb')./((Wb*Hb).^(beta-1)*Hb'));
    H = H .* ((W'*((W*H).^(beta-2).*V))./(W'*(W*H).^(beta-1)));
    W = [W(:,1:end-1),Wb];

    handle(1).CData = H;
    handle(2).CData = W;
    handle(3).CData = W*H;
    drawnow;
end