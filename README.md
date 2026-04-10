# Lehmann-Unbiasedness and Cramér-Rao-Type Bounds — Simulation Code

This repository contains the MATLAB simulation code accompanying the Lecture Notes article:

> T. Routtenberg and J. Tabrikian, "Lehmann-Unbiasedness and Cramér-Rao-Type 
> Bounds for Different Loss Functions," Submitted, 2026.

---

## Contents

| File | Description |
|---|---|
| `cyclic_crb_phase_estimation.m` | Phase estimation under cyclic loss: ML estimator, cyclic CRB, and classical CRB |
| `lu_ccrb_norm_constraint.m` | Constrained estimation under norm constraint: CML estimator, LU-CCRB, and CCRB |

---

## Simulations

### 1. Cyclic CRB — Phase Estimation (`cyclic_crb_phase_estimation.m`)

Reproduces the simulation results of Section VI in the paper.

**Model:**

$$x[n] = A e^{j(n\omega_0 + \theta)} + w[n], \quad n = 0, \ldots, N-1$$

where $w[n]$ is circularly symmetric complex Gaussian noise with variance $\sigma^2$.

**Settings:** $N=5$, $A=1$, $\omega_0 = 0.2\pi$, SNR $\in [-30, 10]$ dB, 
10,000 Monte Carlo trials.

**Outputs (two-panel figure):**
- *Top:* Mean bias and cyclic bias of the ML estimator vs. SNR
- *Bottom:* MCE and MSE of the ML estimator vs. SNR, compared to the 
  cyclic CRB and the classical CRB

**Key result:** The ML estimator is cyclic-unbiased (cyclic bias = 0) but 
not mean-unbiased. At low SNR, the MSE drops below the classical CRB, 
confirming it is not a valid bound in this regime, while the cyclic CRB 
remains valid across all SNR levels.

---

### 2. LU-CCRB — Linear Model with Norm Constraint (`lu_ccrb_norm_constraint.m`)

Reproduces the simulation results of Section VII in the paper, based on:

> E. Nitzan, T. Routtenberg, and J. Tabrikian, "Cramér–Rao Bound for 
> Constrained Parameter Estimation Using Lehmann-Unbiasedness," 
> *IEEE Transactions on Signal Processing*, vol. 67, no. 3, pp. 753–768, 2019.

**Model:**

$$\mathbf{x} = \boldsymbol{\theta} + \mathbf{n}, \quad 
\mathbf{n} \sim \mathcal{N}(\mathbf{0}, \sigma^2 \mathbf{I}_M)$$

subject to the norm constraint $\|\boldsymbol{\theta}\|^2 = \rho^2$.

**Settings:** $M=3$, $\sigma^2=16$, $\rho \in [10^{-1}, 10^{2}]$, 
100,000 Monte Carlo trials.

**CML estimator:** $\hat{\boldsymbol{\theta}}_{\mathrm{CML}} = 
\rho \cdot \mathbf{x} / \|\mathbf{x}\|$

**Outputs (two-panel figure):**
- *Top:* Mean bias norm and C-bias norm of the CML estimator vs. $\rho$
- *Bottom:* MSE trace of the CML estimator vs. $\rho$, compared to the 
  LU-CCRB and Tr(CCRB)

**Key result:** The CML estimator is C-unbiased (C-bias = 0) but not 
mean-unbiased. The classical CCRB is not a valid lower bound for any $\rho$, 
while the LU-CCRB is valid for all $\rho$ and converges to the CCRB 
asymptotically.

---

## Requirements

- MATLAB R2019b or later (for `yline` and `fill` with log-scale support)
- No additional toolboxes required

---

## Reproducing the Figures

Simply run each script independently:

```matlab
>> cyclic_crb_phase_estimation   % reproduces Fig. 3 of the paper
>> lu_ccrb_norm_constraint        % reproduces Fig. 4 of the paper
```

Each script is self-contained and generates the corresponding figure directly.

---

## Citation

If you use this code, please cite:

```bibtex
@article{Routtenberg2025LehmannLN,
  author    = {T. Routtenberg and J. Tabrikian},
  title     = {Lehmann-Unbiasedness and {Cram\'{e}r--Rao}-Type Bounds for Different Loss Functions},
  year      = {2026}
}

@article{Nitzan2019LUCCRB,
  author  = {E. Nitzan and T. Routtenberg and J. Tabrikian},
  title   = {{Cram\'{e}r--Rao} Bound for Constrained Parameter Estimation 
             Using {Lehmann}-Unbiasedness},
  journal = {IEEE Transactions on Signal Processing},
  volume  = {67},
  number  = {3},
  pages   = {753--768},
  year    = {2019}
}
```

---

## Contact

- Tirza Routtenberg — tirzar@bgu.ac.il  
- Joseph Tabrikian — joseph@bgu.ac.il  
- School of Electrical and Computer Engineering, Ben-Gurion University 
  of the Negev, Israel
