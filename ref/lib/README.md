# Standard-Cell Library Reference

This directory documents the standard-cell library information required by the Matrix Multiplication Accelerator RTL-to-GDS flow.


## Library

The project uses:

```text
SAED32 RVT
```


## Expected Library Structure

```text
lib/
├── README.md
├── ndm/
│   └── saed32_rvt.ndm/
│
└── stdcell_rvt/
    ├── saed32rvt_tt0p85v25c.db
    └── saed32rvt_tt0p85v25c.lib
```


## Library Usage

The standard-cell library is used during:

- Logic synthesis
- Technology mapping
- Timing analysis
- Power analysis
- Physical implementation
- Cell placement
- Clock-tree synthesis
- Routing


## Proprietary Files

The actual SAED32 RVT library files are proprietary and are not included in this repository.

The documented directory structure is provided only to show the expected reference environment required by the synthesis and physical-design scripts.


## Operating Condition

```text
Process:      TT
Voltage:      0.85 V
Temperature:  25 °C
```


## Note

The actual filenames and paths used by the project scripts must match the corresponding legitimate SAED32 installation.
