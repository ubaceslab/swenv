#!/bin/sh
set -e # Fail on first error

export SCONS_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/scons

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/scons
if [ ! -f scons-$SCONS_VERSION.tar.gz ]; then
  wget http://prdownloads.sourceforge.net/scons/scons-$SCONS_VERSION.tar.gz
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/scons
export SCONS_DIR=$TOPDIR/$SCONS_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/scons-XXXXXX`
cd $BUILDDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/scons/scons-$SCONS_VERSION.tar.gz
cd scons-$SCONS_VERSION

rm -rf $SCONS_DIR

(python2.7 setup.py install --prefix=$SCONS_DIR 2>&1 && touch build_cmd_success) | tee build.log
rm build_cmd_success

mv build.log $SCONS_DIR
cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/scons
mkdir -p $MODULEDIR

echo "local version = \"$SCONS_VERSION\"" > $MODULEDIR/$SCONS_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$SCONS_VERSION.lua
cat ../modulefiles/scons.lua >> $MODULEDIR/$SCONS_VERSION.lua
