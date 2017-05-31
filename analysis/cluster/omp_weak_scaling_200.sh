#!/bin/bash

#------------------------------ weak scaling ---------------------------------#

sdir=slurm_runs_weak

n_iter=200
n_row=1
n_proc=1

outfile=omp_weak_x_${n_iter}_${n_row}_${n_proc}_x.dat
echo "Output file name : " $outfile

mkdir -p outputs

rm -f outputs/$outfile
rm -f out_*.pgm
rm -f out_*.bmp

cd ../../src 			# go there to compile
make omp
cd ../analysis/cluster	# come back here to run

### problem size doubles when number of processors doubles
### --> N multiplied by sqrt(2)

n_thread=1
for N in 724 1024 1448 2048 2896 4096 5793
do
	echo "Going to run several times mandel_omp, with parameters N = $N, \
max iter = $n_iter, rows = $n_row, procs = $n_proc, threads = $n_thread)"
    
	sbatch ${sdir}/run_omp_weak_${N}_${n_iter}_${n_row}_${n_proc}_${n_thread}.slurm

    ((n_thread = n_thread * 2))
done

#-----------------------------------------------------------------------------#
