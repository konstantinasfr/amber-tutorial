
# 🧬 AMBER Molecular Dynamics Tutorial

Welcome to the AMBER Molecular Dynamics Tutorial site!  
This guide walks you step-by-step through preparing a biomolecular system for simulation using AMBER tools, from initial system setup to post-simulation analysis.

---

## 📚 Tutorial Sections
- Step 1: System Preparation (Initial Structure Setup)
- Step 2: Protonation and pKa Assignment (H++ Server)
- Step 3: Membrane System Construction (CHARMM-GUI)
- Step 4: Integrating Protein, Membrane, and PIP₂ (System Assembly in Maestro)
- Step 5: Preparing the AMBER System (tleap)
- Step 6: Energy Minimization, Heating, Equilibration, and Production MD
- 
- 🧪 [System Setup with TLeap](./tleap.md)  
  Learn how to load force fields, define ligands, add disulfide bonds, solvate your system, and generate AMBER input files.  
  &nbsp;&nbsp;&nbsp;&nbsp;🧬 [GIRK2 Channel Example (6XIS)](./girk2_6xis_example.md) — Real-case application with disulfide bond renumbering and CYX conversion.

- ⚙️ [Energy Minimization](./minimization.md) *(coming soon)*  
  Relax your system and remove any bad contacts after initial setup.

- 🔥 [Heating](./heating.md) *(coming soon)*  
  Slowly bring the system to simulation temperature (e.g., 300 K).

- 🌊 [Equilibration](./equilibration.md) *(coming soon)*  
  Stabilize pressure and density while holding restraints on the structure.

- 🎯 [Production Run](./production.md) *(coming soon)*  
  Run long MD simulations to generate meaningful trajectories.

- 📊 [Trajectory Analysis](./analysis.md) *(coming soon)*  
  Learn how to process and analyze MD results (e.g., RMSD, distances, clustering).

---

Feel free to explore each page and reach out if you'd like to contribute or suggest improvements!

