# 4-Bit Sequential Binary Multiplier

## Overview

This project implements a **4-bit sequential binary multiplier in VHDL** using a system-controller architecture. The circuit accepts a 4-bit multiplicand and a 4-bit multiplier and produces an 8-bit product.

The multiplication process is controlled by `Start` and `Done` signals and uses a shift-and-add algorithm similar to binary long multiplication.

## Architecture

The design is composed of several reusable VHDL modules:

- **Controller** — Moore-style finite state machine that sequences the multiplication operation
- **CounterN** — counts completed shift cycles and signals when all multiplier bits have been processed
- **AdderN** — parameterized binary adder
- **RegN** — parameterized shift register
- **MULTTOP** — top-level module that connects the controller, counter, adder, and registers
- **mult_tb** — testbench used to verify the multiplier over multiple input combinations

## Controller FSM

The controller uses five states:

1. `InitS` — waits for `Start`
2. `LoadS` — loads the multiplicand and multiplier registers
3. `AddS` — adds the multiplicand to the accumulator when the current multiplier bit is `1`
4. `ShiftS` — shifts the accumulator and multiplier and advances the counter
5. `DoneS` — indicates completion and waits for `Start` to return low

The controller updates on the **falling edge of the clock**, while the datapath registers and counter update on the **rising edge**. This allows control outputs to become valid before the datapath executes the corresponding operation.

## Multiplication Process

The circuit processes the multiplier from the least significant bit toward the most significant bit.

For each multiplier bit:

- If the current bit is `1`, the multiplicand is added to the accumulator.
- If the current bit is `0`, the addition step is skipped.
- The accumulator and multiplier are shifted right.
- The counter records the completed shift cycle.

After four multiplier bits have been processed, the controller enters `DoneS` and the 8-bit result is available on `Product`.

## My Contributions

This repository is based on an ECE 3561 course project that included a provided architecture and starter VHDL files.

My implementation work included:

- Implementing the system-controller finite state machine in `Controller.vhd`
- Extracting the counter logic from the original controller into a separate reusable `CounterN.vhd` module
- Instantiating and connecting `CounterN` in the top-level multiplier design
- Integrating the controller and datapath components
- Simulating the completed design and checking multiplication results using waveform analysis and the provided testbench

`AdderN.vhd`, `RegN.vhd`, and the original testbench were supplied as part of the course project and are included here for completeness.

## Verification

The supplied testbench cycles through combinations of 4-bit multiplier and multiplicand values and checks the computed product against the expected multiplication result.

The completed simulation was also inspected using waveform analysis to verify the behavior of:

- `Multiplier`
- `Multiplicand`
- `Product`
- `Start`
- `Done`
- `Clk`

## Tools and Technologies

- VHDL
- Xilinx ISE / Project Navigator
- ISim waveform simulation
- Digital logic design
- Finite state machines
- Sequential circuits
- Shift-and-add arithmetic

## Repository Structure

```text
4-bit-sequential-binary-multiplier/
├── README.md
├── src/
│   ├── multiplier.vhd
│   ├── Controller.vhd
│   ├── CounterN.vhd
│   ├── AdderN.vhd
│   └── RegN.vhd
├── testbench/
│   └── mult_tb.vhd
└── docs/
    └── Project-3-Report.pdf
```

## Academic Context

Completed as part of **ECE 3561** coursework. This repository is intended to document the design, implementation, and verification work for portfolio and educational purposes.
