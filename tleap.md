
# 🧬 AMBER TLeap Input Script – Full Explanation

This page provides a detailed explanation of each line in a typical `tleap.in` file used for preparing molecular systems for AMBER simulations. The purpose is to help new users understand **what each line does**, **why it's needed**, and **what alternatives exist**.

---

## 📌 What is the purpose of the `tleap.in` file?

This script prepares your molecular system for MD simulation by:

- ✅ Loading the correct force fields  
- ✅ Applying custom ligand parameters  
- ✅ Adding missing atoms and hydrogens  
- ✅ Defining special bonds (like disulfide bridges)  
- ✅ Neutralizing the charge of your system  
- ✅ Solvating it in water  
- ✅ Outputting the two essential AMBER files: `prmtop` and `inpcrd`

---

## 🧪 Sample Input: `tleap.in`

```bash
source leaprc.protein.ff19SB
source leaprc.gaff2
source leaprc.lipid21
source leaprc.water.tip3p
loadamberparams frcmod.ionsjc_tip3p
loadamberprep PIP.prepi
loadamberparams PIP.frcmod

abc = loadpdb protein1.pdb
savepdb abc first_with_hydrogens.pdb
mol = loadpdb first_with_hydrogens.pdb

bond mol.80.SG mol.112.SG
bond mol.405.SG mol.437.SG
bond mol.730.SG mol.762.SG
bond mol.1055.SG mol.1087.SG

addions mol K+ 0
addions mol Cl- 0

solvatebox mol TIP3PBOX 0.1

savepdb mol with_water.pdb
saveamberparm mol com.prmtop com.inpcrd

quit
```

---

## 🔍 Line-by-Line Explanation

### 🔷 Force Field and Parameter Loading

#### ✅ `source leaprc.protein.ff19SB`
Loads the ff19SB force field for proteins.
- Defines amino acid charges, bonds, angles.
- Alternatives: `ff14SB`, `fb15`.

#### ✅ `source leaprc.gaff2`
Loads GAFF2 for small molecules like ligands.
- Needed if you have drug-like compounds.
- Alternatives: `gaff`, `openff`.

#### ✅ `source leaprc.lipid21`
Loads lipid parameters for membranes.
- Needed only for membrane systems.
- Alternatives: `lipid17`, `lipid14`.

#### ✅ `source leaprc.water.tip3p`
Loads the TIP3P water model.
- Used to solvate the system.
- Alternatives: `tip4p-ew`, `tip5p`.

#### ✅ `loadamberparams frcmod.ionsjc_tip3p`
Loads refined ion parameters for TIP3P water.
- Prevents unrealistic ion behavior.
- Alternatives: `ions94` (less accurate).

#### ✅ `loadamberprep PIP.prepi`
Loads ligand structure and charges.
- Required for nonstandard molecules.
- Alternatives: `mol2` or `.off` formats.

#### ✅ `loadamberparams PIP.frcmod`
Adds missing ligand parameters.
- Required if `parmchk2` generated it.

---

### 🔷 Structure Loading and Preparation

#### ✅ `abc = loadpdb protein1.pdb`
Loads the protein PDB file.
- Missing hydrogens will be added based on force field.

#### ✅ `savepdb abc first_with_hydrogens.pdb`
Saves the updated structure with hydrogens.
- Useful for visualization or reloading.

#### ✅ `mol = loadpdb first_with_hydrogens.pdb`
Reloads the hydrogen-complete structure.
- Ensures future edits apply to the correct version.

---

### 🔷 Manual Bond Definitions

#### ✅ `bond mol.80.SG mol.112.SG` *(and others)*
Forms disulfide bridges between CYS residues.
- Prevents protein misfolding or instability.
- Needed if your PDB doesn’t define disulfide bonds.

---

### 🔷 Ion Addition

#### ✅ `addions mol K+ 0`  
#### ✅ `addions mol Cl- 0`
Adds K⁺ and Cl⁻ ions to neutralize the system.
- `0` lets tleap calculate how many are needed.
- Alternatives: specify exact numbers or use `addionsrand`.

---

### 🔷 Solvation

#### ✅ `solvatebox mol TIP3PBOX 0.1`
Surrounds the molecule with water (TIP3P).
- Adds a water box with 1 Å padding (usually `10.0` Å recommended).
- Alternatives: `solvateoct` for spherical solvation.

---

### 🔷 Saving Outputs

#### ✅ `savepdb mol with_water.pdb`
Saves the fully solvated structure to a PDB file.
- Useful for visual checks.

#### ✅ `saveamberparm mol com.prmtop com.inpcrd`
Creates the essential AMBER files:
- `com.prmtop`: force field/topology
- `com.inpcrd`: initial coordinates

---

### ✅ `quit`
Ends the tleap session.

---

## 🧾 Summary

| Command | Purpose |
|--------|---------|
| `source leaprc.*` | Loads force fields |
| `loadamberprep`, `loadamberparams` | Loads custom ligand info |
| `loadpdb`, `savepdb` | Load/save molecular structures |
| `bond` | Create disulfide bonds |
| `addions` | Neutralize or set ionic concentration |
| `solvatebox` | Add water |
| `saveamberparm` | Output AMBER simulation files |

---

⬅️ [Back to Homepage](./README.md)

