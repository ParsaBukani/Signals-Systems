# Communication System Simulation & Diabetes Classification

_Signals and Systems — University of Tehran_

This project is divided into two major parts: the simulation of a wireless communication system using **Amplitude Coding** to explore the trade-offs between data rate and noise robustness, and the implementation of a medical diagnostic tool using MATLAB’s **Classification Learner** to detect diabetes.

## Tasks

1.  **Amplitude Coding & Bitrate Analysis**
    - Construction of a **Mapset** to associate 32 distinct characters (letters and punctuation) with unique 5-bit binary codes.
    - Development of a `coding_amp` function to convert text messages into time-domain signals using specific amplitude levels for different bitrates ($1, 2, \text{ and } 3 \text{ bits/s}$).
    - Implementation of a `decoding_amp` function utilizing **discrete correlation** with a reference sinusoid ($2\sin(2\pi t)$) to recover transmitted bits from noise-free and noisy signals.
    - Analysis of **Gaussian Noise** impact: implementing threshold-based decision making and performing simulations to determine the maximum tolerable noise variance for each bitrate.
    - Exploration of the **Power-Speed Trade-off**: demonstrating how increasing transmitter power improves noise robustness by widening the spacing between amplitude levels.

2.  **Machine Learning for Diabetes Prediction**
    - Preprocessing of the `diabetes-training` dataset consisting of six medical features (e.g., Glucose, BMI, Age) and binary health labels.
    - Training a **Linear SVM (Support Vector Machine)** classifier using 5-fold cross-validation within the Classification Learner app.
    - **Feature Selection Analysis**: evaluating individual feature performance to identify **Glucose** as the most informative indicator of diabetes.
    - Model validation through manual evaluation of training-phase accuracy and assessment on a separate `diabetes-validation` dataset to measure generalization performance.

## Project Report
_The full **Project Report** for this assignment is available here: [Report.pdf](./Report.pdf)_
