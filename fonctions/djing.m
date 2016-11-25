function [ cutted ] = djing(tracks, tracks_to_mix, fe, ts_start, ts_end)
    cutted = tracks(floor((fe*ts_start:fe*ts_end)),tracks_to_mix);
    