# DSP Study with MATLAB

A collection of small MATLAB experiments for studying digital signal processing. Each experiment connects a mathematical model with code and plots.

The repository currently contains one experiment: the frequency response and sinusoidal input response of a second-order IIR filter.

## Files

| File | Purpose |
| --- | --- |
| [DSP_IIR_01_Frequency Response of the IIR Filter.m](DSP_IIR_01_Frequency%20Response%20of%20the%20IIR%20Filter.m) | MATLAB script that calculates the frequency response and plots two time-domain outputs. |
| [DSP_IIR_01_Frequency Response of the IIR Filter.png](DSP_IIR_01_Frequency%20Response%20of%20the%20IIR%20Filter.png) | Exported figure for viewing directly on GitHub. |
| [DSP_IIR_01_Frequency Response of the IIR Filter.fig](DSP_IIR_01_Frequency%20Response%20of%20the%20IIR%20Filter.fig) | Saved MATLAB figure for inspecting the plotted data interactively. |

## Experiment 01: IIR Filter Frequency Response

### Purpose

Compare the filter's frequency response with its response to two unit-amplitude cosine inputs:

- $\omega = 0.41$ rad/sample, near the filter's resonance.
- $\omega = \pi$ rad/sample, where the filter has a zero.

Here, $n$ is the integer sample index, $\omega$ is angular frequency in radians per sample, and $j=\sqrt{-1}$. The script does not specify a sampling rate, so frequencies are not expressed in Hz.

### Filter model

The transfer function implemented in the script is

$$
H(z)=\frac{0.1+0.2z^{-1}+0.1z^{-2}}{1-1.757z^{-1}+0.921z^{-2}}.
$$

Its difference equation is

$$
y[n]=1.757y[n-1]-0.921y[n-2]+0.1x[n]+0.2x[n-1]+0.1x[n-2].
$$

The corresponding MATLAB coefficient vectors are

```matlab
b = [0.1, 0.2, 0.1];
a = [1, -1.757, 0.921];
y = filter(b, a, x);
```

**Sign convention:** the script defines `a1 = 1.757` and `a2 = -0.921`, then constructs `a = [1, -a1, -a2]`. The denominator coefficients passed to `filter` therefore differ in sign from the feedback coefficients in the difference equation.

### Procedure

1. Evaluate $H(e^{j\omega})$ directly using complex exponentials on the grid `w = 0:0.01:2*pi`.
2. Plot its linear magnitude, $|H(e^{j\omega})|$.
3. Generate `x = cos(0.41*n)` for `n = 0:100` and filter it.
4. Repeat with `x = cos(pi*n)` and plot the second output.

Both calls to `filter` start with zero initial delay states. Each time-domain plot contains 101 samples. The frequency grid contains 629 points and ends at 6.28 rad/sample; the axis extends to $2\pi$, but the grid does not include that endpoint or exact $\pi$.

### Figure and observations

![IIR filter magnitude response and outputs for cosine inputs at 0.41 and pi radians per sample](DSP_IIR_01_Frequency%20Response%20of%20the%20IIR%20Filter.png)

| Panel | What it shows | Interpretation |
| --- | --- | --- |
| Top | Magnitude response over approximately $0$ to $2\pi$. | Strong amplification near 0.41 rad/sample and a deep null near $\pi$. The second resonance near $2\pi-0.41$ is the mirrored response of the same real-coefficient filter. |
| Middle | Output for $x[n]=\cos(0.41n)$. | The oscillation builds up toward an amplified sinusoidal steady state. The plotted sequence includes the startup transient. |
| Bottom | Output for $x[n]=\cos(\pi n)=(-1)^n$. | An initial oscillation decays toward zero. A zero steady-state gain does not imply zero output at every sample after startup. |

Values checked against the script and saved figure:

