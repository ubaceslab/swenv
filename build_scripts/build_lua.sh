#!/bin/sh                                                                                                                                                                                                                                    
set -e

export LUA_VERSION=$1

echo "Building all lua for ${UBCESLAB_SYSTEMTYPE:?undefined}"

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/lua

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/lua

if [ ! -f lua-$LUA_VERSION.tar.gz ]; then
   wget --output-document=lua-$LUA_VERSION.tar.gz http://sourceforge.net/projects/lmod/files/lua-$LUA_VERSION.tar.gz/download
fi
)


TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/lua
export LUA_DIR=$TOPDIR/lua-$LUA_VERSION

#Wipe out previous version
rm -rf $LUA_DIR

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/lua-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/lua/lua-$LUA_VERSION.tar.gz
cd lua-$LUA_VERSION
(./configure --prefix $LUA_DIR 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $LUA_DIR
make install
mv configure.log $LUA_DIR
mv make.log $LUA_DIR

cd $TOPDIR
ln -s lua-$LUA_VERSION lua-current

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true
