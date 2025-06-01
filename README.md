# Repository: Bhargavi_Podili Thesis_Code_Repo

## Structure
This repository contains the chapter-wise code used in the thesis. Each folder below corresponds to a chapter from the thesis.

```
Bhargavi_Podili_Thesis_Code_Repo/
├── Chapter1_LR/
├── Chapter2_Seismic Zone Map/
├── Chapter3_V-by-H ground motion model/
├── Chapter4_Alternative ground motion models/
├── Chapter5_Spectral GMMs using Transfer Learning/
├── Chapter6_CVAE model for EEW application/
├── Chapter7_Source-Scaling Laws/
├── Chapter8_cGAN model for PSD of slip/
├── Chapter9_SPECFEM 2D sample code/
├── LICENSE
├── .gitignore
└── README.md
```

## Instructions
- Each chapter folder contains relevant scripts, Jupyter notebooks, or data processing tools.
- Run code inside each folder by following instructions in its `README.md`.

---

## Chapter Index

### Chapter 1: Literature Review

### Chapter 2: Seismic Zone Map for India Based on Cluster Analysis of Uniform Hazard Response Spectra
This chapter corresponds to the methodology described in:

**"Seismic Zone Map for India Based on Cluster Analysis of Uniform Hazard Response Spectra"**  
Google Scholar link: [View Publication](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=1C7dL7YAAAAJ&citation_for_view=1C7dL7YAAAAJ:WF5omc3nYNoC)


### Chapter 3: A Vertical-to-Horizontal Spectral Ratio Model for India
This chapter corresponds to the methodology described in:

**"A Vertical-to-Horizontal Spectral Ratio Model for India"**  
Google Scholar link: [View Publication](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=1C7dL7YAAAAJ&citation_for_view=1C7dL7YAAAAJ:IjCSPb-OGe4C)

**Folder contents:**
- `data/`: Provided in Appendix tables A1, A2 and A3 of thesis
- `code/`: MATLAB script `BSR_2022.m` for computing V/H spectral ratio given magnitude, distance, depth, and site class

**To run the code:**
- Requires MATLAB installed (tested on R2020a or later)
- Call the function as:
  ```matlab
  [T, VbyHSa] = BSR_2022(Mw, R, H, Sc);
  ```
- Inputs:
  - `Mw`: Moment magnitude
  - `R`: Source-to-site distance (km)
  - `H`: Hypocentral depth (km)
  - `Sc`: Site class (0=rock, 1=firm, 2=soft)
- Output:
  - `T`: Periods (s)
  - `VbyHSa`: V/H spectral ratio at each period

### Chapter 4: Alternative Regional Ground Motion Models for Western Himalayas
This chapter corresponds to the regional ground motion modeling presented in:

**"Alternative Regional Ground Motion Models for Western Himalayas"**  
Google Scholar link: [View Publication](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=1C7dL7YAAAAJ&citation_for_view=1C7dL7YAAAAJ:W7OEmFMy1HYC)

**Folder contents:**
- `data/`: Provided in Appendix tables A1, A2 and A3 of thesis
- `code/`: MATLAB or Python scripts for regression model development, residual analysis, mixed-effects modeling

**Data files:**
- `Models_SaH.xlsx` contains the regression input and fitted outputs for horizontal ground motion models used in Chapter 4.
- `Models_VbyH.xlsx` includes the corresponding V/H spectral ratio data and model estimates for comparison and residual analysis.

### Chapter 5: Spectral Ground Motion Models for Himalayas using Transfer Learning Technique
This chapter corresponds to the transfer learning-based spectral modeling presented in:

**"Spectral Ground Motion Models for Himalayas using Transfer Learning Technique"**  
Google Scholar link: [View Publication](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=1C7dL7YAAAAJ&citation_for_view=1C7dL7YAAAAJ:Se3iqnhoufwC)

**Folder contents:**
- `data/`: Tables in Appendix, plus network normalization parameters stored internally
- `code/`: Contains model definition, transfer learning, and prediction functions

**Code files:**
- `DNN_TransferLearning.m`: Trains a two-stage deep neural network for spectral prediction using transfer learning from global (NGA-West2) to local (Himalayan) data
- `BJR2024_FAS.m`: Predicts Fourier Amplitude Spectrum from magnitude, distance, depth, and site class
- `BJR2024_SA.m`: Converts predicted FAS and significant duration into spectral acceleration values

**Model files:**
- `myDNNfas.mat`: Trained FAS model used in `BJR2024_FAS.m`
- `myDNNsa.mat`: Trained SA model used in `BJR2024_SA.m`

**To run the FAS and SA prediction pipeline:**
```matlab
[f, FAS] = BJR2024_FAS(Mw, R, H, Sc);
[T, SA] = BJR2024_SA(FAS, Tsig);
```

