# Automatic License Plate Recognition (ALPR)

_Signals and Systems — University of Tehran_

This project implements a multi-stage **Automatic License Plate Recognition (ALPR)** system using digital signal and image processing techniques in MATLAB. The system evolves from recognizing standard English plates to detecting and extracting Persian characters from complex vehicle images using custom-built algorithms for segmentation and template matching.

## Tasks

1.  **Custom Image Preprocessing**
    - Development of `mygrayfun` to convert RGB images to grayscale using weighted channel combination: $Gray = 0.299R + 0.587G + 0.114B$.
    - Implementation of `mybinaryfun` for image thresholding and binarization.
    - Creation of `myremovecom`, a custom alternative to `bwareaopen`, using **Depth-First Search (DFS)** to eliminate noise and small non-character objects.

2.  **Character Segmentation & Recognition**
    - Implementation of `mysegmentation` (replacing `bwlabel`) to isolate individual characters through connected-component labeling via DFS.
    - Execution of **Template Matching** using 2D correlation (`corr2`) to compare segmented objects against a character database.
    - Automated text reconstruction and storage of recognized plate numbers in `.txt` format.

3.  **Persian Plate Processing**
    - Extension of the recognition pipeline to handle Iranian license plates.
    - Construction of a custom database for Persian digits ($۰-۹$) and specific letters (ب، ج، س، ص، ط، ق، ل، م، ن، و، ه، ی).
    - Implementation of an English mapping function to convert Persian results for cross-platform compatibility.

4.  **Plate Detection in Complex Scenes**
    - Application of **Normalized Cross-Correlation (NCC)** across RGB channels to locate the license plate within a full vehicle frontal image.
    - Dynamic region cropping using estimated bounding boxes to isolate the plate for high-accuracy character extraction.

## Project Report
_The full **Project Report** for this assignment is available here: [Report.pdf](./Report.pdf)_
