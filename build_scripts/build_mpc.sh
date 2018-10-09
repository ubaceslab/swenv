#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

GMP_VERSION=$3
MPFR_VERSION=$2
MPC_VERSION=$1

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/mpc

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/mpc
if [ ! -f mpc-$MPC_VERSION.tar.gz ]; then
  wget https://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/mpc
export MPC_DIR=$TOPDIR/$MPC_VERSION

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/mpc-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

export GMP_DIR=$UBCESLAB_SWENV_PREFIX/libs/gmp/$GMP_VERSION
export MPFR_DIR=$UBCESLAB_SWENV_PREFIX/libs/mpfr/$MPFR_VERSION

tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/mpc/mpc-$MPC_VERSION.tar.gz
cd mpc-$MPC_VERSION || exit 1
./configure --prefix=$MPC_DIR --with-gmp=$GMP_DIR --with-mpfr=$MPFR_DIR
make -j ${NPROC:-1}
make -j ${NPROC:-1} check

rm -rf $MPC_DIR
make install

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true
