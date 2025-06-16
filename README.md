# Respiratory Mechanics Modeling

**Reference:**  
Li, Z., Pei, Y., Wang, Y., & Tian, Q. (2023).  
*An enhanced respiratory mechanics model based on double-exponential and fractional calculus.*  
Frontiers in Physiology, 14, 1273645.

---

## Original Breath Data

![Original Breath](https://github.com/ashhadulislam/PINNs2025/blob/main/docs/figs/OriginalBreaths.png)

---

## Equation

The classical linear single-compartment model is defined as:

$$
P_{aw}(t) = E \cdot V(t) + R \cdot V'(t) + P_0
$$

### Parameters to Estimate:
- **E**: Elastance  
- **R**: Resistance  
- **P₀**: Baseline Pressure  

---

## Fitting Parameters to Real Data

![Real vs Fitted Pressure](https://github.com/ashhadulislam/PINNs2025/blob/main/docs/figs/FittingParams.png)

### Fitted Parameters
- **E = 29.95**  
- **R = 10.27**  
- **P₀ = 3.17**

### Model Performance
- **Mean Squared Error (MSE)** = 0.4978  
- **R²** = 0.9686

---

## Simulated Data Generation

![Synthetic data](https://github.com/ashhadulislam/PINNs2025/blob/main/docs/figs/SimulatedBreaths.png)

Synthetic data was generated using the estimated parameters above.

---

## Parameter Estimation from Synthetic Data using PINNs

![PINN output vs synthetic data](https://github.com/ashhadulislam/PINNs2025/blob/main/docs/figs/EstimatedParamsonSimBreaths.png)

### Recovered Parameters via PINN
- **E = 21.00** (True: 29.95)  
- **R = 10.25** (True: 10.27)  
- **P₀ = 3.17** (True: 3.17)

---

## To Be Done: PINNs Research Extensions

### 1. Model Complexity Scaling
Evaluate PINN performance for more complex models:

- **Equation 23**:

  $$
  P(t) = E_f(V(t)) \cdot V(t) + R(h(V'(t))) \cdot V'(t) + P_0
  $$

- **Equation 33**:

  $$
  P(t) = EV(t) + RV'(t) + aD_t^\alpha V(t) + b e^{\beta V(t)} + P_0
  $$

---

### 2. Generalization Across Breaths

- Train PINNs on a subset (e.g., 3 of 10 synthetic breaths)  
- Test parameter recovery on unseen breaths with varying amplitudes/frequencies  
- Evaluate generalization error and parameter consistency

---

### 3. Noise Robustness Evaluation

- Add Gaussian noise to synthetic data  
- Measure degradation in RMSE and R² as noise increases