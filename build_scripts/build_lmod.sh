#!/bin/sh                                                                                                                                                                                                                                    
set -e

export LMOD_VERSION=$1

echo "Building Lmod for ${UBCESLAB_SYSTEMTYPE:?undefined}"

export CURRENT_DIR=$PWD

# Check for special lua that's needed
if [ ! -d $UBCESLAB_SWENV_PREFIX/apps/lua/lua-current/bin ]; then
   echo "Error: Couldn't find special Lmod version of Lua"
   exit 1
fi

export PATH=$UBCESLAB_SWENV_PREFIX/apps/lua/lua-current/bin:$PATH

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/lmod

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/lmod

if [ ! -f $LMOD_VERSION.tar.gz ]; then
   wget https://github.com/TACC/Lmod/archive/$LMOD_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/lmod
export LMOD_DIR=$TOPDIR/lmod-$LMOD_VERSION

#Wipeout previous version
rm -rf $LMOD_DIR

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/lmod-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR
tar -xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/lmod/$LMOD_VERSION.tar.gz
cd Lmod-$LMOD_VERSION
(./configure --prefix $LMOD_DIR 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $LMOD_DIR
make install

mv configure.log $LMOD_DIR
mv make.log $LMOD_DIR
cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $TOPDIR
ln -s lmod-$LMOD_VERSION lmod-current

cd $CURRENT_DIR
cp ./lmod_profile $LMOD_DIR/lmod/lmod/init/ubceslab_profile
