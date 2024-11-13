# Matlab Sample

This repository contains sample MATLAB and Dynare scripts focused on macroeconomic model estimation and calibration, specifically using Bayesian techniques within a DSGE (Dynamic Stochastic General Equilibrium) framework.

## Overview

The codes in this repository demonstrate steps in setting up a DSGE model, calibrating and estimating parameters, and performing Bayesian estimation. Key functions include generating impulse response functions, shock decompositions, and visualizations to support macroeconomic analysis.

## Repository Structure

1. **Bayesian_Macro_Model_Estimation_DSGE.m**
   - The primary script for setting up and estimating a macroeconomic DSGE model using Bayesian estimation. This code includes variable declarations, parameter settings, model equations, and estimation procedures.

2. **doing_plots_new.m**
   - A plotting script for visualizing model outputs, including impulse response functions (IRFs) and historical decomposition graphs, designed to support the interpretation of macroeconomic shocks.

3. **plots_for_dynare.m**
   - Helper functions for generating Dynare-specific plots, enhancing the visual representation of model results.

## Getting Started

### Prerequisites

To use these scripts, the following are required:

- **MATLAB**: These scripts are designed to run in MATLAB, utilizing certain MATLAB-specific functions and syntax.
- **Dynare**: The scripts rely on Dynare, a preprocessor and collection of MATLAB routines specifically designed for DSGE modeling.

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/Matlab_sample.git
    ```

2. Ensure that MATLAB and Dynare are installed and configured in your environment.

### Running the Code

1. Open MATLAB and navigate to the folder where the repository is cloned.
2. Run `Bayesian_Macro_Model_Estimation_DSGE.m` to set up and estimate the DSGE model.
3. Use `doing_plots_new.m` and `plots_for_dynare.m` to visualize the results.

## Acknowledgements

This repository builds upon the foundational work of researchers and contributors who developed the basis for these scripts. Additional improvements and adaptations were made to tailor the code for specific research objectives.

## License

This repository is provided for educational and research purposes. Please acknowledge any use of the code in academic work, and adhere to any licensing requirements associated with MATLAB and Dynare.
