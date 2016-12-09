function [ cutted ] = djing(tracks, tracks_to_mix, fe, ts_start, ts_end)
% INPUTS :  - tracks : matrice m*n de n pistes de m �chantillons
%           - tracks_to_mix : vecteur 1*p du num�ro des pistes � rendre
%           - fe : fr�quence d'�chantillonage
%           - ts_start : temps du d�but de la d�coupe
%           - ts_end : temps de fin de la d�coupe
% OUTPUT :  - cutted : matrice m2*p de p pistes de m2 �chantillons
% Cette fonction permet de selectionner certaines pistes de la variable
% tracks contenant diff�rentes pistes audio, selon les num�ros de pistes du
% vecteur tracks_to_mix, dans la zone temporelle [ts_start, ts_end].
    cutted = tracks(floor((fe*ts_start:fe*ts_end)),tracks_to_mix);
    