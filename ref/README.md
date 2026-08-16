# Reference Technology and Libraries

This directory documents the technology and standard-cell library files required by the Matrix Multiplication Accelerator RTL-to-GDS flow.


## Technology

The project uses:

```text
SAED32 32 nm
```

with the:

```text
SAED32 RVT
```

standard-cell library.


## Operating Condition

The primary operating condition used by the project is:

```text
Process:      TT
Voltage:      0.85 V
Temperature:  25 °C
```


## Directory Structure

```text
ref/
├── README.md
├── lib/
│   └── README.md
└── tech/
    └── README.md
```


## Proprietary Files

The SAED32 technology and library files are proprietary.

Therefore, the actual technology files are intentionally not included in this public repository.

The README files document the expected structure and purpose of the required reference files.


## Required Reference Categories

The RTL-to-GDS flow requires technology information for:

- Logic synthesis
- Standard-cell mapping
- Physical implementation
- Parasitic extraction
- Routing
- GDS generation


## Important

All paths referenced by the Design Compiler and ICC2 TCL scripts are case-sensitive.

Users reproducing the flow must provide legitimate access to the corresponding SAED32 technology files.
