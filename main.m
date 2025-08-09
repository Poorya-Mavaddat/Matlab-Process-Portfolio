% main.m - Energy Optimization of a Distillation Column
% Author: <Your Name>
% Description:
%   Minimize reboiler energy E(R) subject to a product purity constraint P(R) >= 0.95.
%   Generates plots and a results summary in the 'results' folder.

clear; clc; close all;

% Ensure folders exist
if ~exist('results', 'dir'); mkdir('results'); end
if ~exist('data', 'dir'); mkdir('data'); end
if ~exist('functions', 'dir'); mkdir('functions'); end

% Add functions path
addpath('functions');

% Load (optional) simulated dataset for plotting reference
dataFile = fullfile('data','column_data.csv');
if exist(dataFile, 'file')
    tbl = readtable(dataFile);
    R_data = tbl.reflux_ratio_R;
    E_data = tbl.energy_unitless;
    P_data = tbl.purity_fraction;
else
    warning('Data file not found. Proceeding without reference points.');
    R_data = []; E_data = []; P_data = [];
end

% Define objective and constraint
objective = @(R) energy_model(R);
nonlcon  = @(R) purity_constraint(R);

% Bounds and initial guess
R0 = 2.0;        % initial reflux ratio
lb = 1.0;        % lower bound
ub = 10.0;       % upper bound

% Optimize
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
[R_opt, E_opt] = fmincon(objective, R0, [], [], [], [], lb, ub, nonlcon, options);

% Evaluate purity at optimum
P_opt = purity_model(R_opt);

% Sweep for plotting
R = linspace(lb, ub, 200);
E = arrayfun(@energy_model, R);
P = arrayfun(@purity_model, R);

% ---- Plot Energy vs R ----
figure('Position',[100 100 800 500]);
plot(R, E, 'LineWidth', 1.8); hold on;
if ~isempty(R_data)
    scatter(R_data, E_data, 12, 'filled', 'MarkerFaceAlpha', 0.3);
end
yline(E_opt, '--', sprintf('E* = %.3f', E_opt), 'LabelHorizontalAlignment','left');
xline(R_opt, '--', sprintf('R* = %.3f', R_opt), 'LabelHorizontalAlignment','left');
xlabel('Reflux Ratio R'); ylabel('Energy E (arb. units)');
title('Energy vs. Reflux Ratio');
grid on;
saveas(gcf, fullfile('results','energy_vs_R.png'));

% ---- Plot Purity vs R ----
figure('Position',[100 100 800 500]);
plot(R, P, 'LineWidth', 1.8); hold on;
if ~isempty(R_data)
    scatter(R_data, P_data, 12, 'filled', 'MarkerFaceAlpha', 0.3);
end
yline(0.95, '--', 'Purity Constraint (0.95)');
xline(R_opt, '--', sprintf('R* = %.3f', R_opt), 'LabelHorizontalAlignment','left');
xlabel('Reflux Ratio R'); ylabel('Product Purity (fraction)');
title('Purity vs. Reflux Ratio');
ylim([0.8 1.01]);
grid on;
saveas(gcf, fullfile('results','purity_vs_R.png'));

% ---- Save results summary ----
fid = fopen(fullfile('results','optimization_results.txt'),'w');
fprintf(fid, 'Optimal Reflux Ratio R*: %.6f\n', R_opt);
fprintf(fid, 'Optimal Energy E*: %.6f\n', E_opt);
fprintf(fid, 'Purity at Optimum P(R*): %.6f\n', P_opt);
fclose(fid);

fprintf('\nDone. Results saved in the results/ folder.\n');

% ---- Nonlinear constraint helper ----
function [c, ceq] = purity_constraint(R)
    % Purity must be >= 0.95  -->  c <= 0
    Pval = purity_model(R);
    c   = 0.95 - Pval;  % inequality constraint
    ceq = [];
end
