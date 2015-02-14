#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export OPENBLAS_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/openblas

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/openblas
if [ ! -f v$OPENBLAS_VERSION.tar.gz  ]; then
  wget https://github.com/xianyi/OpenBLAS/archive/v$OPENBLAS_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/openblas
export OPENBLAS_DIR=$TOPDIR/$OPENBLAS_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/openblas-XXXXXX`
cd $BUILDDIR
tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/openblas/v$OPENBLAS_VERSION.tar.gz
cd OpenBLAS-$OPENBLAS_VERSION

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $OPENBLAS_DIR
make PREFIX=$OPENBLAS_DIR install
mv make.log $OPENBLAS_DIR

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/openblas
mkdir -p $MODULEDIR

echo "local version = \"$OPENBLAS_VERSION\"" > $MODULEDIR/$OPENBLAS_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$OPENBLAS_VERSION.lua
cat ../modulefiles/openblas.lua >> $MODULEDIR/$OPENBLAS_VERSION.lua
