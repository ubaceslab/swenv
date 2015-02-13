#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

GDB_VERSION=$1

echo "Building GDB for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/gdb

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/gdb
if [ ! -f gdb-$GDB_VERSION.tar.gz ]; then
  wget https://ftp.gnu.org/gnu/gdb/gdb-$GDB_VERSION.tar.gz
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/gdb
export GDB_DIR=$TOPDIR/$GDB_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/gdb-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/gdb/gdb-$GDB_VERSION.tar.gz
cd gdb-$GDB_VERSION || exit 1
./configure --prefix=$GDB_DIR 
make -j ${NPROC:-1}

rm -rf $GDB_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/gdb
mkdir -p $MODULEDIR

echo "local version = \"$GDB_VERSION\"" > $MODULEDIR/$GDB_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$GDB_VERSION.lua
cat ../modulefiles/gdb.lua >> $MODULEDIR/$GDB_VERSION.lua
