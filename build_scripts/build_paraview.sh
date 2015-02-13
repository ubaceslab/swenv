#!/bin/sh                                                                                                                                                                                                                                     
set -e

export PARAVIEW_VERSION=$1

echo "Building all paraview for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/paraview

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/paraview

if [ ! -f paraview-$PARAVIEW_VERSION.tar.gz ]; then
  echo "Couldn't find ParaView tarball $UBCESLAB_SWENV_PREFIX/sourcesdir/paraview/paraview-$PARAVIEW_VERSION.tar.gz"
  echo "Need to download from http://www.paraview.org and movie it to the path above."
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/paraview
export PARAVIEW_DIR=$TOPDIR/paraview-$PARAVIEW_VERSION
rm -rf $PARAVIEW_DIR

# For the ParaView tar ball, we just need to untar in the right place
mkdir -p $TOPDIR
cd $TOPDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/paraview/paraview-$PARAVIEW_VERSION.tar.gz
mkdir -p $TOPDIR/paraview-$PARAVIEW_VERSION/
mv ParaView-$PARAVIEW_VERSION-Linux-64bit $TOPDIR/$PARAVIEW_VERSION


cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/paraview
mkdir -p $MODULEDIR

echo "local version = \"$PARAVIEW_VERSION\"" > $MODULEDIR/$PARAVIEW_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$PARAVIEW_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$PARAVIEW_VERSION.lua
cat ../modulefiles/paraview.lua >> $MODULEDIR/$PARAVIEW_VERSION.lua
