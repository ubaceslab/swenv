#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

EMACS_VERSION=$1

echo "Building EMACS for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/emacs

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/emacs
if [ ! -f emacs-$EMACS_VERSION.tar.gz ]; then
  wget https://ftp.gnu.org/gnu/emacs/emacs-$EMACS_VERSION.tar.gz
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/emacs
export EMACS_DIR=$TOPDIR/$EMACS_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/emacs-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/emacs/emacs-$EMACS_VERSION.tar.gz
cd emacs-$EMACS_VERSION || exit 1
./configure --prefix=$EMACS_DIR --with-gif=no --with-tiff=no --without-gsettings
make -j ${NPROC:-1}
make -j ${NPROC:-1} check

rm -rf $EMACS_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/emacs
mkdir -p $MODULEDIR

echo "local version = \"$EMACS_VERSION\"" > $MODULEDIR/$EMACS_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$EMACS_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$EMACS_VERSION.lua
cat ../modulefiles/emacs.lua >> $MODULEDIR/$EMACS_VERSION.lua
