function [W, H, costs] = nmf_supervised(V, W, beta, n_dict_noise, nb_iter, t, f, f_c, aff)
% INPUTS :  - V : matrice m*n � factoriser
%           - W : dictionnaire fix�
%           - beta : scalaire, hyper-param�tre de la beta-divergence
%               0 pour Itakura-Saito
%               1 pour Kulllbacks-Leiber
%               2 pour Euclidenne
%           - n_dict_noise : scalaire, nombre d'entr�es du dictionnaire
%           pour le bruit
%           - nb_iter : nombre d'iterations de l'algorithme
%           - t : vecteur 1*n temps associ� � V
%           - f : vecteur 1*m des fr�quences associ� � V
%           - f_c : scalaire, fr�quence de coupure pour affichage (Hz)
%           - aff : hyper-param�tre d'affichage de la figure
%               0 pour aucune figure
%               1 pour figure avec le r�sultat brut (imagesc)
%               2 pour figure avec le r�sultat interpol� (surf, interp)
% OUTPUTS : - W : matrice m*n_dict, dictionnaire 
%           - H : matrice n_dict*n, activations
%           - costs : vecteur 1*nb_iter des couts associ�s � chaque iter.
% Cette fonction calcule la NMF non supervis�e avec la beta-divergence.
% On note que t, f, f_c sont des scalaires pour l'affichage de V. Cette
% fonction � �t� cr�e dans un certain contexte d'utilisation, o� V est un
% spectrogramme (TFCT) d'un enregistrement sonore. On privil�gera
% l'utilisation de la distance d'Itakura-Saito (beta=0).

%% Initialisation
Wb = rand(size(W,1),n_dict_noise);
n_dict_fixed = size(W,2);
W = [W, Wb];
H = rand(size(W,2), size(V,2));

if aff ~= 0
    figure;
    v = VideoWriter(['supervised_rendu-n_dict-', num2str(n_dict_fixed),'.mp4'],'MPEG-4');
    handle = affiche_nmf(W, H, t, f, f_c, aff-1);
    pause;
    open(v)
    F=getframe(gcf);
    writeVideo(v,F.cdata);
end

costs = zeros(1,nb_iter);

%% Calcul de chaque it�ration
for ind = 1:nb_iter
    Hb = H(n_dict_fixed+1:end,:);
    Wb = Wb.*((((Wb*Hb).^(beta-2).*V)*Hb')./((Wb*Hb).^(beta-1)*Hb'));
    W(:,n_dict_fixed+1:end) = Wb;
    H = H .* ((W'*((W*H).^(beta-2).*V))./(W'*(W*H).^(beta-1)));

    energie_W = sum(W);
    W = W./repmat(energie_W,size(W,1),1);
    H = H.*repmat(energie_W,size(H,2),1)';
    
    % normaliser les energies
    % normaliser en activation repr�sente des probabilit�s
    % en dictionnaire, on normaliser bruit 
    if aff ~= 0
        handle(1).CData = H;
        handle(2).CData = W;
        handle(3).CData = 10*log10(W*H+1);
        F=getframe(gcf);
        for ind2 = 1:5
            writeVideo(v,F.cdata);
        end
        drawnow;
    end
    costs(ind) = betaDiv(V, W*H, beta);
end
