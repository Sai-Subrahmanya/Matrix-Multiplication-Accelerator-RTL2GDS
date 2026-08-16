# Technology Reference

This directory documents the technology files required by the Synopsys Design Compiler and IC Compiler II implementation flow.


## Expected Structure

```text
tech/
├── README.md
│
├── milkyway/
│   └── saed32nm_1p9m_mw.tf
│
├── star_rcxt/
│   ├── saed32nm_1p9m_Cmax.tluplus
│   ├── saed32nm_1p9m_Cmin.tluplus
│   └── saed32nm_tf_itf_tluplus.map
│
├── saed32nm_1p9m_gdsout_mw.map
└── saed32nm_rvt_oa.gds
```


## Technology Usage

The technology information is used for:

- Physical design initialization
- Floorplanning
- Placement
- Clock-tree synthesis
- Routing
- Parasitic estimation
- Physical implementation
- GDS generation


## Technology

```text
SAED32 32 nm
```


## Standard-Cell Variant

```text
SAED32 RVT
```


## Proprietary Files

The actual technology files are proprietary and are intentionally excluded from this repository.

Users reproducing the project must obtain legitimate access to the corresponding SAED32 technology environment.


## Important

All technology paths referenced by the ICC2 setup and TCL scripts are case-sensitive and must point to valid technology files.
