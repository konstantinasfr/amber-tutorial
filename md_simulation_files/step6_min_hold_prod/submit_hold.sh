#!/usr/bin/env bash
set -euo pipefail

# Amber env + pick GPU 1
source /home/yongcheng/Program/amber24/amber.sh
export CUDA_VISIBLE_DEVICES=1

RUN_NUM="${1:-1}"

# Paths
INDIR="./input"
LOGDIR="./output/${RUN_NUM}/logs"
RSTD="./output/${RUN_NUM}/rst"
TRJD="./output/${RUN_NUM}/traj"
INFOD="./output/${RUN_NUM}/info"

mkdir -p "$LOGDIR" "$RSTD" "$TRJD" "$INFOD"

TOP="${INDIR}/com.prmtop"

# ================= HOLD Stages =================
echo ">>> Starting 04_Hold1"
#pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold1.out"  -p "${TOP}" -c "${RSTD}/03_Heat3.rst"  -r "${RSTD}/04_Hold1.rst"  -x "${TRJD}/04_Hold1.mdcrd"  -ref "${RSTD}/03_Heat3.rst"   -inf "${INFOD}/04_Hold1.mdinfo"
echo "✔ Completed 04_Hold1"

echo ">>> Starting 04_Hold2"
#pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold2.out"  -p "${TOP}" -c "${RSTD}/04_Hold1.rst"  -r "${RSTD}/04_Hold2.rst"  -x "${TRJD}/04_Hold2.mdcrd"  -ref "${RSTD}/04_Hold1.rst"   -inf "${INFOD}/04_Hold2.mdinfo"
echo "✔ Completed 04_Hold2"

echo ">>> Starting 04_Hold3"
#pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold3.out"  -p "${TOP}" -c "${RSTD}/04_Hold2.rst"  -r "${RSTD}/04_Hold3.rst"  -x "${TRJD}/04_Hold3.mdcrd"  -ref "${RSTD}/04_Hold2.rst"   -inf "${INFOD}/04_Hold3.mdinfo"
echo "✔ Completed 04_Hold3"

echo ">>> Starting 04_Hold4"
#pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold4.out"  -p "${TOP}" -c "${RSTD}/04_Hold3.rst"  -r "${RSTD}/04_Hold4.rst"  -x "${TRJD}/04_Hold4.mdcrd"  -ref "${RSTD}/04_Hold3.rst"   -inf "${INFOD}/04_Hold4.mdinfo"
echo "✔ Completed 04_Hold4"

echo ">>> Starting 04_Hold5"
#pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold5.out"  -p "${TOP}" -c "${RSTD}/04_Hold4.rst"  -r "${RSTD}/04_Hold5.rst"  -x "${TRJD}/04_Hold5.mdcrd"  -ref "${RSTD}/04_Hold4.rst"   -inf "${INFOD}/04_Hold5.mdinfo"
echo "✔ Completed 04_Hold5"

echo ">>> Starting 04_Hold6"
#pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold6.out"  -p "${TOP}" -c "${RSTD}/04_Hold5.rst"  -r "${RSTD}/04_Hold6.rst"  -x "${TRJD}/04_Hold6.mdcrd"  -ref "${RSTD}/04_Hold5.rst"   -inf "${INFOD}/04_Hold6.mdinfo"
echo "✔ Completed 04_Hold6"

echo ">>> Starting 04_Hold7"
#pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold7.out"  -p "${TOP}" -c "${RSTD}/04_Hold6.rst"  -r "${RSTD}/04_Hold7.rst"  -x "${TRJD}/04_Hold7.mdcrd"  -ref "${RSTD}/04_Hold6.rst"   -inf "${INFOD}/04_Hold7.mdinfo"
echo "✔ Completed 04_Hold7"

echo ">>> Starting 04_Hold8"
pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold8.out"  -p "${TOP}" -c "${RSTD}/04_Hold7.rst"  -r "${RSTD}/04_Hold8.rst"  -x "${TRJD}/04_Hold8.mdcrd"  -ref "${RSTD}/04_Hold7.rst"   -inf "${INFOD}/04_Hold8.mdinfo"
echo "✔ Completed 04_Hold8"

echo ">>> Starting 04_Hold9"
pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold9.out"  -p "${TOP}" -c "${RSTD}/04_Hold8.rst"  -r "${RSTD}/04_Hold9.rst"  -x "${TRJD}/04_Hold9.mdcrd"  -ref "${RSTD}/04_Hold8.rst"   -inf "${INFOD}/04_Hold9.mdinfo"
echo "✔ Completed 04_Hold9"

echo ">>> Starting 04_Hold10"
pmemd.cuda -O -i "${INDIR}/04_Hold.in" -o "${LOGDIR}/04_Hold10.out" -p "${TOP}" -c "${RSTD}/04_Hold9.rst"  -r "${RSTD}/04_Hold10.rst" -x "${TRJD}/04_Hold10.mdcrd" -ref "${RSTD}/04_Hold9.rst"   -inf "${INFOD}/04_Hold10.mdinfo"
echo "✔ Completed 04_Hold10"

echo ">>> All HOLD stages finished successfully on GPU 1."

#./submit_prod.sh RUN1
