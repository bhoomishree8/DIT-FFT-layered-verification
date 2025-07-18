Design Overview

The DUT is a 4-point FFT module using butterfly units, designed for frequency domain transformation. The FFT is implemented in two stages, with each butterfly performing complex additions and multiplications.

Verification Approach

A layered testbench architecture is used (UVM-inspired):

- Interface (`FFT4If`): Connects DUT with testbench
- Driver (`FFT4Driver`): Sends input values to DUT
- Monitor (`FFT4Monitor`): Observes DUT outputs
- Scoreboard (`FFT4Scoreboard`): Compares outputs with expected values
- Environment (`FFT4Env`): Manages components
- Test (`FFT4Test`): Defines testcases
- Top Module (`top`): Instantiates DUT, interface, and test class

Assertions & Coverage

- Assertions- ensure output values remain in valid 16-bit range
- Coverage- includes cases like all-zero inputs
- Assumptions- are added for toggling clocks and valid inputs
