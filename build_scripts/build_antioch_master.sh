#!/bin/sh
set -e # Fail on first error

export ANTIOCH_VERSION=master

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/antioch

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/antioch
if [ ! -d antioch-$ANTIOCH_VERSION ]; then
   git clone git://github.com/libantioch/antioch.git ./antioch-$ANTIOCH_VERSION
fi
   cd antioch-$ANTIOCH_VERSION
   git pull origin master
   ./bootstrap
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/antioch
export ANTIOCH_DIR=$TOPDIR/$ANTIOCH_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/gsl/${GSL_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/antioch-XXXXXX`
cd $BUILDDIR


($UBCESLAB_SWENV_PREFIX/sourcesdir/antioch/antioch-$ANTIOCH_VERSION/configure --prefix=$ANTIOCH_DIR 2>&1 && touch build_cmd_success) | tee configure.log

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

(make -j ${NPROC:-1} check 2>&1 touch check_cmd_sucess) | tee check.log

rm -rf $ANTIOCH_DIR
make install
mv config.log configure.log $ANTIOCH_DIR
mv make.log check.log $ANTIOCH_DIR

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/antioch
mkdir -p $MODULEDIR

echo "local version = \"$ANTIOCH_VERSION\"" > $MODULEDIR/$ANTIOCH_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$ANTIOCH_VERSION.lua
echo "local gsl_version = \"$GSL_VERSION\"" >> $MODULEDIR/$ANTIOCH_VERSION.lua
cat ../modulefiles/antioch.lua >> $MODULEDIR/$ANTIOCH_VERSION.lua
