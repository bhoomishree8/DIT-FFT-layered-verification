# DIT-FFT-LAYERED-VERIFICATION

A SystemVerilog-based functional and formal verification project for a **4-point Decimation-In-Time (DIT) FFT** module using a layered testbench architecture (UVM-inspired).

##  Design Overview

The Design Under Test (DUT) is a **4-point Decimation-In-Time (DIT) FFT module**, implemented using two sequential butterfly stages. Each butterfly performs:

- **Complex additions and multiplications**
- Operates on 16-bit fixed-point values.
- Uses fixed twiddle factors for 4-point FFT.
- Designed for basic frequency-domain transformation, implements radix-2 DIT flow.

---

## Verification Architecture

A **layered testbench** is used to simulate UVM-style verification while maintaining simplicity:

###  Testbench Components

- **Interface (`FFT4If`)**  
  Defines all input/output signals and clock/reset lines for the DUT.
- **Driver (`FFT4Driver`)**  
 Applies input vectors to the DUT at each positive clock edge.
- **Monitor (`FFT4Monitor`)**  
  Observes the DUT output signals and raises events for scoreboard checks.
- **Scoreboard (`FFT4Scoreboard`)**  
  Compares actual DUT outputs against expected results.
- **Environment (`FFT4Env`)**  
  Instantiates and connects all sub-components (driver, monitor, scoreboard).
- **Test  (`FFT4Test`)**  
  Defines and configures test cases to trigger different behaviors.
- **Top Module (`top`)**  
  Instantiates the DUT, testbench environment, and interface connections.

---

##  Assertions & Coverage Strategy

- **Assertions**  
  Ensure output values stay within the valid 16-bit signed range. Trigger errors for overflows or invalid transitions.

- **Functional Coverage**  
  -  Covers scenarios where all inputs are zero.
  -   Uses `cover` statements to track rare edge cases

- **Assumptions**  
  Applied to control signals to guarantee correct operation:
  - Clock toggling
  - Input validity conditions

---
##  Project Contents
- **`src/`**  
  Contains the design files:
  - `butterfly.sv`: Implements a butterfly computation unit for FFT
  - `fft4.sv`: Top-level 4-point FFT module using two butterfly stages
- **`testbench/`**  
  Contains the full layered testbench:
  - `testbench.sv`: Includes interface, driver, monitor, scoreboard, environment, test class, and top module (all integrated into a single file)
- **`results/`**  
  Contains verification results:
  - `simulation_waveform.png`: Snapshot of simulation waveform
  - `module_coverage.png`: Screenshot of functional coverage report
  - `schematic.png`: Gate-level schematic diagram of the FFT module

## Design Schematic

![Schematic](results/schematic.png)

###  FFT 4-Point Simulation Result

| Metric          | Value                          |
|-----------------|--------------------------------|
| Inputs          | {1, 2, 3, 4} (Real, Imag = 0)  |
|  Output         | {10, -2 + 2j, -2, -2 - 2j}     |

## Conclusion

- The 4-point DIT-FFT module was successfully **verified using a layered SystemVerilog testbench** inspired by UVM methodology.
- The DUT passed all test cases with correct output results, validated through a scoreboard mechanism.
- Functional coverage and assertions ensured thorough validation of input-output behavior and signal constraints.
- The verification environment is modular and can be easily extended to support larger FFT sizes (like for 8-point, 16-point).









