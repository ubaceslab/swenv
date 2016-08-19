#!/bin/sh
set -e # Fail on first error

DOXYGEN_VERSION=$1

echo "Building Doxygen for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/doxygen

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/doxygen
if [ ! -f doxygen-$DOXYGEN_VERSION.src.tar.gz ]; then
  wget http://ftp.stack.nl/pub/users/dimitri/doxygen-$DOXYGEN_VERSION.src.tar.gz
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/doxygen
export DOXYGEN_DIR=$TOPDIR/$DOXYGEN_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/doxygen-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/doxygen/doxygen-$DOXYGEN_VERSION.src.tar.gz
cd doxygen-$DOXYGEN_VERSION || exit 1

cmake -DCMAKE_INSTALL_PREFIX:PATH=$DOXYGEN_DIR
make -j ${NPROC:-1}

rm -rf $DOXYGEN_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/doxygen
mkdir -p $MODULEDIR

echo "local version = \"$DOXYGEN_VERSION\"" > $MODULEDIR/$DOXYGEN_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$DOXYGEN_VERSION.lua
cat ../modulefiles/doxygen.lua >> $MODULEDIR/$DOXYGEN_VERSION.lua
