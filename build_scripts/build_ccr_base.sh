#!/bin/sh                                                                                                                                                                                                                                    
set -e

echo "Setting up base modules for ${UBCESLAB_SYSTEMTYPE:?undefined} environment."

export CURRENT_DIR=$PWD

MODULEDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/lmod/modulefiles

mkdir -p $MODULEDIR

export GCC_VERSION=4.9.2
export MPI_VERSION=5.0.2

mkdir -p $MODULEDIR/gcc-ubceslab
echo "local version = \"$GCC_VERSION\"" > $MODULEDIR/gcc-ubceslab/$GCC_VERSION.lua
echo "local derived_modules_dir = \"$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles\"" >> $MODULEDIR/gcc-ubceslab/$GCC_VERSION.lua
cat ../modulefiles/gcc_ccr.lua >> $MODULEDIR/gcc-ubceslab/$GCC_VERSION.lua

mkdir -p $MODULEDIR/intel-mpi-ubceslab
echo "local compiler = \"gcc\"" > $MODULEDIR/intel-mpi-ubceslab/$MPI_VERSION.lua
echo "local compiler_version = \"$GCC_VERSION\"" >> $MODULEDIR/intel-mpi-ubceslab/$MPI_VERSION.lua
echo "local mpi_version = \"$MPI_VERSION\"" >> $MODULEDIR/intel-mpi-ubceslab/$MPI_VERSION.lua
echo "local derived_modules_dir = \"$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles\"" >> $MODULEDIR/intel-mpi-ubceslab/$MPI_VERSION.lua
cat ../modulefiles/intel_mpi_ccr.lua >> $MODULEDIR/intel-mpi-ubceslab/$MPI_VERSION.lua

echo "Done!"
