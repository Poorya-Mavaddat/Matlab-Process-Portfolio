function E = energy_model(R)
% ENERGY_MODEL  Simplified energy (reboiler duty proxy) as a function of reflux ratio R.
%   E(R) = 0.5*R^2 + 1.0*R + 1.0
    E = 0.5.*R.^2 + 1.0.*R + 1.0;
end