| Quantity | Approximate value | Meaning |
| --- | --- | --- |
| $|H(e^{j0.41})|$ | 12.0376 | Predicted steady-state amplitude for a unit-amplitude cosine at 0.41 rad/sample. |
| $y[50]$ for $\omega=0.41$ | 10.3786 | One output sample during the finite simulation. |
| $y[95]$ for $\omega=0.41$ | 11.6398 | Another output sample; individual sample values are not the frequency-response gain. |
| $|H(e^{j3.14})|$ | $6.89654\times10^{-8}$ | The near-zero value marked in the top panel at a sampled frequency close to $\pi$. |
| $H(e^{j\pi})$ | 0, analytically | The exact response at $\pi$, which is used for the second cosine input. |

### Mathematical insights

**Frequency response predicts steady state.** For a stable filter driven by a cosine, the output approaches

$$
y_{\mathrm{ss}}[n]=|H(e^{j\omega})|\cos\bigl(\omega n+\arg H(e^{j\omega})\bigr).
$$

The response includes both gain and phase shift. This script plots only the frequency-response magnitude, and the finite output records also contain transients.

**A double zero explains the rejection at $\pi$.** The numerator factors as $0.1(1+z^{-1})^2$, giving a double zero at $z=-1=e^{j\pi}$. For the alternating input, the feedforward terms cancel once all three input samples are available. The response excited during startup remains temporarily because of feedback, then decays.

**Stable poles explain the resonance and decay.** The poles, calculated from $z^2-1.757z+0.921=0$, are approximately

$$
p_{1,2}=0.8785\pm j\,0.386313,\qquad |p_{1,2}|\approx0.959687<1.
$$

Both poles lie inside the unit circle, so the causal filter is stable. Their proximity to the unit circle produces a pronounced resonance and a slowly decaying oscillatory transient, with an envelope proportional to approximately $0.959687^n$.

## Setup and Run

### Requirements

- MATLAB R2018b or newer: the script uses [`sgtitle`](https://www.mathworks.com/help/matlab/ref/sgtitle.html), introduced in R2018b.
- Only base MATLAB functions are used; no additional toolbox or external dataset is required.
- Execution and saved-figure data were checked using MATLAB R2026b Update 1. Earlier releases were not tested.

### Run the experiment

1. Download or clone the repository.
2. Open MATLAB and set **Current Folder** to the repository folder.
3. Execute the following in the Command Window:

```matlab
scriptFile = 'DSP_IIR_01_Frequency Response of the IIR Filter.m';
figure;
eval(fileread(scriptFile));
```

The existing script filename contains spaces. The commands above execute its contents without renaming it; calling `run` on the current filename failed in the checked MATLAB version. If you rename the file to a valid MATLAB script name, such as `dsp_iir_01_frequency_response.m`, you can use the Editor's **Run** button or `run('dsp_iir_01_frequency_response.m')` instead.

One figure with three vertically stacked plots should appear. The script displays the plots but does not save files automatically. Data tips and figure dimensions in the supplied PNG reflect the saved figure and are not recreated by the script.

To inspect the existing MATLAB figure:

```matlab
openfig('DSP_IIR_01_Frequency Response of the IIR Filter.fig');
```

To save a newly generated figure, run these commands while that figure is current:

```matlab
savefig(gcf, 'DSP_IIR_01_response_rerun.fig');
print(gcf, 'DSP_IIR_01_response_rerun.png', '-dpng', '-r150');
```

## Possible Organization as the Repository Grows

The current flat layout is sufficient for one experiment. For additional experiments, a possible structure is:

```text
study-dsp/
|-- README.md
`-- experiments/
    `-- 01-iir-frequency-response/
        |-- dsp_iir_01_frequency_response.m
        `-- figures/
            |-- iir_frequency_response.png
            `-- iir_frequency_response.fig
```

This is a suggested future layout. The files currently remain at the repository root. If files are moved or renamed, update the image links and run instructions accordingly.

## MATLAB References

- [`filter`: coefficient conventions and zero initial states](https://www.mathworks.com/help/matlab/ref/filter.html)
- [`sgtitle`: title above a grid of plots](https://www.mathworks.com/help/matlab/ref/sgtitle.html)
