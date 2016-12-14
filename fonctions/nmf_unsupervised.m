function [W, H, costs] = nmf_unsupervised(V, beta, n_dict, nb_iter, t, f, f_c, aff)
% INPUTS :  - V : matrice m*n � factoriser
%           - beta : scalaire, hyper-param�tre de la beta-divergence
%               0 pour Itakura-Saito
%               1 pour Kulllbacks-Leiber
%               2 pour Euclidenne
%           - n_dict : scalaire, nombre d'entr�es du dictionnaire
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
W = rand(size(V,1), n_dict);
H = rand(n_dict, size(V,2));

if aff ~= 0
    figure;
    handle = affiche_nmf(W, H, t, f, f_c, aff-1);
    pause;
end

costs = zeros(1,nb_iter);

%% Calcul de chaque it�ration
for ind = 1:nb_iter
    W = W.*((((W*H).^(beta-2).*V)*H')./((W*H).^(beta-1)*H'));
    H = H .* ((W'*((W*H).^(beta-2).*V))./(W'*(W*H).^(beta-1)));

    energie_W = sum(W);
    W = W./repmat(energie_W,size(W,1),1);
    H = H.*repmat(energie_W,size(H,2),1)';
    
    if aff ~= 0
        handle(1).CData = H;
        handle(2).CData = W;
        handle(3).CData = W*H;
        drawnow;
    end
    costs(ind) = betaDiv(V, W*H, beta);
end
