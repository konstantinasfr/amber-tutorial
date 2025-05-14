import os
import sys

def generate_tleap_with_bonds(pdb_input):
    pdb_basename = os.path.splitext(os.path.basename(pdb_input))[0]
    output_dir = pdb_basename
    os.makedirs(output_dir, exist_ok=True)

    residue_map = {}
    seen_residues = set()
    ssbond_pairs = []
    index = 1

    # Step 1: Parse PDB and extract residue mapping and SSBONDs
    with open(pdb_input, 'r') as f:
        for line in f:
            if line.startswith(("ATOM", "HETATM")):
                resname = line[17:20].strip()
                chain = line[21].strip()
                resid = int(line[22:26].strip())
                uid = (chain, resid, resname)
                if uid not in seen_residues:
                    residue_map[uid] = index
                    index += 1
                    seen_residues.add(uid)
            elif line.startswith("SSBOND"):
                res1 = (line[15].strip(), int(line[17:21].strip()), line[11:14].strip())
                res2 = (line[29].strip(), int(line[31:35].strip()), line[25:28].strip())
                ssbond_pairs.append((res1, res2))

    # Step 2: Write rename_cys_to_cyx.sh
    sed_script_path = os.path.join(output_dir, "rename_cys_to_cyx.sh")
    with open(sed_script_path, "w") as sedfile:
        sedfile.write("#!/bin/bash\n")
        sedfile.write(f"cd {output_dir}\n")
        sedfile.write("cp first_with_hydrogens.pdb first_with_hydrogens_tmp.pdb\n")
        for res1, res2 in ssbond_pairs:
            for res in (res1, res2):
                chain, resid, resname = res
                if resname == "CYS":
                    new_id = residue_map.get(res)
                    if new_id:
                        sedfile.write(
                            f"sed -i '/CYS *{int(new_id)} /s/CYS/CYX/' first_with_hydrogens_tmp.pdb\n"
                        )
                        sedfile.write(
                            f"sed -i '/CYX *{int(new_id)} /{{ / HG /d }}' first_with_hydrogens_tmp.pdb\n"
                        )
        sedfile.write("cp first_with_hydrogens_tmp.pdb first_with_hydrogens_cyx.pdb\n")

    # Step 4: Write tleap.in
    tleap_file = os.path.join(output_dir, "tleap.in")
    amber_output_dir = os.path.join(output_dir, "amber_input")
    os.makedirs(amber_output_dir, exist_ok=True)

    with open(tleap_file, "w") as fout:
        fout.write("source leaprc.protein.ff19SB\n")
        fout.write("source leaprc.gaff2\n")
        fout.write("source leaprc.lipid21\n")
        fout.write("source leaprc.water.tip3p\n")
        fout.write("loadamberparams frcmod.ionsjc_tip3p\n\n")
        
        fout.write("# Step 2: Load renamed CYX PDB\n")
        fout.write("mol = loadpdb first_with_hydrogens_cyx.pdb\n\n")

        fout.write("# Step 3: Add disulfide bonds\n")
        for r1, r2 in ssbond_pairs:
            n1 = residue_map.get(r1)
            n2 = residue_map.get(r2)
            if n1 and n2:
                fout.write(f"bond mol.{n1}.SG mol.{n2}.SG\n")
            else:
                fout.write(f"# Warning: could not map {r1} or {r2}\n")

        fout.write("\n# Step 4: Add ions and solvate\n")
        fout.write("addions mol K+ 0\n")
        fout.write("addions mol Cl- 0\n")
        fout.write("solvatebox mol TIP3PBOX 10.0\n\n")

        fout.write("# Step 5: Save output\n")
        fout.write(f"savepdb mol {os.path.join('amber_input', 'with_water.pdb')}\n")
        fout.write(f"saveamberparm mol {os.path.join('amber_input', 'com.prmtop')} {os.path.join('amber_input', 'com.inpcrd')}\n")
        fout.write("quit\n")

    print(f"All files saved in: {output_dir}/")
    print("To run the steps, execute:")
    print(f"cd {output_dir} && tleap -f make_hydrogens.in && bash rename_cys_to_cyx.sh && tleap -f tleap.in")


# === Main execution ===
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python generate_tleap_with_bonds.py input.pdb")
        sys.exit(1)
    generate_tleap_with_bonds(sys.argv[1])