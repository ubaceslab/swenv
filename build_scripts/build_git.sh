#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

GIT_VERSION=$1

echo "Building Gt for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/git

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/git
if [ ! -f v$GIT_VERSION.tar.gz ]; then
  wget https://github.com/git/git/archive/v$GIT_VERSION.tar.gz
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/git
export GIT_DIR=$TOPDIR/$GIT_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/git-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/git/v$GIT_VERSION.tar.gz
cd git-$GIT_VERSION || exit 1
make configure
./configure --prefix=$GIT_DIR 
make -j ${NPROC:-1} all doc

rm -rf $GIT_DIR
make install install-doc install-html

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/git
mkdir -p $MODULEDIR

echo "local version = \"$GIT_VERSION\"" > $MODULEDIR/$GIT_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$GIT_VERSION.lua
cat ../modulefiles/git.lua >> $MODULEDIR/$GIT_VERSION.lua
