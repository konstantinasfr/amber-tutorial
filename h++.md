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

At the end of the PDB, delete all lines beginning with:


These cause errors in H++.

---

## 2. Prepare a Clean PDB Using pdb4amber

Use `pdb4amber` to sanitize atom names, remove hydrogens, and ensure compatibility:

```
pdb4amber -i GIRK12_E141Q_PIP2full_prepared.pdb -o GIRK12_clean4hpp.pdb --nohyd
```


This produces a clean file that can be safely processed by H++.

---

## 3. Submit the File to H++

Upload `GIRK12_clean4hpp.pdb` to the H++ server and set:

- **pH = 7.4**  
- **Salinity = 0.15**  
- **Internal dielectric = 10**  
- **External dielectric = 80**  
- Enable: *Correct orientation of ASN, GLN, and HIS groups, add H atoms, and assign HIS H atoms to δ or ε based on contacts*

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
0.15_80_10_pH7.4_GIRK12_clean4hpp.result.pdb
0.15_80_10_pH7.4_GIRK12_clean4hpp.top
0.15_80_10_pH7.4_GIRK12_clean4hpp.crd
```
