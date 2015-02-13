#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export GSL_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/gsl

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/gsl
if [ ! -f gsl-$GSL_VERSION.tar.gz ]; then
  wget http://gnu.mirrorcatalogs.com/gsl/gsl-$GSL_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/gsl
export GSL_DIR=$TOPDIR/$GSL_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/gsl-XXXXXX`
cd $BUILDDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/gsl/gsl-$GSL_VERSION.tar.gz
cd gsl-$GSL_VERSION

(CFLAGS="-g -O3" ./configure --prefix=$GSL_DIR 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $GSL_DIR
make install
mv config.log configure.log $GSL_DIR
mv make.log $GSL_DIR
cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/gsl
mkdir -p $MODULEDIR

echo "local version = \"$GSL_VERSION\"" > $MODULEDIR/$GSL_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$GSL_VERSION.lua
cat ../modulefiles/gsl.lua >> $MODULEDIR/$GSL_VERSION.lua
