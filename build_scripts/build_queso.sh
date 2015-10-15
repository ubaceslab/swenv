#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export QUESO_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/queso

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/queso
if [ ! -f queso-$QUESO_VERSION.tar.gz ]; then
  wget https://github.com/libqueso/queso/releases/download/v$QUESO_VERSION/queso-$QUESO_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/queso
export QUESO_DIR=$TOPDIR/$QUESO_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION:?undefined}/gsl/${GSL_VERSION:?undefined}/glpk/${GLPK_VERSION:?undefined}/boost/${BOOST_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/queso-XXXXXX`
cd $BUILDDIR

tar -xzf ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/queso/queso-$QUESO_VERSION.tar.gz
cd queso-$QUESO_VERSION
(./configure --without-hdf5 --without-trilinos --prefix=$QUESO_DIR 2>&1 && touch build_cmd_success) | tee configure.log

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
cat ../modulefiles/queso.lua >> $MODULEDIR/$QUESO_VERSION.lua
