
## 🧪 My Example: Preparing the GIRK2 Channel (3SYC)

To test this workflow, I used the structure [**3SYC**](https://www.rcsb.org/structure/3SYC), which is the **crystal structure of the G protein-gated inward rectifier K⁺ channel GIRK2 (Kir3.2), D228N mutant**. The structure contains **only the protein** (no ligands), and I wanted to simulate it using AMBER.

At first, I thought I could follow the one-file `tleap.in` approach shown above, but I quickly discovered that it wouldn’t work for this system. Here's why:

---

## ❌ Why a Single `tleap.in` File Wasn't Enough

### 1. 🔍 The PDB Includes a Disulfide Bond That TLeap Won’t Handle Automatically

In the original PDB file, there is a clear disulfide bond listed:

```
SSBOND   1 CYS A  134    CYS A  166                          1555   1555  2.04
```

You might think that this means you can write in `tleap.in`:

```bash
bond mol.134.SG mol.166.SG
```

But **this won’t work** — and here’s why:

---

### 2. 🧬 The Atom Indexing Changes After Adding Hydrogens

In the original PDB, the residue numbering begins at residue **55**:

```
ATOM      1  N   ILE A  55      ...
```

But when you load this into TLeap and save a new PDB (e.g., `first_with_hydrogens.pdb`), the residues get **renumbered starting at 1**. So:

- Original residue **CYS 134** might become **residue 80**
- Original **CYS 166** might become **residue 112**, for example

This means the line `bond mol.134.SG mol.166.SG` will fail, because those residue numbers **no longer exist** in the modified file.

---

### 3. 🧪 The CYS Residues Must Be Renamed to CYX

Even if you get the new residue numbers right, you’ll hit another problem:

- **TLeap expects disulfide-forming cysteines to be named `CYX`**, not `CYS`
- If you leave them as `CYS`, the bond may not be recognized and will generate errors during parameter assignment

---

### 4. 🧼 The HG Hydrogen Must Be Deleted

One last critical detail:  
Each cysteine residue normally contains a **hydrogen atom named HG** attached to the sulfur (SG). But when forming a disulfide bond:

- **That hydrogen must be removed manually**, or TLeap will complain about missing torsion parameters involving HG
- You’ll get an error like `no torsion terms for atom types HS-SH-SH-HS`

---

## ✅ My Solution: Modular Automation

To fix all of this, I created a modular, automated workflow that:

1. Uses a first `tleap` script to **add missing hydrogens**
2. Uses a Python script to:
   - Parse the original residue numbers
   - Create a `tleap.in` file with the **correct mapped numbers**
   - Generate a `rename_cys_to_cyx.sh` script to:
     - Rename `CYS → CYX`
     - Delete the HG hydrogen from each CYX
3. Runs everything step-by-step inside a clean output folder

---

## 📥 Want to Try It Yourself?

If you want to reproduce this with 3SYC:

### 🔧 Step 1: Download the PDB file
Go to [3SYC](https://www.rcsb.org/structure/3SYC), download it, and save it as:

```
3syc.pdb
```

### 🧪 Step 2: Run the full preparation script

```bash
bash run_full_preparation.sh 3syc.pdb
```

This will:
- Add hydrogens
- Fix the CYS → CYX renaming and HG deletion
- Add ions and water
- Generate all required AMBER input files (`.prmtop`, `.inpcrd`, solvated PDB)

All output files will be stored in the folder `3syc/`.

---

⬅️ [Back to Homepage](./README.md)

⬅️ [Back to Homepage](./tleap.md)
