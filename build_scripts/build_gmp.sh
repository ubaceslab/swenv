#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

GMP_VERSION=$1

echo "Building GMP for ${UBCESLAB_SYSTEMTYPE:?undefined}"

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/gmp

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/gmp
if [ ! -f gmp-$GMP_VERSION.tar.bz2 ]; then
  wget https://ftp.gnu.org/gnu/gmp/gmp-$GMP_VERSION.tar.bz2
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/gmp
export GMP_DIR=$TOPDIR/$GMP_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/gmp-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

tar xjf $UBCESLAB_SWENV_PREFIX/sourcesdir/gmp/gmp-$GMP_VERSION.tar.bz2
cd gmp-$GMP_VERSION || exit 1
./configure --prefix=$GMP_DIR
make -j ${NPROC:-1}
make -j ${NPROC:-1} check

rm -rf $GMP_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true
