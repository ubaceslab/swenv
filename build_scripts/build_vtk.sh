#!/bin/sh
set -e # Fail on first error

export VTK_VERSION=$1

export VTK_MAJOR=`echo $VTK_VERSION | cut -d . -f 1`
export VTK_MINOR=`echo $VTK_VERSION | cut -d . -f 2`
export VTK_MICRO=`echo $VTK_VERSION | cut -d . -f 3`

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/vtk

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/vtk
if [ ! -f v$VTK_VERSION.tar.gz  ]; then
  wget https://github.com/Kitware/VTK/archive/v$VTK_VERSION.tar.gz
fi
)

# We need CMake
#module load cmake

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/vtk
export VTK_DIR=$TOPDIR/$VTK_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/vtk-XXXXXX`
cd $BUILDDIR
tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/vtk/v$VTK_VERSION.tar.gz

# For GCC >= 6.X.Y, VTK 6.3.0 and 7.0.0 have a bug in their build system
#export COMPILER_MAJOR_VERSION=`echo ${COMPILER_VERSION:?undefined} | cut -d . -f 1`
#echo $COMPILER_MAJOR_VERSION
#if [ "$COMPILER_MAJOR_VERSION" -gt 5 ]; then
#  cd VTK-$VTK_VERSION
#  patch -p0 < $CURRENT_DIR/vtk.patch
#  cd ..
#fi

# CMake builds *really* don't like in-source builds
mkdir -p build
cd build

(cmake \
-D BUILD_SHARED_LIBS:BOOL=ON \
-D CMAKE_INSTALL_PREFIX:PATH=$VTK_DIR \
-D CMAKE_BUILD_TYPE:STRING=Release \
-D VTK_Group_MPI:BOOL=ON \
$BUILDDIR/VTK-$VTK_VERSION 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success
(make -j ${NPROC:-1} all 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success
rm -rf $VTK_DIR
make install

mv CMakeCache.txt configure.log $VTK_DIR
mv make.log $VTK_DIR


cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION}/vtk
mkdir -p $MODULEDIR

echo "local version = \"$VTK_VERSION\"" > $MODULEDIR/$VTK_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$VTK_VERSION.lua
echo "local version_major = \"$VTK_MAJOR\"" >> $MODULEDIR/$VTK_VERSION.lua
echo "local version_minor = \"$VTK_MINOR\"" >> $MODULEDIR/$VTK_VERSION.lua
echo "local name = \"vtk\"" >> $MODULEDIR/$VTK_VERSION.lua

cat ../modulefiles/vtk.lua >> $MODULEDIR/$VTK_VERSION.lua
