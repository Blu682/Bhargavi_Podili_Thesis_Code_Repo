# Repository: Bhargavi_Podili Thesis_Code_Repo

## Structure
This repository contains the chapter-wise code used in the thesis. Each folder below corresponds to a chapter from the thesis.

```
Bhargavi_Podili_Thesis_Code_Repo/
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


### Chapter 2: Seismic Zone Map for India Based on Cluster Analysis of Uniform Hazard Response Spectra
This research work presented in this chapter is published and can be referenced at:

**"Seismic Zone Map for India Based on Cluster Analysis of Uniform Hazard Response Spectra"**  
Publication link: [View Publication](https://link.springer.com/article/10.1007/s00024-023-03329-4)




### Chapter 3: A Vertical-to-Horizontal Spectral Ratio Model for India
This research work presented in this chapter is published and can be referenced at:

**"A Vertical-to-Horizontal Spectral Ratio Model for India"**  
Publication link: [View Publication](https://www.sciencedirect.com/science/article/abs/pii/S0267726121004826)

**Folder contents:**
- `Model source data/`: Refer to Appendix tables A1, A2 and A3 of thesis
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
This research work presented in this chapter is published and can be referenced at:

**"Alternative Regional Ground Motion Models for Western Himalayas"**  
Publication link: [View Publication](https://www.sciencedirect.com/science/article/abs/pii/S0267726123000507)

**Folder contents:**
- `Model source data/`: Refer to Appendix tables A1, A2 and A3 of thesis
- `code/`: MATLAB scripts for regional horizontal ground motion prediction:
  - `BRnsc_2023.m`: NSC-HIM regional model
  - `BRhybrid_2022.m`: Hybrid model 

**Model Data:**
- `Models_SaH.xlsx` contains the functional forms, model coefficients and other quantitative metrics of the four GMMs derived for SaH.
- `Models_VbyH.xlsx` includes the corresponding V/H spectral ratio model coefficients.
**To run the models:**
```matlab
[T, Sa1] = BRnsc_2023(Mw, R, H, Sc);    % NSC-HIM model
[T, Sa2] = BRhybrid_2022(Mw, R, H, Sc); % Hybrid model
```
- Inputs:
  - `Mw`: Moment magnitude
  - `R`: Source-to-site distance (km)
  - `H`: Hypocentral depth (km)
  - `Sc`: Site class (0=rock, 1=firm, 2=soft)
- Outputs:
  - `T`: Periods (s)
  - `Sa`: Spectral acceleration (g)




### Chapter 5: Spectral Ground Motion Models for Himalayas using Transfer Learning Technique
This research work presented in this chapter is published and can be referenced at:

**"Spectral Ground Motion Models for Himalayas using Transfer Learning Technique"**  
Publication link: [View Publication](https://www.tandfonline.com/doi/abs/10.1080/13632469.2024.2353261)

**Folder contents:**
- `data/`: Network parameters stored internally
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
This chapter proposes a deep learning model for application in the EEWS, as discussed in:

**"A Deep Learning Prediction Model for On-Site Earthquake Early Warning System in India"**  
*Under review (Round 2), Journal of Seismology*

**Folder contents:**
- `deployment.py`: Python script for loading the trained EEW model and making real-time predictions from seismic input features
- `himalayan_eew_system.pkl`: Trained multi-output prediction model for on-site EEW application in Himalayan region

**To run a sample prediction:**
```python
python deployment.py
```
This executes a test input with 8 EEW features (`PGA`, `PGD`, `Fp`, `Tsig`, `Ia`, `CAV`, `vs30`, `dir`) corresponding to the 3s P-wave of the time history and returns the spectral accelratio of the entire ground motion time history.




### Chapter 7: Estimating Deterministic Seismic Source Parameters for Varied Tectonics, Fault Mechanisms and Regions
This chapter focuses on building a consistent parameter dataset for deterministic seismic source modeling across regions, based on tectonic regime, faulting mechanism, and observed seismicity.

**"Estimating Deterministic Seismic Source Parameters for Varied Tectonics, Fault Mechanisms and Regions"**  
*Under review, Geophysical Journal International*

**Folder contents:**
- `DataBase_Meta.xlsx`: Metadata for curated source parameter database corresponding to the FFMs of SRCMOD
- `Predictions/`: Contains model-generated data and MATLAB scripts used for estimating seismic regions (SE) and various source parameters
- `Data2.mat`, `ModelF.mat`, `Total274.mat`: MATLAB data files used to generate predictions and validate regression outputs

**Code files:**
- `FEtoSE.m`: Function to obtain the seismic region numbers
- `predictSP.m`: Core function for predicting source parameters using tectonic region, mechanism, location, magnitude and depth
- `SPest_example.m`: Demonstrates usage of `predictSP` for a range of magnitudes and coordinates
  
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
    



### Chapter 8: A Physics-Informed GAN Model for Estimating the Stochastic Slip Distribution
This chapter includes codes used for developing the cGAN model to estimate PSD of stochastic fault slip distributions, based on physics constraints.

**Folder contents:**
- `train.py`: GAN training script integrating physics-informed loss functions
- `generator.py`, `discriminator.py`: Model architecture definitions with origin symmetry enforcement
- `losses.py`: Custom loss functions including power-law decay, symmetry, and smoothness constraints
- `data_utils.py`, `fit_psd_utils.py`: Data loading, normalization, and PSD fitting utilities used throughout training pipeline
- `generator.keras`: Trained Generator Model

**To run the model:**
```python
import tensorflow as tf
generator = tf.keras.models.load_model('generator.keras', compile=False)
```
- Inputs:
  - `z`: Latent vector of shape `(1, 100)`
  - `cond`: Conditional vector of shape `(1, 10)` — includes parameters: L, W, Nx, Nz, Dmean, Mw, H, kcx, kcy, gamma
  - `kx`, `kz`: Wavenumber arrays reshaped to shape `(1, H*W)`
- Output:
  - A predicted PSD array (padded) of shape `(H, W, 1)`, with symmetry constraints enforced




### Chapter 9: A 2D Investigation of Cracked Medium Effects on Physics-Based Simulations
This chapter includes representative SPECFEM 2D simulations performed for investigating how the inclusion of cracked media (faults and fault zones) impacts wave propagation behavior and simulation accuracy.

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
