
# Image Steganography & Infrared Target Tracking

_Signals and Systems — University of Tehran_

This project is divided into two distinct sections: the implementation of an **Image Steganography** system to hide text within grayscale images, and the development of an automated **Target Tracking** script for identifying aircraft in infrared (IR) video sequences.

## Tasks

1.  **Image Steganography (LSB Encoding)**
    - Creation of a **Mapset** to associate 32 specific characters (lowercase English, space, and punctuation) with unique 5-bit binary codes.
    - Development of a `coding` function to embed messages into a grayscale image by modifying the **Least Significant Bit (LSB)** of selected pixels.
    - Implementation of an error-handling mechanism to notify the user if the message length exceeds the available image capacity.
    - Visualization of results using `subplot` to demonstrate that the small intensity variations are imperceptible to the human eye.

2.  **Message Decryption & Robustness**
    - Development of a `decoding` function to sequentially extract LSBs and reconstruct the original text based on the 5-bit Mapset.
    - Analysis of **noise impact** on hidden data, determining that bit-flips in selected pixels can corrupt the message and lead to recovery failure.

3.  **Infrared Aircraft Tracking**
    - Development of a script, `myTracker.m`, to detect and follow moving aircraft in IR camera footage without using pre-built MATLAB tracking apps.
    - Implementation of a **User-Defined Masking** system to exclude static objects (e.g., trees or on-screen text) and prevent false detections.
    - Use of **Frame Differencing**, Gaussian filtering, and morphological operations to isolate moving targets.
    - Implementation of an **Adaptive Bounding Box** that dynamically resizes as the aircraft changes distance from the camera.

## Project Report
_The full **Project Report** for this assignment is available here: [Report.pdf](./Report.pdf)_
