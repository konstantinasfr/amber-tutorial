#!/usr/bin/env bash
set -euo pipefail

RUN_NAME=$1

# Submit minimization/heating
JOB1=$(sbatch --parsable run_min_heat_explorer.slurm $RUN_NAME)
echo "Submitted min/heat job: $JOB1"

# Wait for job 1 to finish
echo "Waiting for job $JOB1 to complete..."
while squeue -j $JOB1 2>/dev/null | grep -q $JOB1; do
    sleep 60  # check every minute
done
echo "Job $JOB1 completed"

# Submit hold/equilibration
JOB2=$(sbatch --parsable run_hold_explorer.slurm $RUN_NAME)
echo "Submitted hold job: $JOB2"

# Wait for job 2 to finish
echo "Waiting for job $JOB2 to complete..."
while squeue -j $JOB2 2>/dev/null | grep -q $JOB2; do
    sleep 60
done
echo "Job $JOB2 completed"

# Submit production
./submit_prod.sh $RUN_NAME
echo "Production submitted for $RUN_NAME"
