# Radar Target Estimation & Musical Signal Synthesis

_Signals and Systems — University of Tehran_

This project explores practical applications of the **Discrete Fourier Transform (DFT)** and frequency-domain analysis. It is divided into two primary sections: a **Radar System** simulation for estimating the distance and velocity of moving targets, and a **Musical Signal** processing system for synthesizing melodies and automatically extracting notes from audio files.

## Tasks

1.  **Radar Signal Processing & Target Estimation**
    - Simulation of a transmitted cosine carrier signal ($f_c = 5$ Hz) and its reflected echo, incorporating **Doppler shifts** ($f_d = \beta V$) and **propagation delays** ($t_d = \rho R$).
    - Development of an automated estimation algorithm using the `fft` and `fftshift` functions to identify the dominant frequency and phase of the received signal.
    - **Multi-Target Analysis**: Implementation of a recursive peak-removal strategy to resolve and estimate parameters for multiple targets simultaneously.
    - **Robustness & Resolution Study**: Evaluation of estimation accuracy under varying Gaussian noise levels and analysis of the minimum velocity difference required to distinguish between two targets based on frequency resolution ($\delta_f = 1/T$).

2.  **Musical Signal Generation & Analysis**
    - Construction of a frequency-to-note **Mapset** for 12 standard musical notes (C to B) based on unique sinusoidal frequencies.
    - Synthesis of melodies by concatenating sinusoidal tones with specific durations ($T$ and $T/2$) and inserting short silence intervals ($\tau = 25$ ms) for rhythmic structure.
    - Development of an **Automatic Note Extractor** that utilizes:
        - **Time-Domain Segmentation**: Using short-time energy and thresholding to detect note boundaries.
        - **Frequency-Domain Analysis**: Applying the FFT to each segment to identify the pitch and estimate the note duration.
    - Verification of the system by reconstructing the note sequence from a synthesized `.wav` file and comparing it against the original score.

## Project Report
_The full **Project Report** for this assignment is available here: [Report.pdf](./Report.pdf)_
