#!/bin/bash
cd 3syc
cp first_with_hydrogens.pdb first_with_hydrogens_tmp.pdb
sed -i '/CYS *62 /s/CYS/CYX/' first_with_hydrogens_tmp.pdb
sed -i '/CYX *62 /{ / HG /d }' first_with_hydrogens_tmp.pdb
sed -i '/CYS *94 /s/CYS/CYX/' first_with_hydrogens_tmp.pdb
sed -i '/CYX *94 /{ / HG /d }' first_with_hydrogens_tmp.pdb
cp first_with_hydrogens_tmp.pdb first_with_hydrogens_cyx.pdb
