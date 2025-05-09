#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 input.pdb"
  exit 1
fi

PDB_INPUT="$1"
BASE_NAME=$(basename "$PDB_INPUT" .pdb)

# Step 0: Create folder
mkdir -p "$BASE_NAME"

# Step 1: Create make_hydrogens.in inside the folder
cat > "$BASE_NAME/make_hydrogens.in" <<EOF
source leaprc.protein.ff19SB
abc = loadpdb ../$PDB_INPUT
savepdb abc first_with_hydrogens.pdb
quit
EOF

# Step 2: Run tleap inside the folder to make first_with_hydrogens.pdb
(cd "$BASE_NAME" && tleap -f make_hydrogens.in)

# Step 3: Generate tleap.in + sed script for renaming CYS → CYX
python generate_tleap_with_bonds.py "$PDB_INPUT"

# Step 4: Run sed script to rename CYS → CYX (inside the folder)
(cd "$BASE_NAME" && bash rename_cys_to_cyx.sh)

# Step 5: Run final tleap prep using tleap.in (inside the folder)
(cd "$BASE_NAME" && tleap -f tleap.in)
