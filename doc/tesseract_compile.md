# DiRAC Extreme Scaling (Tesseract) Compile Steps

# Load the required modules

```
module load intel-tools-18
module load gcc
```

# Build the dependencies

It is easiest to copy these commands to a script and then execute it:

```
####################################
# Dependency install directory
####################################
export prefix=/home/z01/z01/auser/benchmark/GridBench/prefix
mkdir -p $prefix

##################
#LIME
##################
cd $prefix
wget http://usqcd-software.github.io/downloads/c-lime/lime-1.3.2.tar.gz
tar xvzf lime-1.3.2.tar.gz
cd lime-1.3.2
./configure --prefix $prefix
make all install

##################
#GMP
##################
cd $prefix
wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2
tar xvjf gmp-6.1.2.tar.bz2
cd gmp-6.1.2
./configure --prefix $prefix
make all install

##################
#MPFR
##################
cd $prefix
wget https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.gz
tar xvzf mpfr-4.0.2.tar.gz
cd mpfr-4.0.2
./configure --prefix $prefix --with-gmp=$prefix
make all install

###############
# FFTW
###############
cd $prefix
wget http://www.fftw.org/fftw-3.3.8.tar.gz
tar xvzf fftw-3.3.8.tar.gz
cd fftw-3.3.8
./configure --prefix $prefix  --enable-avx2 --enable-float --enable-openmp --enable-threads
make all install


##################
#OpenSSL
##################
cd $prefix
wget  https://www.openssl.org/source/openssl-1.1.0l.tar.gz
tar xvzf openssl-1.1.0l.tar.gz
cd openssl-1.1.0l
./config --prefix=$prefix
make all install

# Build Grid benchmark

It is easiest to copy these commands to a script and then execute it:

```
####################################
# Grid directory and support directory
####################################
grid=/home/z01/z01/auser/benchmark/GridBench/GridCompile
prefix=/home/z01/z01/auser/benchmark/GridBench/prefix
mkdir -p $grid

cd $grid
git clone https://paboyle@github.com/paboyle/Grid
cd Grid
git checkout release/dirac-ITT
./bootstrap.sh

#########################
# build for CPU
#########################
mkdir build-cpu
cd build-cpu

hdf5dir=/tessfs1/home/dp008/dp008/paboyle/Modules/hdf5/install

../configure --enable-comms=mpi-auto     \
             --enable-simd=AVX2          \
             --enable-precision=single   \
             --prefix /home/z01/z01/dc-turn1/benchmark/GridBench/prefix-cpu   \
             CXX=g++                     \
             MPICXX=mpiicpc              \
             LDFLAGS="-L$prefix/lib/ -L$hdf5dir/lib/ "\
             CXXFLAGS="-I$prefix/include/ -I$hdf5dir/include/ -std=c++11 -fpermissive"
make -j 24
make install
```