### Chapter 6: A Deep Learning Prediction Model for On-Site Earthquake Early Warning System in India
This chapter corresponds to the early warning system proposed in:

**"A Deep Learning Prediction Model for On-Site Earthquake Early Warning System in India"**  
*Under review (Round 2), Journal of Seismology*

**Folder contents:**
- `deployment.py`: Python script for loading the trained EEW model and making real-time predictions from seismic input features
- `himalayan_eew_system.pkl`: Trained multi-output prediction model for on-site EEW application in Himalayan region

**To run a sample prediction:**
```python
python deployment.py
```
This executes a test input with 8 EEW features (`PGA`, `PGD`, `Fp`, `Tsig`, `Ia`, `CAV`, `vs30`, `dir`) and returns predicted outputs such as ground motion metrics.

### Chapter 7: Estimating Deterministic Seismic Source Parameters for Varied Tectonics, Fault Mechanisms and Regions
This chapter focuses on building a consistent parameter dataset for deterministic seismic source modeling across regions, based on tectonic regime, faulting mechanism, and observed seismicity.

**Under review, Geophysical Journal International**

**Folder contents:**
- `DataBase_Meta.xlsx`: Metadata for curated earthquake database across Indian tectonic regimes
- `Predictions/`: Contains model-generated source parameters and MATLAB scripts used for estimating source energy (SE) and slip
- `Data2.mat`, `ModelF.mat`, `Total274.mat`: MATLAB data files used to generate predictions and validate fault-based regression outputs

**Code files:**
- `FEtoSE.m`: Function to map fault entity IDs to source energy categories
- `predictSP.m`: Core function for predicting source parameters using tectonic region, mechanism, and location
- `SPest_example.m`: Demonstrates usage of `predictSP` for a range of magnitudes and fixed coordinates to plot Leff vs Mw

**Usage note:**
- `predictSP` requires at minimum Mw, Lat, Lon.
- Optional parameters: `tectonics`, `fault mechanism`, `region`
  - If not specified:
    - `region` is inferred using `FEtoSE.m`
    - `tectonics` and `fault mechanism` are inferred from the nearest data in `Data2.mat`

**Outputs:**
- `SourceParam` includes:
  - `Leff`: Effective fault length, in km
  - `Weff`: Effective fault width, in km
  - `Aeff`: Effective fault area, in km²
  - `Avla`: Very large asperity area, in km²
  - `Ala`: Large asperity area, in km²
  - `Dmean`: Mean slip, in m
  - `Dmax`: Maximum slip, in m
  - `Dstd`: Standard deviation of the slip distribution, in m
- `SourceData` includes:
  - `Mw`, `Lat`, `Lon`, `Tectonics`, `FM`, `Region`
  - Used values or inferred defaults

### Chapter 8: A Physics-Informed GAN Model for Estimating the Stochastic Slip Distribution
This chapter includes code and models used for developing a Conditional Generative Adversarial Network (cGAN) to estimate stochastic fault slip distributions based on physics constraints.

**Folder contents:**
- `train.py`: GAN training script integrating physics-informed loss functions
- `generator.py`, `discriminator.py`: Model architecture definitions with symmetry enforcement
- `losses.py`: Custom loss functions including power-law decay, symmetry, and peak-smoothness balance
- `evaluate.py`: Scripts for radial and directional profile comparison between real and generated PSDs
- `GANtry49.ipynb`: Main Jupyter notebook for training and analysis
- `ModelDATAfinal.mat`: Dataset of real slip PSDs with corresponding conditional parameters (L, W, Dmean, Mw, Dep, Nx, Nz)

**To run training:**
```bash
python train.py
```
Or open `GANtry49.ipynb` in Jupyter to run all steps interactively.

**Outputs:**
- Best model checkpoint: `best_generator.keras`
- Visual and quantitative comparison of real vs generated PSDs
- Application-ready PSD generation conditioned on tectonic parameters

### Chapter 9: A 2D Investigation of Cracked Medium Effects on Physics-Based Simulations
This chapter includes representative SPECFEM2D simulations performed for investigating how the inclusion of cracked media (damage zones) impacts wave propagation behavior and simulation accuracy.

**Folder contents:**
- `SPECFEM2D_cracked_model/`: Contains sample input files:
  - `Par_file`: Simulation control file
  - `SOURCE`: Source definition
  - `STATIONS`: Station placement configuration
  - `interfaces.dat`: Fault zone/damage interface definition

**To run SPECFEM2D simulation:**
- Install [SPECFEM2D](https://github.com/geodynamics/specfem2d) following official guide
- Copy simulation files into SPECFEM2D `EXAMPLES/` directory
- Compile and run using:
```bash
./configure && make && cd EXAMPLES/your_example && ./run_this_example.sh
```

**Outputs:**
- Time snapshots of wave propagation
- Differences in waveform energy, travel time, and path scattering
- Insight into the physical role of fault zone damage in crustal wavefield modeling
