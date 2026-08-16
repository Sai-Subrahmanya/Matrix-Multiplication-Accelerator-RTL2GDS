# VCS — RTL Functional Verification

This directory contains the RTL source and SystemVerilog testbench used to verify the Matrix Multiplication Accelerator before synthesis.


## Contents

```text
vcs/
├── README.md
├── mma.v
└── tb_mma_compare.sv
```


## RTL Source

The main RTL design is:

```text
mma.v
```

The design implements the matrix multiplication accelerator.

The main interface includes:

- `Clock`
- `Reset`
- `Start`
- `MatrixA`
- `MatrixB`
- `MatrixC`
- `Done`


## Testbench

The SystemVerilog testbench is:

```text
tb_mma_compare.sv
```

The testbench:

1. Generates the clock.
2. Applies reset.
3. Provides matrix input data.
4. Starts the matrix multiplication operation.
5. Waits for completion.
6. Compares the DUT result against the expected result.
7. Reports verification status.


## VCS Compilation

From this directory:

```bash
vcs -full64 -sverilog -debug_all mma.v tb_mma_compare.sv -l compile_rtl.log
```


## Simulation

Run:

```bash
./simv -l sim_rtl.log
```


## DVE

The VPD waveform can be opened using:

```bash
dve -full64 -vpd mma_compare.vpd &
```


## Waveform Signals

The main signals inspected during waveform analysis include:

- `Clock`
- `Reset`
- `Start`
- `MatrixA`
- `MatrixB`
- `MatrixC`
- `Done`

The waveform provides visual confirmation of the matrix inputs, operation control, result generation, and completion indication.


## Verification Scope

The RTL verification is performed before synthesis.

The verification environment is intended to establish functional correctness of the RTL matrix multiplication implementation before the design proceeds to Design Compiler synthesis and IC Compiler II physical implementation.
