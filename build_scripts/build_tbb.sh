#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export TBB_FULL_VERSION=$1

if [ $TBB_FULL_VERSION = 22_013 ] && [ $COMPILER = clang ]; then
  exit
fi

CURRENT_DIR=$PWD

export TBB_PREFIX=`echo $TBB_FULL_VERSION | cut -d _ -f 1`

export TBB_MAJOR=`echo ${TBB_PREFIX:0:1}`
export TBB_MINOR=`echo ${TBB_PREFIX:1:2}`

export TBB_VERSION=$TBB_MAJOR.$TBB_MINOR

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/tbb

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/tbb

if [ ! -f tbb${TBB_FULL_VERSION}oss_src.tgz ]; then
   wget https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb${TBB_FULL_VERSION}oss_src.tgz 
fi
)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/tbb
export TBB_DIR=$TOPDIR/$TBB_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/tbb-XXXXXX`
cd $BUILDDIR
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/tbb/tbb${TBB_FULL_VERSION}oss_src.tgz
cd tbb${TBB_FULL_VERSION}oss
rm -rf $TBB_DIR

CCBASENAME=`echo $CC | sed 's/.*\///'`
(make -j ${NPROC:-1}  tbb_build_dir=$TBB_DIR compiler=$CCBASENAME 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

cp -a include/ $TBB_DIR
mv make.log $TBB_DIR
cd $TBB_DIR
ln -s *_release lib

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/modulefiles/tbb
mkdir -p $MODULEDIR

echo "local version = \"$TBB_VERSION\"" > $MODULEDIR/$TBB_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$TBB_VERSION.lua
cat ../modulefiles/tbb.lua >> $MODULEDIR/$TBB_VERSION.lua
