# 6. Energy Minimization, Heating, Equilibration, and Production MD

Once the AMBER topology (`com.prmtop`) and coordinates (`com.inpcrd`) are prepared, we proceed with the standard MD workflow:

1. Minimization
2. Heating
3. Equilibration (Hold)
4. Production MD

We run minimization and heating on CPU, and equilibration/production on GPU.

## 6A. Minimization

We begin with a short minimization to relax bad contacts while keeping the protein and PIPs restrained.

### Minimization Input File (Min.in)

```
Minimization with Cartesian restraints for the solute
&cntrl
 imin=1,
 maxcyc=100,
 ntpr=5,
 ntmin=2,
 ntr=1,
&end
/
500.0
RES 1 1316
END
END
```

### Explanation

- `RES 1 1316` corresponds to protein + PIPs.
- In this system, the PIPs end at residue 1316, so we restrain residues 1–1316 with 500 kcal/mol·Å².

### Running Minimization

Use cpptraj to extract the minimized structure:

```bash
cpptraj ./input/com.prmtop <<EOF
trajin ./output/min/rst/min2.rst
trajout min2_minimized.pdb pdb
run
quit
EOF
```

## 6B. Heating

We use three heating steps.

Before running them, the restraint lines must be adapted for your residue numbering.

### Example restraint blocks used in `02_Heat.in` and `03_Heat2.in`:

```
500.0
RES 1 1316
END

10.0
RES 1321 2168
END
```

- **Protein + PIPs:** residues 1–1316
- **Lipids:** residues 1321–2168

Lipids receive only weak restraints so they can adapt to the protein surface.

![connect at the end of the pdb](g2_figures/step6:min_hold_prod/protein_numbering.png) <br>
*End of protein and PIPs, start of bilayer*

![connect at the end of the pdb](g2_figures/step6:min_hold_prod/membrane_end.png) <br>
*End of lipid bilayer*

## 6C. Running Minimization and Heating

We use the script:

```bash
./submit_min_heat.sh RUN1
```

Where:

- `RUN1` is the name of the new folder created for this run
- You can run additional simulations by using different names (`RUN2`, `RUN3`, etc.)

The script performs:

- 2 minimizations
- 3 heating steps (gradual temperature increase)

The first steps are very fast; the later heating steps may take 1–2 hours.

The `info` files inside `output/info` show the estimated time.

We run these steps on CPU using MPI:

```bash
mpirun -n 32 pmemd.MPI ...
```

You can adjust the number of CPUs depending on your machine.

## 6D. Inspecting the System After Heating

After heating, generate a PDB from the last restart file:

```bash
cpptraj ./input/com.prmtop <<EOF
trajin ./output/RUN1/rst/03_Heat3.rst
trajout heat3.pdb pdb
run
quit
EOF
```

Open `heat3.pdb` in VMD.

### Check for Atom Clashes in VMD

1. Open VMD
2. Go to **Extensions → Tk Console**
3. Load the setup script:

```tcl
source vmd_setup.tcl
```

This places a reference residue at the center of the pore.

4. Go to **Graphics → Representations**, click **Create Rep**, and use the following selections:

**Check if PIP overlaps with protein:**

```
resname PIP and within 1.5 of protein
```

**Check if membrane overlaps with PIP:**

```
not water and not protein and not resname PIP and within 1.5 of resname PIP
```

**Check if membrane overlaps with protein:**

```
not water and not protein and not resname PIP and within 1.5 of protein
```

If no clashes are visible, your heated structure is ready for equilibration.

## 6E. Equilibration (Hold)

We run 10 hold steps, each gradually releasing restraints.

This stabilizes:

- lipid packing
- protein–membrane contacts
- PIP interactions
- internal protein flexibility

Each hold step usually takes ~5 minutes on GPU.

We run them using:

```bash
pmemd.cuda -O -i 04_HoldX.in ...
```

This section uses GPU acceleration because equilibration requires more timesteps.

## 6F. Production MD

Production MD is the final, long simulation step.

We use `pmemd.cuda`, which gives maximum speed on NVIDIA GPUs.

- Each production segment may take up to 10 hours
- Typical production run = many segments, e.g., 10 ns, 50 ns, or 100 ns

These trajectories are later used for cpptraj analysis, ion permeation analysis, force calculations, etc.

Production is the longest and most computationally expensive part of the workflow.

---

# Summary

At the end of this stage, you will have:

- Minimized structure (relaxed contacts)
- Heated system (at target temperature)
- Equilibrated membrane–protein–PIP arrangement
- Production MD trajectory, ready for analysis

You can now proceed with:

- RMSD, RMSF
- hydrogen bonds
- ion permeation tracking
- and any custom analysis scripts
