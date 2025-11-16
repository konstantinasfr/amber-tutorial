# Protonation and pKa Assignment (H++ Server)

H++ is used to add hydrogens, determine protonation states, flip Asn/Gln/His residues when necessary, and prepare a structure with correct ionization states at the desired pH. The H++ output will later be merged back with the protein–PIP₂–ion system.

---

## 1. Clean the Structure Before Submitting to H++

H++ requires:
- protein only  
- no ligands  
- no PIP₂  
- no ions  
- no CONECT records at the end of the PDB

### **1A. Remove CONECT Records**

We open *pdb4amber_G12_S181P_S170P_proteinonly.pdb* 
At the end of the PDB, delete all lines beginning with:


These cause errors in H++.
We rename the file to pdb4amber_G12_S181P_S170P_proteinonly_nocon.pdb

---

## 2. Prepare a Clean PDB Using pdb4amber

Use `pdb4amber` to sanitize atom names, remove hydrogens, and ensure compatibility:

```
pdb4amber -i ./input/G12_S181P_S170P_proteinonly.pdb -o ./output/pdb4amber_G12_S181P_S170P_proteinonly.pdb --nohyd
```


This produces a clean file that can be safely processed by H++.

---

## 3. Submit the File to H++

Upload `GIRK12_clean4hpp.pdb` to the H++ server and set:

- **pH = 7.4**  
- Disable: *Correct orientation of ASN, GLN, and HIS groups, add H atoms, and assign HIS H atoms to δ or ε based on contacts*

H++ will read:

- Number of titratable sites  
- Number of chains  
- Estimated run time  
- Structural warnings  
- Protonation summary  

Typical output messages include:
- SUCCESS in determining flips, adding H atoms  
- WARNING if the hydrogen optimization encounters steric clashes  
- SUCCESS in computing pKa values  
- SUCCESS in generating topology/coordinate files  

If warnings appear, especially about **AMBER pol_h pre-optimization**, review your structure for steric clashes.

---

## 4. Download the Key Output Files

Download:

- **PDB (PQR) structure in predicted protonation state**  
- **AMBER topology file (.top)**  
- **AMBER coordinate file (.crd)**  

These are usually named like:

```
0.15_80_10_pH7.4_pdb4amber_G12_S181P_S170P_proteinonly_nocon.crd.result.pdb
0.15_80_10_pH7.4_pdb4amber_G12_S181P_S170P_proteinonly_nocon.crd.top
0.15_80_10_pH7.4_pdb4amber_G12_S181P_S170P_proteinonly_nocon.crd.crd
```

---

## 5. Convert Topology + Coordinates Back to a PDB

Use `ambpdb` to generate a PDB with all hydrogens added by H++:

```
ambpdb -c 0.15_80_10_pH7.4_pdb4amber_G12_S181P_S170P_proteinonly_nocon.crd -p 0.15_80_10_pH7.4_pdb4amber_G12_S181P_S170P_proteinonly_nocon.top >0.15_80_10_pH7.4_pdb4amber_G12_S181P_S170P_proteinonly_nocon.pdb
```

This is the protonated protein structure.

---

## 6. Inspect Protonation States in VMD

Open the new PDB in VMD:
```
vmd 0.15_80_10_pH7.4_pdb4amber_G12_S181P_S170P_proteinonly_nocon.pdb
```

Check:
- Whether protonation is consistent across **all four subunits**  
- Histidine types: **HIE**, **HID**, **HIP**  
- Any suspiciously protonated residues  
- Any missing heavy atoms (should not occur if pdb4amber was used)  

Example selection to highlight HIE:
```
resname HIE
```

Visual inspection is critical, especially around functional regions.

---

## 7. Merge Protonated Protein Back With the Original Full System

H++ **returns only the protein**.  
It does *not* include:

- PIP₂  
- ions  
- ligands  
- membrane  
- waters  

Therefore, we must **superimpose** the H++-processed protein onto the original prepared system that contains PIP₂ and any ligands/ions.

Steps:

1. Load both structures into Maestro (or VMD/PyMOL).  
2. Use **Superimpose / Align** on backbone atoms (e.g., Cα).  
3. Replace the protein coordinates in the full system with the protonated version.  
4. Keep the original PIP₂, ions, ligand positions exactly unchanged.

This gives you the final **protonated full system PDB**, ready for CHARMM-GUI or tleap.

---

# Summary

After completing H++:

- You have a protonated protein at pH 7.4  
- Protonation states of HIS, ASN, GLN are optimized  
- Missing hydrogens added  
- Physically reasonable protonation based on pKa predictions  
- Structure converted to PDB via `ambpdb`  
- Protonated protein aligned back to the full system with PIP₂ and ions  

You are now ready for:

**Step 3 — Membrane System Construction (CHARMM-GUI)**



