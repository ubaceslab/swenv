#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export QUESO_VERSION=master

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/queso


TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/queso
export QUESO_DIR=$TOPDIR/$QUESO_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION:?undefined}/gsl/${GSL_VERSION:?undefined}/glpk/${GLPK_VERSION:?undefined}/boost/${BOOST_VERSION:?undefined}/hdf5/${HDF5_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/queso-XXXXXX`
cd $BUILDDIR

git clone git://github.com/libqueso/queso.git
cd queso

(./bootstrap; ./configure --with-hdf5=$HDF_DIR --without-trilinos --prefix=$QUESO_DIR 2>&1 && touch build_cmd_success) | tee configure.log

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $QUESO_DIR
make install
mv config.log configure.log $QUESO_DIR
mv make.log $QUESO_DIR

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION}/queso
mkdir -p $MODULEDIR

echo "local version = \"$QUESO_VERSION\"" > $MODULEDIR/$QUESO_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$QUESO_VERSION.lua
echo "local gsl_version = \"$GSL_VERSION\"" >> $MODULEDIR/$QUESO_VERSION.lua
echo "local glpk_version = \"$GLPK_VERSION\"" >> $MODULEDIR/$QUESO_VERSION.lua
echo "local boost_version = \"$BOOST_VERSION\"" >> $MODULEDIR/$QUESO_VERSION.lua
echo "local hdf5_version = \"$HDF5_VERSION\"" >> $MODULEDIR/$QUESO_VERSION.lua 
cat ../modulefiles/queso.lua >> $MODULEDIR/$QUESO_VERSION.lua
