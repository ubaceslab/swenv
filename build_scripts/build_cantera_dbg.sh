#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export CANTERA_VERSION=$1

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/cantera

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/cantera
if [ ! -f cantera-$CANTERA_VERSION.tar.gz ]; then
  wget https://github.com/Cantera/cantera/releases/download/v2.1.2/cantera-2.1.2.tar.gz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/cantera-dbg
export CANTERA_DIR=$TOPDIR/$CANTERA_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/boost/${BOOST_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/cantera-XXXXXX`
cd $BUILDDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/cantera/cantera-$CANTERA_VERSION.tar.gz
cd cantera-$CANTERA_VERSION

sed -i 's/::finite(tmp)/finite(tmp)/' src/base/checkFinite.cpp
sed -i 's/::isnan(tmp)/std::isnan(tmp)/' src/base/checkFinite.cpp
sed -i 's/::isinf(tmp)/std::isinf(tmp)/' src/base/checkFinite.cpp

rm -rf $CANTERA_DIR

(scons -j ${NPROC:-1} build prefix=$CANTERA_DIR python_package=none boost_inc_dir=$BOOST_DIR/include boost_lib_dir=$BOOST_DIR/lib debug=yes optimize=no cxx_flags="-g -O0 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC" 2>&1 && touch build_cmd_success) | tee configure.log
rm build_cmd_success

(scons -j ${NPROC:-1} install 2>&1 && touch build_cmd_success) | tee build.log
rm build_cmd_success

mv configure.log $CANTERA_DIR
mv build.log $CANTERA_DIR
cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/cantera-dbg
mkdir -p $MODULEDIR

echo "local name = \"cantera-dbg\"" > $MODULEDIR/$CANTERA_VERSION.lua
echo "local version = \"$CANTERA_VERSION\"" >> $MODULEDIR/$CANTERA_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$CANTERA_VERSION.lua
echo "local boost_version = \"$BOOST_VERSION\"" >> $MODULEDIR/$CANTERA_VERSION.lua
cat ../modulefiles/cantera.lua >> $MODULEDIR/$CANTERA_VERSION.lua
