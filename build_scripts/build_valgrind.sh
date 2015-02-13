#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

VALGRIND_VERSION=$1

echo "Building Valgrind for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/valgrind

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/valgrind
if [ ! -f valgrind-$VALGRIND_VERSION.tar.bz2 ]; then
  wget http://valgrind.org/downloads/valgrind-$VALGRIND_VERSION.tar.bz2 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/valgrind
export VALGRIND_DIR=$TOPDIR/$VALGRIND_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/valgrind-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

tar -xjf $UBCESLAB_SWENV_PREFIX/sourcesdir/valgrind/valgrind-$VALGRIND_VERSION.tar.bz2
cd valgrind-$VALGRIND_VERSION || exit 1
./configure --prefix=$VALGRIND_DIR 
make -j ${NPROC:-1}

rm -rf $VALGRIND_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/valgrind
mkdir -p $MODULEDIR

echo "local version = \"$VALGRIND_VERSION\"" > $MODULEDIR/$VALGRIND_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$VALGRIND_VERSION.lua
cat ../modulefiles/valgrind.lua >> $MODULEDIR/$VALGRIND_VERSION.lua
