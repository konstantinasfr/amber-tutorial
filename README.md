# AMBER Membrane Protein MD Simulation Tutorial

This tutorial provides a complete workflow for building and simulating a membrane protein system in AMBER. Each section corresponds to a real preparation step, including system cleaning, protonation, membrane building, PIP₂ integration, tleap setup, and MD execution.

## Repository Files

All input and output files are provided in the repository folder:

```
md_simulation_files/
```

This means you can follow the workflow easily, compare your results to mine, and use the files as templates for your own systems.

---

## Tutorial Overview

This tutorial is organized into clear steps, matching the real workflow of preparing a membrane system for AMBER MD:

### Step 1 — System Preparation (Maestro)

Cleaning the Cryo-EM structure, fixing missing atoms, removing unwanted ligands, defining chains, and preparing a protein-only structure for protonation.

### Step 2 — Protonation and pKa Assignment (H++ Server)

Submitting the cleaned structure to H++ to assign protonation states.

### Step 3 — Membrane System Construction (CHARMM-GUI)

Building the lipid bilayer, placing PIP₂ molecules, defining the Z-axis orientation, adding ions and water, and generating the CHARMM-GUI system.

### Step 4 — Integrating Protein, Membrane, and PIP₂ (Maestro Assembly)

Aligning the CHARMM-GUI system to the protein, copying PIPs, fixing atom names, removing clashes, and exporting the final aligned PDB.

### Step 5 — Preparing the AMBER System (tleap)

Loading force fields, importing the aligned PDB, rebuilding disulfide bonds, loading custom PIP₂ parameters, defining the box, adding ions, and generating `com.prmtop` and `com.inpcrd`.

### Step 6 — Minimization, Heating, Equilibration & Production

Running the full AMBER pipeline:

- Minimization
- Heating (multi-stage)
- Equilibration (10 × hold steps)
- Production MD (5 × 100 ns blocks)
- Trajectory assembly

---

## Tutorial Sections

- **Step 1:** [System Preparation (Initial Structure Setup)](./system_prep.md)
- **Step 2:** [Protonation and pKa Assignment (H++ Server)](./h++.md)
- **Step 3:** [Membrane System Construction (CHARMM-GUI)](./charmm_gui.md)
- **Step 4:** [Integrating Protein, Membrane, and PIP₂ (System Assembly in Maestro)](./system_assembly.md)
- **Step 5:** [Preparing the AMBER System (tleap)](./tleap_amber.md)
- **Step 6:** [Energy Minimization, Heating, Equilibration, and Production MD](./min_heat_hold_prod.md)

---

## Getting Started

To begin the tutorial, start with [Step 1: System Preparation](./system_prep.md).

Each page contains detailed instructions, command examples, and explanations for every step of the workflow.
