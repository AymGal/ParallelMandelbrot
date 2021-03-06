#!/bin/bash

rm -rf timings_omp.dat
rm -rf timings_omp.png
rm -rf out_*.pgm
rm -rf out_*.bmp

cd ../../src # go there to compile
make omp
cd ../analysis/shell # return here to analyse

n_threads=4
for N in 128 256 512 1024 2048 4096 8192
do
    export OMP_NUM_THREADS=$n_threads
    echo "Running mandel_omp with $n_threads threads on a grid of size $N"
    ../../src/mandel_omp $N 200 >> timings_omp.dat
done

gnuplot << EOF
set terminal png
set output 'timings_omp.png'
set multiplot layout 1,1
set key off

set logscale x
set logscale y
set xlabel "N [-]"
set ylabel "time [s]"
plot "timings_omp.dat" using 1:7 with lp
EOF

open timings_omp.png
