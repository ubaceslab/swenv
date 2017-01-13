#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export CPPUNIT_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/cppunit

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/cppunit
if [ ! -f cppunit-$CPPUNIT_VERSION.tar.gz ]; then
  wget http://dev-www.libreoffice.org/src/cppunit-$CPPUNIT_VERSION.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/cppunit
export CPPUNIT_DIR=$TOPDIR/$CPPUNIT_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/cppunit-XXXXXX`
cd $BUILDDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/cppunit/cppunit-$CPPUNIT_VERSION.tar.gz
cd cppunit-$CPPUNIT_VERSION

(CFLAGS="-g" ./configure --prefix=$CPPUNIT_DIR 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $CPPUNIT_DIR
make install
mv config.log configure.log $CPPUNIT_DIR
mv make.log $CPPUNIT_DIR
cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/cppunit
mkdir -p $MODULEDIR

echo "local version = \"$CPPUNIT_VERSION\"" > $MODULEDIR/$CPPUNIT_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$CPPUNIT_VERSION.lua
echo "local name = \"cppunit\"" >> $MODULEDIR/$CPPUNIT_VERSION.lua
cat ../modulefiles/cppunit.lua >> $MODULEDIR/$CPPUNIT_VERSION.lua
