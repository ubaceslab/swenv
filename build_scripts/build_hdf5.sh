#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export HDF5_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/hdf5

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/hdf5
if [ ! -f hdf5-$HDF5_VERSION.tar.bz2  ]; then
  wget http://www.hdfgroup.org/ftp/HDF5/current18/src/hdf5-$HDF5_VERSION.tar.bz2 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/hdf5
export HDF5_DIR=$TOPDIR/$HDF5_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/hdf5-XXXXXX`
cd $BUILDDIR
tar xjf $UBCESLAB_SWENV_PREFIX/sourcesdir/hdf5/hdf5-$HDF5_VERSION.tar.bz2
cd hdf5-$HDF5_VERSION

(./configure --prefix=$HDF5_DIR --enable-shared --enable-fortran --enable-cxx 2>&1 && touch build_cmd_success) | tee configure.log

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $HDF5_DIR
make install
mv config.log configure.log $HDF5_DIR
mv make.log $HDF5_DIR

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/hdf5
mkdir -p $MODULEDIR

echo "local version = \"$HDF5_VERSION\"" > $MODULEDIR/$HDF5_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$HDF5_VERSION.lua
cat ../modulefiles/hdf5.lua >> $MODULEDIR/$HDF5_VERSION.lua
