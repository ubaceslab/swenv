#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export GLPK_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/glpk

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/glpk
if [ ! -f glpk-$GLPK_VERSION.tar.gz ]; then
  wget http://ftp.gnu.org/gnu/glpk/glpk-$GLPK_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/glpk
export GLPK_DIR=$TOPDIR/$GLPK_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/glpk-XXXXXX`
cd $BUILDDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/glpk/glpk-$GLPK_VERSION.tar.gz
cd glpk-$GLPK_VERSION

(./configure --prefix=$GLPK_DIR 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $GLPK_DIR
make install
mv config.log configure.log $GLPK_DIR
mv make.log $GLPK_DIR
cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/glpk
mkdir -p $MODULEDIR

echo "local version = \"$GLPK_VERSION\"" > $MODULEDIR/$GLPK_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$GLPK_VERSION.lua
cat ../modulefiles/glpk.lua >> $MODULEDIR/$GLPK_VERSION.lua
