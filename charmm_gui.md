# CHARMM-GUI Bilayer Builder (Membrane Embedding)

This section explains how to embed the cleaned protein-only PDB into a lipid bilayer using CHARMM-GUI Bilayer Builder. We start from the protein-only structure created earlier, with all waters, ions, and ligands removed.

## 2A. Upload the Protein
We go to https://www.charmm-gui.org/ but first we have to register.
![register](g2_figures/step3:charmmgui/register.png)

Go to CHARMM-GUI → Membrane Builder → Bilayer Builder.

![register](g2_figures/step3:charmmgui/bilayer_menu.png)\

Upload the protein-only PDB file *pdb4amber_G2_S181P_proteinonly.pdb*. CHARMM-GUI will automatically recognize the chains, detect engineered residues, and assign chain labels such as PROA, PROB, PROC, and PROD.

![Uploading the cleaned protein-only structure into CHARMM-GUI](image_placeholder)

## 2B. Step 1 — PDB Reader

CHARMM-GUI standardizes the uploaded PDB by converting it into CHARMM-compatible atom names and formats. It also splits the structure internally into separate chains and creates CHARMM PDB, PSF, and CRD files.

![CHARMM-GUI Step 1: PDB Reader](image_placeholder)

No changes are required here because protonation, disulfide bonds, and ligand parameters will be set later in H++ and tleap.

## 2C. Step 1 — Protein Orientation Using PPM

CHARMM-GUI provides several options to orient the protein relative to the membrane. For membrane proteins, the recommended method is "Run PPM 2.0".

PPM (Positioning of Proteins in Membranes) analyzes the hydrophobic thickness and orients the transmembrane region along the Z-axis.

**Steps:**

1. Select all chains (A, B, C, and D)
2. Click "Run PPM"
3. Wait for the oriented structure to be generated
4. Continue to Step 2

![Using PPM to orient the protein along the Z-axis](image_placeholder)

## 2D. Step 2 — Verify Orientation and Set System Size

CHARMM-GUI now displays the PPM-oriented structure. Ensure that the transmembrane helices are centered correctly along the membrane normal.

Next, set the X and Y dimensions of the system box. We set *Length of X and Y:* to 100Å

![Verifying the protein orientation and defining box dimensions](image_placeholder)

## 2E. Step 2 — Define Lipid Composition

Scroll down to the lipid lists and choose the lipid ratios for the upper and lower leaflets. A typical composition for GIRK channels includes:

+ POPC
+ POPE
+ POPS
+ Cholesterol

**Example ratios:**

| Lipid | Upper Leaflet | Lower Leaflet |
|-------|---------------|---------------|
| Cholesterol | 1 | 1 |
| POPC | 25 | 25 |
| POPE | 5 | 5 |
| POPS | 5 | 5 |

![Selecting the lipid types and ratios for the membrane](image_placeholder)

When finished, click "Show the system info" to check the calculated number of lipids and the membrane surface area. If CHARMM-GUI shows a warning about area mismatch, click "OK" to continue.

## 2F. Step 3 — Add Ions and Solvent

In the ion placement step, enable ion inclusion. Use the Distance method for ion placement because it is faster than Monte Carlo.

**Ion settings:**

+ Ion type: KCl
+ Ion concentration: 0.15 M

Click "Calculate Solvent Composition" to let CHARMM-GUI estimate how many K⁺ and Cl⁻ ions are required.

![Adding KCl ions and defining the solvent composition](image_placeholder)

## 2G. Step 4 — Build System Components

CHARMM-GUI now generates the following components:

+ Lipid bilayer
+ Ion box
+ Water box
+ Pore water

It automatically checks for lipid penetration into the protein, which typically does not occur for GIRK channels.

![Generated membrane, ions, and solvent components](image_placeholder)

Continue to the assembly step.

## 2H. Step 5 — Assemble the Full System and Choose Force Fields

CHARMM-GUI assembles the protein, lipids, water, and ions into a single system. The output includes a fully combined PDB file and CHARMM coordinate files.

**AMBER force field options:**

| Component | Force Field |
|-----------|-------------|
| Protein | ff19SB |
| RNA | OL3 |
| DNA | OL15 |
| Lipids | Lipid21 |
| Water | OPC |
| Ligands | GAFF2 |

![Selecting the appropriate AMBER force fields](image_placeholder)

Select the NPT ensemble at 303.15 K.

CHARMM-GUI generates the full AMBER equilibration protocol, including six equilibration stages with decreasing restraints.

## 2I. Step 6 — Download the Output Files

The final page contains download links for:

+ The assembled PDB
+ AMBER minimization input
+ AMBER equilibration inputs (steps 1–6)
+ AMBER production input
+ Restraint files
+ Crystal box information

![Downloading the final AMBER-ready input files](image_placeholder)

Download the entire `charmm-gui.tgz` archive for later use.

## 2J. Convert CHARMM Lipids to AMBER Format

Use the script `charmmlipid2amber.py` to convert CHARMM-style lipid residues into AMBER-compatible ones.

**Example:**

```bash
charmmlipid2amber.py -i step5_assembly.pdb -c charmmlipid2amber.csv -o converted_system.pdb
```

This produces a PDB containing AMBER lipid names.

## 2K. Split Protein and Membrane (Optional)

If needed, extract the protein and membrane into separate PDB files. This is sometimes required when lipid repositioning or ligand placement will be done in Maestro.

**To extract the protein:**

```bash
head -n N converted_system.pdb > proteinonly.pdb
```

**To extract the membrane:**

```bash
tail -n +N converted_system.pdb > membrane.pdb
```

Replace N with the correct line number where the protein ends.

## Summary

At the end of the CHARMM-GUI Bilayer Builder step, you should have:

+ A correctly oriented membrane protein
+ A defined XY box size appropriate for the lipid bilayer
+ A complete POPC/POPE/POPS/Cholesterol membrane
+ Water and ions added at the desired concentration
+ A fully assembled AMBER-ready system
+ All equilibration, minimization, and production input files
+ A combined system PDB suitable for further processing
+ (Optional) Separate protein and membrane PDB files for ligand placement or editing

**Next step:** Protonation and pKa Assignment (H++ Server).
