#!/bin/sh

set -e # Fail on first error

export PETSC_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/petsc

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/petsc
if [ ! -f petsc-lite-$PETSC_VERSION.tar.gz  ]; then
  wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-$PETSC_VERSION.tar.gz
fi
)

# We need CMake
#module load cmake

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/petsc
export PETSC_PREFIX=$TOPDIR/$PETSC_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION:?undefined}/${BLAS_IMPLEMENTATION:?undefined}/${BLAS_VERSION:?undefined}
export PETSC_ARCH_PREFIX=${COMPILER:?undefined}-${COMPILER_VERSION:?undefined}-${MPI_IMPLEMENTATION:?undefined}-${MPI_VERSION:?undefined}-${BLAS_IMPLEMENTATION:?undefined}-${BLAS_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/petsc-XXXXXX`
cd $BUILDDIR
tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/petsc/petsc-lite-$PETSC_VERSION.tar.gz
cd petsc-$PETSC_VERSION
export PETSC_DIR=$PWD

# Build debug version
export PETSC_INSTALL_DIR=$PETSC_PREFIX/debug
export PETSC_ARCH=$PETSC_ARCH_PREFIX-debug

# On CCR, we need to link to -lpmi
export PETSC_LDFLAGS=""
if [ ${UBCESLAB_SYSTEMTYPE:?undefined} = "ccr" ]; then
   export PETSC_LDFLAGS="-lpmi"
fi

python2.7 ./config/configure.py  \
--with-make-np=${NPROC:?4} \
--prefix=$PETSC_INSTALL_DIR \
--with-shared-libraries=1 \
--with-cxx-dialect=C++11 \
--with-mpi-dir=${MPI_DIR:?undefined} \
--with-mumps=true --download-mumps=1 \
--with-metis=true --download-metis=1 \
--with-parmetis=true --download-parmetis=1 \
--with-superlu=true --download-superlu=1 \
--with-superludir=true --download-superlu_dist=1 \
--with-blacs=true --download-blacs=1 \
--with-scalapack=true --download-scalapack=1 \
--with-hypre=true --download-hypre=1 \
--with-blas-lib=[${BLAS_LIBS:?undefined}] \
--with-lapack-lib=[${LAPACK_LIBS:?undefined}] --LDFLAGS=$PETSC_LDFLAGS
make clean
(make 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

make install
mv $PETSC_ARCH/lib/petsc/conf/configure.log $PETSC_INSTALL_DIR
mv $PETSC_ARCH/lib/petsc/conf/make.log $PETSC_INSTALL_DIR

# Build opt version
export PETSC_INSTALL_DIR=$PETSC_PREFIX/opt
export PETSC_ARCH=$PETSC_ARCH_PREFIX-opt

# Wipe out old install
rm -rf $PETSC_INSTALL_DIR

# PETSc wants the directory to be there
mkdir -p $PETSC_INSTALL_DIR

python2.7 ./config/configure.py  \
--with-make-np=${NPROC:?4} \
--prefix=$PETSC_INSTALL_DIR \
--with-debugging=false --COPTFLAGS='-O3 -mavx' --CXXOPTFLAGS='-O3 -mavx' --FOPTFLAGS='-O3' \
--with-shared-libraries=1 \
--with-cxx-dialect=C++11 \
--with-mpi-dir=${MPI_DIR:?undefined} \
--with-mumps=true --download-mumps=1 \
--with-metis=true --download-metis=1 \
--with-parmetis=true --download-parmetis=1 \
--with-superlu=true --download-superlu=1 \
--with-superludir=true --download-superlu_dist=1 \
--with-blacs=true --download-blacs=1 \
--with-scalapack=true --download-scalapack=1 \
--with-hypre=true --download-hypre=1 \
--with-blas-lib=[${BLAS_LIBS:?undefined}] \
--with-lapack-lib=[${LAPACK_LIBS:?undefined}] --LDFLAGS=$PETSC_LDFLAGS
make clean

(make 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

make install
mv $PETSC_ARCH/lib/petsc/conf/configure.log $PETSC_INSTALL_DIR
mv $PETSC_ARCH/lib/petsc/conf/make.log $PETSC_INSTALL_DIR

cd $UBCESLAB_SWENV_PREFIX
#rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION}/petsc
mkdir -p $MODULEDIR

# Debug version
echo "local version = \"$PETSC_VERSION\"" > $MODULEDIR/$PETSC_VERSION-debug.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$PETSC_VERSION-debug.lua
echo "local petsc_type = \"debug\"" >> $MODULEDIR/$PETSC_VERSION-debug.lua
echo "local blas_implementation = \"$BLAS_IMPLEMENTATION\"" >> $MODULEDIR/$PETSC_VERSION-debug.lua
echo "local blas_version = \"$BLAS_VERSION\"" >> $MODULEDIR/$PETSC_VERSION-debug.lua
cat ../modulefiles/petsc.lua >> $MODULEDIR/$PETSC_VERSION-debug.lua

# opt version
echo "local version = \"$PETSC_VERSION\"" > $MODULEDIR/$PETSC_VERSION-opt.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$PETSC_VERSION-opt.lua
echo "local petsc_type = \"opt\"" >> $MODULEDIR/$PETSC_VERSION-opt.lua
echo "local blas_implementation = \"$BLAS_IMPLEMENTATION\"" >> $MODULEDIR/$PETSC_VERSION-opt.lua
echo "local blas_version = \"$BLAS_VERSION\"" >> $MODULEDIR/$PETSC_VERSION-opt.lua
cat ../modulefiles/petsc.lua >> $MODULEDIR/$PETSC_VERSION-opt.lua
