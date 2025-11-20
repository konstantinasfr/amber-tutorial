#!/usr/bin/env bash
#set -euo pipefail

# Amber env + pick GPU 1
source /home/yongcheng/Program/amber24/amber.sh
export CUDA_VISIBLE_DEVICES=1

RUN_NUM="${1:-1}"

# Paths (kept same layout as your previous script)
INDIR="./input"
LOGDIR="./output/${RUN_NUM}/logs"
RSTD="./output/${RUN_NUM}/rst"
TRJD="./output/${RUN_NUM}/traj"
INFOD="./output/${RUN_NUM}/info"

mkdir -p "$LOGDIR" "$RSTD" "$TRJD" "$INFOD"

# Use the 4 fs (HMR) topology, per your example
TOP="${INDIR}/com.prmtop"

# =============== Production (5 segments) ===============
pmemd.cuda -O -i "${INDIR}/05_Prod.in" -o "${LOGDIR}/05_Prod1.out" -p "${TOP}" -c "${RSTD}/04_Hold10.rst" -r "${RSTD}/05_Prod1.rst" -x "${TRJD}/05_Prod1.mdcrd" -inf "${INFOD}/05_Prod1.mdinfo"
pmemd.cuda -O -i "${INDIR}/05_Prod.in" -o "${LOGDIR}/05_Prod2.out" -p "${TOP}" -c "${RSTD}/05_Prod1.rst"  -r "${RSTD}/05_Prod2.rst" -x "${TRJD}/05_Prod2.mdcrd" -inf "${INFOD}/05_Prod2.mdinfo"
pmemd.cuda -O -i "${INDIR}/05_Prod.in" -o "${LOGDIR}/05_Prod3.out" -p "${TOP}" -c "${RSTD}/05_Prod2.rst"  -r "${RSTD}/05_Prod3.rst" -x "${TRJD}/05_Prod3.mdcrd" -inf "${INFOD}/05_Prod3.mdinfo"
pmemd.cuda -O -i "${INDIR}/05_Prod.in" -o "${LOGDIR}/05_Prod4.out" -p "${TOP}" -c "${RSTD}/05_Prod3.rst"  -r "${RSTD}/05_Prod4.rst" -x "${TRJD}/05_Prod4.mdcrd" -inf "${INFOD}/05_Prod4.mdinfo"
pmemd.cuda -O -i "${INDIR}/05_Prod.in" -o "${LOGDIR}/05_Prod5.out" -p "${TOP}" -c "${RSTD}/05_Prod4.rst"  -r "${RSTD}/05_Prod5.rst" -x "${TRJD}/05_Prod5.mdcrd" -inf "${INFOD}/05_Prod5.mdinfo"

