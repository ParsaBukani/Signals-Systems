# Fourier Analysis & Frequency-Based Communication

_Signals and Systems — University of Tehran_

This project explores the fundamental concepts of **Fourier Analysis**, frequency resolution, and the implementation of a **Frequency-Shift Keying (FSK)** communication system. The project is divided into two parts: analyzing signals in the frequency domain using the Discrete Fourier Transform (DFT) and developing a robust system for transmitting textual information using frequency-based encoding.

## Tasks

1.  **Fourier Analysis and Frequency Resolution**
    - Investigation of the relationship between continuous-time signals and their discrete-time representations using **FFT** and **fftshift**.
    - Analysis of a cosine signal $x(t) = \cos(10\pi t)$ to verify the appearance of dominant peaks at $\pm5$ Hz in the normalized magnitude spectrum.
    - Exploration of **Phase Analysis** by setting phase values to zero for negligible magnitudes to recover the theoretical phase shift of a signal (e.g., $\pi/4$ for a shifted cosine).
    - Study of **Frequency Resolution** ($\delta_f = 1/T$), demonstrating the system's ability to distinguish between closely spaced frequencies based on the time duration of the signal.

2.  **Frequency-Based Information Transmission**
    - Implementation of a **Character-to-Bit Mapping** (Mapset) for 32 unique characters (lowercase English, space, and punctuation) using 5-bit codes.
    - Development of a `freq_coding` function to modulate bitstreams into time-domain sinusoidal signals at varying bit rates (up to 5 bits/s).
    - Development of an **FFT-based Decoder** (`freq_decoding`) to identify dominant frequencies in received signal segments and reconstruct the original text.
    - **Noise Robustness Analysis**: Evaluation of the system under Additive White Gaussian Noise (AWGN).
    - Performance comparison between different bit rates, concluding that lower bit rates (e.g., 1 bit/s) offer higher noise tolerance compared to higher rates (e.g., 5 bits/s).
    - Analysis of the **Bandwidth-Speed Trade-off**, showing that increasing frequency separation improves robustness but requires more bandwidth.

## Project Report
_The full **Project Report** for this assignment is available here: [Report.pdf](./Report.pdf)_
