#!/usr/bin/env bash
set -euo pipefail

# ---------- Settings ----------
NPROCS=32
ENGINE="sander.MPI"         # CPU MPI executable
INDIR="./input"               # folder with all .in files + com.prmtop/com.inpcrd

RUN_NUM="${1:-1}"

INDIR="./input"
LOGDIR="./output/${RUN_NUM}/logs"
RSTD="./output/${RUN_NUM}/rst"
TRJD="./output/${RUN_NUM}/traj"
INFOD="./output/${RUN_NUM}/info"

mkdir -p "$LOGDIR" "$RSTD" "$TRJD" "$INFOD"

TOP="${INDIR}/com.prmtop"
CRD="${INDIR}/com.inpcrd"

command -v mpirun >/dev/null || { echo "mpirun not found"; exit 1; }
command -v "$ENGINE" >/dev/null || { echo "$ENGINE not found in PATH"; exit 1; }

run() {
  local label="$1"; shift
  echo ">>> Starting ${label} ..."
  mpirun -np "${NPROCS}" ${ENGINE} -O "$@"
  echo "✔ Completed ${label}"
}

# # 1) Minimization
run "min"   -i "${INDIR}/min.in"   -o "${LOGDIR}/min.out"   -p "${TOP}" -c "${CRD}"  -r "${RSTD}/min.rst"   -ref "${CRD}"

# # 2) Minimization 2
run "min2"  -i "${INDIR}/min2.in"  -o "${LOGDIR}/min2.out"  -p "${TOP}" -c "${RSTD}/min.rst" -r "${RSTD}/min2.rst"


# 3) Heating steps
run "02_Heat"   -i "${INDIR}/02_Heat.in"   -o "${LOGDIR}/02_Heat.out"   -p "${TOP}" -c "${RSTD}/min2.rst"   -r "${RSTD}/02_Heat.rst"   -x "${TRJD}/02_Heat.mdcrd"   -ref "${RSTD}/min2.rst"   -inf "${INFOD}/02_Heat.mdinfo"
run "03_Heat2"  -i "${INDIR}/03_Heat2.in"  -o "${LOGDIR}/03_Heat2.out"  -p "${TOP}" -c "${RSTD}/02_Heat.rst" -r "${RSTD}/03_Heat2.rst"  -x "${TRJD}/03_Heat2.mdcrd"  -ref "${RSTD}/02_Heat.rst" -inf "${INFOD}/03_Heat2.mdinfo"
run "03_Heat3"  -i "${INDIR}/03_Heat3.in"  -o "${LOGDIR}/03_Heat3.out"  -p "${TOP}" -c "${RSTD}/03_Heat2.rst" -r "${RSTD}/03_Heat3.rst"  -x "${TRJD}/03_Heat3.mdcrd"  -ref "${RSTD}/03_Heat2.rst" -inf "${INFOD}/03_Heat3.mdinfo"
