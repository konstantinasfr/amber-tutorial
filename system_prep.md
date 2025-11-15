# System Preparation (Initial Structure Setup)

This section describes the full procedure for preparing the initial structure before protonation, membrane embedding, and AMBER parameterization. The goal is to start from the Cryo-EM structure, clean it, fix missing regions, and replace incomplete PIP₂ headgroups with full-length molecules.

---

## 1A. Obtain the Structure

Begin by downloading the appropriate Cryo-EM structure (PDB file) of your protein.  
Load the downloaded PDB into Maestro or your preferred molecular editing tool.

---

## 1B. Clean the Structure

Once the structure is loaded, perform the following checks and edits.

---

### **1. Decide Whether to Keep the Waters**

Cryo-EM models often include water molecules.  
Water does not interfere with the cleanup process, so it can be kept.

You can view or remove waters in Maestro under:

**Solvents → Waters → HOH**

Water will be re-added later in AMBER anyway.

---

### **2. Decide Which Ions to Keep**

Cryo-EM structures frequently contain ions (K⁺, Na⁺, Mg²⁺).  
For potassium channels, keep **only K⁺ ions** near the pore.

In Maestro:

- Open **Metals / Ions**
- Keep K⁺ ions (e.g., K1, K2, K3)
- Delete Na⁺, Mg²⁺, and all others unless required

---

### **3. Decide Whether to Keep Ligands**

Ligands include small molecules, PIP headgroups, cholesterol, detergents, or co-crystallized inhibitors.  
H++ can only process proteins, so **all ligands must be removed** now.

Scenarios:

1. No ligand → nothing to do  
2. Ligand will be used → delete now, add later  
3. Different ligand will be used → delete existing, add new one later

PIP₂ and cholesterol are listed under **Ligands**.  
For GIRK channels:

- Delete cholesterol  
- Keep PIP headgroups temporarily

---

### **4. Check for Mutations**

PDB structures often include mutations.  
If you do not want these:

1. Open **Mutate Residues**  
2. Select chain + residue  
3. Choose the correct wild-type residue  
4. Select a rotamer  
5. Apply

Example: revert **141.D → Gln**.

---

### **5. Spot and Fix Missing Loops**

Cryo-EM structures commonly lack flexible loops.

To rebuild loops:

1. Open **Protein Preparation Wizard**  
2. Select **Preprocess** only  
3. Click **More Options**  
4. Enable **Fill in missing loops**  
5. Provide the **FASTA sequence**

Maestro will rebuild all missing segments.

---

### **6. Replace Cryo-EM PIP₂ Headgroups with Full-Length PIP₂**

Cryo-EM typically captures only the PIP₂ headgroup.  
Simulations require **full-length PIP₂ with tails**.

#### **Method: Manual Superposition**

1. Save each Cryo-EM PIP headgroup as a PDB  
2. Import a full-length PIP₂ structure  
3. Select PIP₂ + protein  
4. Open **Superimpose**  
   - Reference: protein  
   - Method: **Atom pairs**  
5. Manually define headgroup atom pairs  
6. Merge the aligned structures  
7. Delete the Cryo-EM headgroup (PIO)  
8. Repeat for each subunit

**Important:**  
Ensure PIP₂ tails point toward the membrane.

---

### **7. Save the Final Cleaned Structures**

You need two PDB files:

#### **1. Protein-only PDB**
Required for H++, because it cannot process lipids or ligands.

#### **2. Full system PDB (protein + full PIP₂ + future ligands)**
Required later for membrane setup and tleap.

Export using:

**File → Export Structures → PDB**

Examples:

- `protein_only.pdb`
- `protein_with_full_pip2.pdb`

---

## Summary

At the end of this step, you should have:

- Clean Cryo-EM structure  
- Correct ions kept  
- Mutations fixed  
- Missing loops rebuilt  
- Full-length PIP₂ molecules placed  
- Protein-only PDB for H++  
- Full system PDB for membrane setup

Next step: **Protonation and pKa Assignment (H++ Server)**.
