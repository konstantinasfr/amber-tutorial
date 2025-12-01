# Running AMBER MD Simulations on Explorer Cluster

## Getting Started

All steps can be run on the Explorer cluster. You can see how to get your account here: https://rc.northeastern.edu/getting-access/

## Setup

In the `explorer_scripts` folder, you can find the scripts needed to run all steps. In the `input` folder, add your `com.inpcrd` and `com.prmtop` files that were produced from the previous step.

## Running Simulations

### Option 1: Manual Step-by-Step Execution

You can run the commands one by one manually:

#### Step 1: Minimization and Heating
```bash
sbatch run_min_heat_explorer.slurm RUN1
```

#### Step 2: Equilibration (Hold)
```bash
sbatch run_hold_explorer.slurm RUN1
```

#### Step 3: Production
```bash
./submit_prod.sh RUN1
```

**Note:** `RUN1` is the folder that will store the results. You can change it to whatever you want. Usually we do many runs, so it is convenient to call them `RUN1`, `RUN2`, etc.

---

### Option 2: Automated Pipeline

Instead of running all steps separately, you can use the automated pipeline script:

```bash
./pipeline.sh RUN1 > pipeline_RUN1.log 2>&1 &
```

This will:
- Submit all jobs automatically
- Create dependencies so each job waits for the previous one to finish
- Run in the background
- Log all output to `pipeline_RUN1.log`

#### Monitoring the Pipeline

Check the output of the pipeline:
```bash
tail -f pipeline_RUN1.log
```

Check job status:
```bash
squeue -u $USER
```

---

## File Structure

```
.
├── explorer_scripts/
│   ├── run_min_heat_explorer.slurm
│   ├── run_hold_explorer.slurm
│   ├── submit_prod.sh
│   └── pipeline.sh
├── input/
│   ├── com.inpcrd
│   └── com.prmtop
|   └── min.in
|   └── min2.in
|   └── 02_Heat.in
|   └── 03_Heat2.in
|   └── 03_Heat3.in
|   └── 04_Hold.in
|   └── 05_Prod.in
└── output/
    └── RUN1
```

---

## Troubleshooting

### Check Job Status
```bash
squeue -u $USER
```

### Check Job Output
```bash
# View SLURM log files
cat min_heat_<jobid>.log

# View pipeline log
tail -f pipeline_RUN1.log
```

### Cancel Jobs
```bash
# Cancel specific job
scancel <jobid>

# Cancel all your jobs
scancel -u $USER
```

---

## Notes

- The `pipeline.sh` script uses SLURM job dependencies to ensure jobs run sequentially
- Each step must complete successfully before the next step begins
- All output is logged for debugging
- Jobs can be monitored even after logging out
