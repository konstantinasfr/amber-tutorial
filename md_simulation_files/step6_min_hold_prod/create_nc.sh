#!/usr/bin/env bash
set -euo pipefail

# Load Amber
source /home/yongcheng/Program/amber24/amber.sh

# Paths (same layout as your MD scripts)
INDIR="./input"
TRJD="./output/traj"
TOP="${INDIR}/com.prmtop"

# Combined output name
OUT_TRAJ="${TRJD}/Prod_all.nc"

echo "[INFO] Using topology: ${TOP}"
echo "[INFO] Reading trajectories from: ${TRJD}"
echo "[INFO] Writing combined trajectory to: ${OUT_TRAJ}"

cpptraj "${TOP}" <<EOF
trajin ${TRJD}/05_Prod1.mdcrd
trajin ${TRJD}/05_Prod2.mdcrd
trajin ${TRJD}/05_Prod3.mdcrd
trajin ${TRJD}/05_Prod4.mdcrd
trajin ${TRJD}/05_Prod5.mdcrd

# Optional but recommended: make it continuous & centered.
# Adjust :1-9999 to your protein/lipid residue range if you know it.
autoimage
center :1-9999 mass origin
image origin center

trajout ${OUT_TRAJ} netcdf
run
EOF

echo "[INFO] Done. Combined trajectory: ${OUT_TRAJ}"

