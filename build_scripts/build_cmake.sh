#!/bin/sh                                                                                                                                                                                                                                    
set -e

export CMAKE_VERSION=$1


CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/cmake

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/cmake
if [ ! -f v$CMAKE_VERSION.tar.gz ]; then
  wget https://github.com/Kitware/CMake/archive/v$CMAKE_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/cmake
export CMAKE_DIR=$TOPDIR/$CMAKE_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/cmake-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR
tar xzf ../../sourcesdir/cmake/v$CMAKE_VERSION.tar.gz

# CMake based stuff *really* don't like in-source builds
mkdir build
cd build

(../CMake-$CMAKE_VERSION/bootstrap --prefix=$CMAKE_DIR --system-curl 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $CMAKE_DIR
make install

mv configure.log $CMAKE_DIR
mv make.log $CMAKE_DIR
cd ../../
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/cmake
mkdir -p $MODULEDIR

echo "local version = \"$CMAKE_VERSION\"" > $MODULEDIR/$CMAKE_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$CMAKE_VERSION.lua
cat ../modulefiles/cmake.lua >> $MODULEDIR/$CMAKE_VERSION.lua
