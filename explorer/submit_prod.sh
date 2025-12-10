#!/usr/bin/env bash
set -euo pipefail

RUN_NUM="${1:?Provide RUN name, e.g. RUN1}"

echo "Submitting first production segment for $RUN_NUM ..."

sbatch --export=SEG=1,RUN_NUM=${RUN_NUM} run_prod_segment_v100.slurm

