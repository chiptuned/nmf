function [ cutted ] = djing(tracks, tracks_to_mix, fe, ts_start, ts_end)
% INPUTS :  - tracks : matrice m*n de n pistes de m échantillons
%           - tracks_to_mix : vecteur 1*p du numéro des pistes à rendre
%           - fe : fréquence d'échantillonage
%           - ts_start : temps du début de la découpe
%           - ts_end : temps de fin de la découpe
% OUTPUT :  - cutted : matrice m2*p de p pistes de m2 échantillons
% Cette fonction permet de selectionner certaines pistes de la variable
% tracks contenant différentes pistes audio, selon les numéros de pistes du
% vecteur tracks_to_mix, dans la zone temporelle [ts_start, ts_end].
    cutted = tracks(floor((fe*ts_start:fe*ts_end)),tracks_to_mix);
    