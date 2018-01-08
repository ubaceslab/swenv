#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

echo "Building MPFR for ${UBCESLAB_SYSTEMTYPE:?undefined}"

GMP_VERSION=$2
MPFR_VERSION=$1

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/mpfr

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/mpfr
if [ ! -f mpfr-$MPFR_VERSION.tar.bz2 ]; then
  wget http://www.mpfr.org/mpfr-$MPFR_VERSION/mpfr-$MPFR_VERSION.tar.bz2
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/mpfr
export MPFR_DIR=$TOPDIR/$MPFR_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/mpfr-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

export GMP_DIR=$UBCESLAB_SWENV_PREFIX/libs/gmp/$GMP_VERSION

tar xjf $UBCESLAB_SWENV_PREFIX/sourcesdir/mpfr/mpfr-$MPFR_VERSION.tar.bz2
cd mpfr-$MPFR_VERSION || exit 1
./configure --prefix=$MPFR_DIR --with-gmp=$GMP_DIR
make -j ${NPROC:-1}
make -j ${NPROC:-1} check

rm -rf $MPFR_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true
