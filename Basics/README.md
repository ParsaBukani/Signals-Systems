
# MATLAB Basics, Linear Systems & Radar Simulation

_Signals and Systems — University of Tehran_

This project serves as an introduction to **MATLAB** for signal processing, covering fundamental matrix operations, parameter estimation in noisy linear systems, and a practical application of cross-correlation in radar distance detection. The project is divided into three main sections: basic environment familiarity, linear regression analysis, and template matching for signal recovery.

## Tasks

1.  **MATLAB Fundamentals**
    - Definition of **scalar, vector, and matrix variables** using various built-in functions such as `logspace`, `reshape`, and `randi`.
    - Implementation of **mathematical equations** and matrix operations, including determinants and transposes.
    - Data manipulation through **indexing** and common statistical functions like `mean` and `sum`.
    - Visualization of signals using **multi-line plotting**, custom colors, and figure formatting including labels, legends, and axis limits.

2.  **Linear System Parameter Estimation**
    - Analysis of a linear system $y(t) = \alpha x(t) + \beta$ subjected to measurement noise.
    - Development of a custom function `p24.m` to estimate system gain ($\alpha$) and intercept ($\beta$) by **minimizing a cost function** using the Least Squares method.
    - Validation of the estimation algorithm by comparing results with MATLAB’s **Curve Fitting Toolbox**.

3.  **Radar Distance Detection**
    - Simulation of a **transmitted pulse signal** and its delayed, attenuated echo based on target distance.
    - Implementation of **Template Matching** using the `xcorr` (cross-correlation) function to estimate the time delay $t_d$ and calculate target distance $R = \frac{ct_d}{2}$.
    - **Robustness Analysis**: Performing Monte Carlo simulations (100 trials per noise level) to determine the maximum noise threshold where distance estimation remains within a 10-meter error margin.

## Project Report
_The full **Project Report** for this assignment is available here: [Report.pdf](./Report.pdf)_
