#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export MPICH_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/mpich

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/mpich
if [ ! -f mpich-$MPICH_VERSION.tar.gz  ]; then
  wget http://www.mpich.org/static/downloads/$MPICH_VERSION/mpich-$MPICH_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/mpich
export MPICH_DIR=$TOPDIR/$MPICH_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/mpich-XXXXXX`
cd $BUILDDIR
tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/mpich/mpich-$MPICH_VERSION.tar.gz
cd mpich-$MPICH_VERSION

# MPICH build system errors out if F90 is set (WEAK)
export F90bak=$F90
unset F90
(./configure --prefix=$MPICH_DIR --enable-shared 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success
export F90=$F90bak
unset F90bak
(make -j ${NPROC:=1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $MPICH_DIR
make install
mv config.log configure.log $MPICH_DIR
mv make.log $MPICH_DIR

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/mpich
mkdir -p $MODULEDIR

echo "local version = \"$MPICH_VERSION\"" > $MODULEDIR/$MPICH_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$MPICH_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$MPICH_VERSION.lua
cat ../modulefiles/mpich.lua >> $MODULEDIR/$MPICH_VERSION.lua
