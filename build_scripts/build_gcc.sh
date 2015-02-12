#!/bin/sh                                                                                                                                                                                                                                    
set -e

echo "Building all GCC for ${UBCESLAB_SYSTEMTYPE:?undefined}"

GCC_VERSION=$1
GMP_VERSION=$2
MPFR_VERSION=$3
MPC_VERSION=$4

CURRENT_DIR=$PWD

export GCC_MAJOR=`echo $GCC_VERSION | cut -d . -f 1`
export GCC_MINOR=`echo $GCC_VERSION | cut -d . -f 2`
export GCC_MICRO=`echo $GCC_VERSION | cut -d . -f 3`

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/gcc

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/gcc
if [ ! -d gcc-$GCC_VERSION-src ]; then
  svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_$GCC_MAJOR\_$GCC_MINOR\_$GCC_MICRO\_release ./gcc-$GCC_VERSION-src
fi
)

GMP_DIR=$UBCESLAB_SWENV_PREFIX/libs/gmp/$GMP_VERSION
MPFR_DIR=$UBCESLAB_SWENV_PREFIX/libs/mpfr/$MPFR_VERSION

#PB: we only need to include MPC for gcc versions >= 4.5.x
MPC_DIR=$UBCESLAB_SWENV_PREFIX/libs/mpc/$MPC_VERSION

if [ ! -d $GMP_DIR ]; then
  echo "Missing GMP install!"
  echo $GMP_DIR
  exit
fi

if [ ! -d $MPFR_DIR ]; then
  echo "Missing MPFR install!"
  echo $MPFR_DIR
  exit
fi

if [ ! -d $MPC_DIR ]; then
  echo "Missing MPC install!"
  echo $MPC_DIR 
  exit
fi

if [ x$GCC_MAJOR = x3 ]; then
  enablelangs=c,c++
else
  enablelangs=c,c++,fortran
fi

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/gcc
export GCC_DIR=$TOPDIR/$GCC_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/gcc-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

#PB: Need for the build $GCC_VERSION. Specifying the directory not enough apparently...
#PB: This doesn't seem to stick for some reason. To get a successful build, I had to
#    do this within my shell. =/
export LD_LIBRARY_PATH=$MPC_DIR/lib:$MPFR_DIR/lib:$GMP_DIR/lib:$LD_LIBRARY_PATH

LD_LIBRARY_PATH=$MPC_DIR/lib:$MPFR_DIR/lib:$GMP_DIR/lib:$LD_LIBRARY_PATH &&
$UBCESLAB_SWENV_PREFIX/sourcesdir/gcc/gcc-$GCC_VERSION-src/configure \
--prefix=$GCC_DIR \
--with-gmp=$GMP_DIR \
--with-mpfr=$MPFR_DIR \
--with-mpc=$MPC_DIR \
--disable-multilib \
--enable-languages=$enablelangs \
--enable-lto 

make -j ${NPROC:-1}

rm -rf $GCC_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR

MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/gcc
mkdir -p $MODULEDIR

# Build up gcc module
echo "local version = \"$GCC_VERSION\"" > $MODULEDIR/$GCC_VERSION.lua
echo "local gmp_version = \"$GMP_VERSION\"" >> $MODULEDIR/$GCC_VERSION.lua
echo "local mpfr_version = \"$MPFR_VERSION\"" >> $MODULEDIR/$GCC_VERSION.lua                                                                                                                                                         
echo "local mpc_version = \"$MPC_VERSION\"" >> $MODULEDIR/$GCC_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$GCC_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$GCC_VERSION.lua
echo "local derived_modules_dir = \"$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles\"" >> $MODULEDIR/$GCC_VERSION.lua
cat ../modulefiles/gcc.lua >> $MODULEDIR/$GCC_VERSION.lua
