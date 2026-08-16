# Design Compiler — Logic Synthesis

This directory contains the Synopsys Design Compiler files used to synthesize the Matrix Multiplication Accelerator RTL into a technology-mapped gate-level implementation.


## Directory Structure

```text
dc/
├── README.md
├── source/
├── scripts/
├── reports/
├── results/
└── work/
```


## Source

The `source/` directory contains the RTL, constraint, and setup-related files required for synthesis.

The source files provide the RTL design and timing constraints used by Design Compiler.


## Scripts

The `scripts/` directory contains the Design Compiler TCL scripts used to perform:

- Library setup
- RTL reading
- Design elaboration
- Constraint application
- Compilation
- Optimization
- Report generation
- Result generation


## Synthesis Flow

The Design Compiler flow consists of:

```text
RTL
 │
 ▼
Library Setup
 │
 ▼
Read / Elaborate
 │
 ▼
Apply Constraints
 │
 ▼
Compile / Optimize
 │
 ▼
Timing / Area / Power Analysis
 │
 ▼
Report Generation
 │
 ▼
Synthesized Netlist
```


## Launching Design Compiler

Start Design Compiler:

```bash
dc_shell -gui
```

From the DC working directory, source the project synthesis script:

```tcl
source ../scripts/<synthesis_script>.tcl
```


## Reports

Generated reports are stored under:

```text
reports/
```

The reports include analysis such as:

- Area
- Power
- Timing
- Constraints
- QoR


## Results

Generated synthesis outputs are stored under:

```text
results/
```

These results are subsequently used as input to the ICC2 physical-design flow.


## Technology

The synthesis flow uses:

```text
Technology:  SAED32 32 nm
Library:     SAED32 RVT
Process:     TT
Voltage:     0.85 V
Temperature: 25 °C
```


## Notes

The SAED32 technology libraries are proprietary and are not included in this repository.

The required library paths must be configured according to the user's legitimate SAED32 technology installation.
