# 4. System Assembly in Maestro

In this step, we assemble the full protein–PIP–ion structure inside Maestro. This is necessary because:

- H++ gives correct protonation,
- the preprocessed PDB has correct headgroup positions,
- the CHARMM-GUI PDB has correct membrane coordinates,
- and the full PIP molecule comes from `PIP.pdb`.

We must bring all these pieces together into one consistent coordinate frame before sending the structure to tleap.

## 4A. Import All Required Structures

Create a new Maestro project and import the following four files:

- `0.15_80_10_pH7.4_pdb4amber_G2_S181P_proteinonly_nocon.pdb` — This is the fully protonated protein from H++.
- `G2_S181P.pdb` — This contains the truncated PIP headgroups and the ions in the right biological positions.
- `PIP.pdb` — This contains the full PIP2 molecule we want to place in the lipid bilayer.
- `proteinonly.pdb` — This comes from CHARMM-GUI and contains the protein in the correct membrane orientation.

After importing, confirm that all files appear in the Entries Panel.

This ensures that each component (protein, PIPs, ions) is available to be aligned and merged.

## 4B. Align the H++ Output to the Preprocessed Structure

We first align:

**H++ protonated structure → G2_S181P.pdb**

because:

- the protonation from H++ is correct,
- but the headgroups and ions in `G2_S181P.pdb` are in the correct membrane-relative positions.

Open:

**Tools → Protein Structure Alignment**

**Important:** Make sure the reference structure (`G2_S181P.pdb`) is placed above the H++ structure in the Entries table.

Use:

- Residue-based alignment
- All chains included

This places the H++-protonated protein exactly where the preprocessed structure was located.

We do this so that when we later add the PIPs and ions, the protonated protein matches their positions perfectly.

## 4C. Replace the Truncated Headgroups With Full PIP₂ Molecules

### Why this step is required

The preprocessed structure from earlier steps contains only truncated PIP headgroups. We need to:

- keep the original headgroup positions,
- but attach full-length PIP2 ligands in the correct orientation.

To do this, we copy the headgroups as references and align the full PIP onto them.

### Step 1 — Copy each headgroup to a new entry

Right-click on each PIP headgroup → **Copy to New Entry**.

This isolates each headgroup so we can use it as an alignment reference.

### Step 2 — Align full PIP to the extracted headgroup

Select one headgroup entry, then select the full PIP entry. (The reference MUST be above.)

Open:

**Tools → Ligand Alignment**

Use:

- User-specified reference
- Constrain common substructure (MCS) → This ensures the headgroup atoms overlap perfectly.

Repeat this for all four PIP molecules.

**Result:** You now have 4 full PIP2 molecules oriented exactly where the truncated headgroups originally were.

This preserves the biological headgroup placement inside the protein pocket.

## 4D. Extract the Ions

From `G2_S181P.pdb`, select the ions (K⁺ or Na⁺ depending on your file):

Right-click → **Copy to New Entry**.

Place this new ions entry after the four aligned PIPs.

This ensures they are merged in the correct order later.

## 4E. Merge the Aligned Protein, PIPs, and Ions

Select:

- the aligned H++ protein,
- all 4 aligned PIP entries,
- the extracted ion entry.

Right-click → **Merge → Merge Selected Entries**.

This gives one combined entry:

- Protein (correct protonation)
- Full PIP2 molecules
- K+ ions

This structure now fully contains everything except the membrane.

## 4F. Align the Merged Structure to the CHARMM-GUI Oriented Protein

We must now place the merged complex into the correct membrane frame, provided by CHARMM-GUI.

To do this:

- Put `proteinonly.pdb` (CHARMM-GUI) above the merged entry
- Open **Protein Structure Alignment**
- Use **Residues** for alignment

This step is crucial because:

- CHARMM-GUI defines the Z-axis membrane orientation,
- tleap will build the bilayer around this orientation,
- and we want PIPs and ions to stay in the correct spatial positions.

## 4G. Fix PIP Residue Numbers

Tleap requires PIPs to have unique residue numbers.

The last protein residue is 1312, so set:

- PIP A → 1313
- PIP B → 1314
- PIP C → 1315
- PIP D → 1316

Use:

**Build → Other Edits → Change Atom Properties → Residue Number**

Also add **TER** after each PIP.

## 4H. Convert CYS → CYX for Disulfide Bonds

Amber needs CYX to mark cysteines that form disulfide bonds.

Open your reference file (`pdb4amber_G2_S181P_proteinonly.pdb`) and identify all CYX residues:

- 80
- 112
- 408
- 440
- 736
- 768
- 1064
- 1096

Change these manually in the merged PDB:
```
CYS → CYX
```

## 4I. Add TER Cards at Chain Ends

TER cards must mark the end of each chain to avoid merging chains accidentally.

Search for **OXT**, which marks the end of a chain:

Insert a **TER** line after each OXT or chain end.

## 4J. Remove CONNECT and ANISOU Lines

Amber will crash if CONECT or ANISOU lines are present.

Scroll to the bottom and delete:

- every `CONECT` line
- every `ANISOU` line

This should clean up the PDB for tleap compatibility.

## 4K. Export the Final Merged Complex

Go to:

**File → Export Structures**

Set:

- Export all entries to the same file
- Reorder by residue number
- Use display names OFF
- v3000 OFF

Save as:
```
G2_S181P_charm_aligned.pdb
```

This is now the complete protein + PIP2 + ions structure in the correct membrane orientation.

---

# 5. Combine the Assembled Protein With the CHARMM-GUI Lipid Bilayer

## 5A. Prepare the DOPC_128 Lipid File

Open `DOPC_128.pdb` in a text editor.

Jump to the CHL lines:
```
/CHL <Enter>
```

Find the first cholesterol or lipid entry (e.g., line 20979).

Delete everything above that line:
```
20977dd
:wq
```

This isolates the lipid portion only.

## 5B. Add TER After Each PIP

Each PIP must end with:
```
TER
```

This ensures tleap does not merge them together.

## 5C. Remove Hydrogens Before Running tleap

Hydrogens should be regenerated by tleap for correct Amber atom typing.

Use:
```bash
reduce -Trim combined_full_protein_with_lipid.pdb > combined_full_protein_with_lipid_noH.pdb
```

## 5D. Concatenate Protein/PIP/Ions With Lipids

Finally merge protein + lipids:
```bash
cat G2_S181P_charm_aligned.pdb DOPC_128.pdb > combined_full_protein_with_lipid.pdb
```

This is the final structure you will give to tleap.

---

# Summary

At the end of the system-assembly step in Maestro, you should now have:

- A fully protonated protein (from H++)
- Correct biological positions for the original truncated PIP headgroups (from the preprocessed PDB)
- Full-length PIP₂ molecules aligned onto those headgroups
- All K⁺ ions extracted and placed in the correct coordinates
- All PIPs renumbered (1313–1316) with proper TER cards
- All cysteines forming disulfides converted from CYS → CYX
- All ANISOU and CONECT lines removed
- The complete protein–PIP–ion complex aligned to the CHARMM-GUI membrane frame
- A merged `combined_full_protein_with_lipid.pdb` containing:
  - the assembled protein
  - four full PIP₂ molecules
  - potassium ions
  - the DOPC lipid bilayer
  - no hydrogens (tleap will add them)

You now have a clean, membrane-aligned, Amber-compatible structure ready for tleap.

**Next step:** AMBER parameterization and tleap system building.
