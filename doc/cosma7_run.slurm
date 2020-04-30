#!/bin/bash -l

#SBATCH --ntasks 448
#SBATCH -J Grid_ITT
#SBATCH -p cosma7
#SBATCH -A ds007
#SBATCH --exclusive
#SBATCH -t 12:0:0

module purge
#load the modules used to build your program.
module load intel_comp/2018
module load intel_mpi/2018
module load gnu_comp
module load parallel_hdf5

prefix=/cosma7/data/dr002/dc-turn1/benchmark/GridBench/prefix
grid=/cosma7/data/dr002/dc-turn1/benchmark/GridBench/prefix-cpu

export LD_LIBRARY_PATH=$prefix/lib:$LD_LIBRARY_PATH

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically
#   using threading.
export OMP_NUM_THREADS=14
export I_MPI_PIN=1
export KMP_HW_SUBSET=28c,1t 

nodes=16
# mpi must multiply to the number of mpi ranks
mpi="4.2.2.2"
rankpernode=2
totrank=$(( nodes * rankpernode ))
timestamp=$(date '+%Y%m%d%H%M')

# Launch the parallel job
mpirun -n ${totrank} -ppn ${rankpernode} ./omp_bind.sh $grid/bin/Benchmark_ITT --mpi ${mpi} --shm 1024 > grid_itt_bench_${nodes}nodes_${timestamp}.out
