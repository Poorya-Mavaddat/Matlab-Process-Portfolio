function P = purity_model(R)
% PURITY_MODEL  Simplified product purity as a function of reflux ratio R.
%   P(R) = 0.8 + 0.2*(1 - exp(-(R-1)/2))
    P = 0.8 + 0.2*(1 - exp(-(R-1)./2));
    % Clip to [0,1] to avoid numerical issues
    P = max(min(P, 1.0), 0.0);
end
