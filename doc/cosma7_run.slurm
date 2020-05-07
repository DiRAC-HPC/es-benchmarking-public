#!/bin/bash -l

#To change the number of nodes, just change ntasks (to 2x number of nodes)
#SBATCH --ntasks 64
#SBATCH --cpus-per-task=14
#SBATCH -J Grid_ITT
#SBATCH -p cosma7
#SBATCH -A ds007
#SBATCH --exclusive
#SBATCH -t 1:00:0

module purge
#load the modules used to build your program.
module load intel_comp/2018
module load intel_mpi/2018
module load parallel_hdf5

echo "Listing modules:"
module list

prefix=$HOME/benchmark/GridBench/prefix
grid=$HOME/benchmark/GridBench/prefix-cpu

export LD_LIBRARY_PATH=$prefix/lib:$LD_LIBRARY_PATH

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically
#   using threading.
export OMP_NUM_THREADS=14
export I_MPI_PIN=1
export KMP_HW_SUBSET=28c,1t 

nodes=$(expr $SLURM_NTASKS / 2)
# mpi must multiply to the number of mpi ranks
mpi="${SLURM_NTASKS}.1.1.1"
shm=1024
c=2
thr=2
timestamp=$(date '+%Y%m%d%H%M')

# Launch the parallel job - special case for single node.
if [ $nodes -eq 1 ] 
then
mpirun -np $SLURM_NTASKS ./omp_bind.sh $grid/bin/Benchmark_ITT --comms-sequential --cacheblocking ${c}.${c}.${c}.${c} --mpi ${mpi} --shm ${shm} 2>&1 > grid_itt_bench_${nodes}nodes_${mpi}_shm${shm}_cache${c}_sequential_${thr}thr_${timestamp}.out
else
mpirun -np $SLURM_NTASKS ./omp_bind.sh $grid/bin/Benchmark_ITT --comms-threads ${thr} --comms-sequential --cacheblocking ${c}.${c}.${c}.${c} --mpi ${mpi} --shm ${shm} 2>&1 > grid_itt_bench_${nodes}nodes_${mpi}_shm${shm}_cache${c}_sequential_${thr}thr_${timestamp}.out
fi
