function [ betaDiv ] = betaDiv( V, Wh, beta)

if beta == 0    
    % Itakura-Saito divergence
    betaDiv = sum((V(:)./Wh(:))-log(V(:)./Wh(:)) - 1);
    
elseif beta == 1    
    % Kullback-Leiber divergence
    betaDiv = sum(V(:).*(log(V(:))-log(Wh(:))) + Wh(:) - V(:));
    
else
    % Euclidian distance for beta = 2
    betaDiv = sum(1/(beta*(beta-1))*(V(:).^beta + (beta-1)*Wh(:).^beta - beta*V(:).*Wh(:).^(beta-1)));
end

