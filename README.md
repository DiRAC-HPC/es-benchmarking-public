# DiRAC Benchmarks (Extreme Scaling)

This repository contains data and analysis for benchmarking the [Grid](https://github.com/paboyle/Grid) data parallel C++ mathematical object library on the [DiRAC](http://www.dirac.ac.uk) systems.

## Grid

### Obtaining the source code

The source code can be obtained from the public Github repository:

   - https://github.com/paboyle/Grid

All benchmarks were run using the source from the `dirac-ITT` branch. The typical process for checking out the code would be:

```
git clone https://paboyle@github.com/paboyle/Grid
cd Grid
git checkout release/dirac-ITT
```

### Compiling GRID

General information on compiling Grid can be found at:

   - https://github.com/paboyle/Grid

with specific instructions for the benchmark at:

  - https://github.com/paboyle/Grid/wiki/Dirac-ITT-Benchmarks

The build process for each of the systems we have run on can be found in the [doc/](doc/) subfolder.

### Running Grid benchmark

Information on running the DiRAC Grid benchamrk can be found at:

   - https://github.com/paboyle/Grid/wiki/Dirac-ITT-Benchmarks

Note that the MPI task distribution across problem dimensions used at different node counts
follows the following rules:

   - Distribute as evenly as possible
   - Larger numbers should be in the left-most dimension
   
This leads to the following distributions when using 2 MPI tasks per node (usually best
on two-socket nodes):

   - 1 node (2 MPI tasks): 2.1.1.1
   - 2 nodes (4 MPI tasks): 2.2.1.1
   - 4 nodes (8 MPI tasks): 2.2.2.1
   - 8 nodes (16 MPI tasks): 2.2.2.2
   - 16 nodes (32 MPI tasks): 4.2.2.2
   - 32 nodes (64 MPI tasks): 4.4.2.2
   - etc.

The benchmark has been run on the following systems:

| System | Node | Interconnect | Combinations |
|--------|------|--------------|--------------|
| DiRAC Memory Intensive (COSMA7) | 2x Intel Xeon Skylake Gold 5120, 512 GiB DDR4 | Mellanox EDR | Intel 2018; Intel MPI 2018 |
| DiRAC Extreme Scaling (Tesseract) | 2x Intel Xeon Skylake Silver 4112, 92 GiB DDR4 | Intel OPA | Intel 2018; Intel MPI 2018 | 

Output from benchmark runs can be found in the [results/](results/) subdirectory.

### Evaluating benchmark performance

Information on evaluating performance can be found at:

   - https://github.com/paboyle/Grid/wiki/Dirac-ITT-Benchmarks

Scripts we have used to extract performance and plot comparisons can be found in the [analysis/](analysis/) subdirectory.

## Further information

If you want further information on these benchmarks, please contact the DiRAC Helpdesk at: dirac-support@epcc.ed.ac.uk:1

