# Energy Optimization of a Distillation Column (MATLAB)

**Goal:** Minimize reboiler energy consumption while maintaining required product purity (≥ 95%).

## Data
- Simulated column data located in `data/column_data.csv` with columns:
  - `reflux_ratio_R` — reflux ratio (R)
  - `energy_unitless` — proxy for reboiler duty (arbitrary units)
  - `purity_fraction` — top product purity (0–1)

## Method
- Optimization is performed over reflux ratio `R` using MATLAB's **Optimization Toolbox** (`fmincon`).
- Objective: minimize energy E(R).
- Constraint: purity P(R) ≥ 0.95.
- Models (simplified, for portfolio demonstration):
  - Energy: `E(R) = 0.5*R^2 + 1.0*R + 1.0` (convex increasing)
  - Purity: `P(R) = 0.8 + 0.2*(1 - exp(-(R-1)/2))` (saturating with R)

## Files
- `main.m` — runs the optimization and generates plots into `results/`.
- `functions/energy_model.m` — energy model function.
- `functions/purity_model.m` — purity model function.
- `data/column_data.csv` — simulated dataset (100 samples).

## Results
Running `main.m` will:
- Compute the optimal `R*` that satisfies purity ≥ 0.95 with minimum energy.
- Generate two plots saved to `results/`:
  - `energy_vs_R.png`
  - `purity_vs_R.png`
- Save a text summary to `results/optimization_results.txt`.

## Skills Demonstrated
- Process optimization (nonlinear constraint)
- Data visualization
- MATLAB scripting and function organization

## How to Run
1. Open MATLAB and set this project folder as the current directory.
2. Ensure you have the **Optimization Toolbox**.
3. Run:
   ```matlab
   main
   ```
4. Check the `results/` folder for images and a summary file.

## Notes
- This is a **portfolio-friendly** example with a simplified model.
- For a more advanced version, replace `purity_model.m` and `energy_model.m` with calibrated models from plant data or Aspen exports.
