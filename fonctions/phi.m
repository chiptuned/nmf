function [ exponent ] = phi( beta )

if beta <= 1
        exponent = 1/(2-beta);
    elseif beta > 2
        exponent = 1/(beta-1);
    else
        exponent = 1;
end

