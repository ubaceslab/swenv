#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export AUTOTOOLS_VERSION=$1
export M4_VERSION=$2
export AUTOCONF_VERSION=$3
export AUTOMAKE_VERSION=$4
export LIBTOOL_VERSION=$5

echo "Building all autotools for ${UBCESLAB_SYSTEMTYPE:?undefined}"
echo

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/autotools

(cd ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/autotools

if [ ! -f m4-$M4_VERSION.tar.gz ]; then
  wget http://ftp.gnu.org/gnu/m4/m4-$M4_VERSION.tar.gz 
fi

if [ ! -f autoconf-$AUTOCONF_VERSION.tar.gz ]; then
  wget http://ftp.gnu.org/gnu/autoconf/autoconf-$AUTOCONF_VERSION.tar.gz
fi

if [ ! -f automake-$AUTOMAKE_VERSION.tar.gz ]; then
  wget http://ftp.gnu.org/gnu/automake/automake-$AUTOMAKE_VERSION.tar.gz
fi

if [ ! -f libtool-$LIBTOOL_VERSION.tar.gz ]; then
  wget http://ftp.gnu.org/gnu/libtool/libtool-$LIBTOOL_VERSION.tar.gz
fi

)

TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/autotools
export AUTOTOOLS_DIR=$TOPDIR/$AUTOTOOLS_VERSION

# Clear out existing installation
rm -rf $AUTOTOOLS_DIR

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/autotools-XXXXXX`
cd $BUILDDIR

# Build M4
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/autotools/m4-$M4_VERSION.tar.gz
cd m4-$M4_VERSION
(./configure --prefix=$AUTOTOOLS_DIR 2>&1 && touch build_cmd_success) | tee m4_configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee m4_make.log
rm build_cmd_success
make install
mv config.log $AUTOTOOLS_DIR/m4_config.log
mv m4_configure.log m4_make.log $AUTOTOOLS_DIR
cd ..

# We need to use the new M4/Autoconf/etc
export PATH=$AUTOTOOLS_DIR/bin:$PATH

# Build Autoconf
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/autotools/autoconf-$AUTOCONF_VERSION.tar.gz
cd autoconf-$AUTOCONF_VERSION
# Autoconf needs to use the newer M4
export M4=$AUTOTOOLS_DIR/bin/m4
(./configure --prefix=$AUTOTOOLS_DIR 2>&1 && touch build_cmd_success) | tee autoconf_configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee autoconf_make.log
rm build_cmd_success
make install
mv config.log $AUTOTOOLS_DIR/autoconf_config.log 
mv autoconf_configure.log autoconf_make.log $AUTOTOOLS_DIR
cd ..

# Build Automake
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/autotools/automake-$AUTOMAKE_VERSION.tar.gz
cd automake-$AUTOMAKE_VERSION
(./configure --prefix=$AUTOTOOLS_DIR 2>&1 && touch build_cmd_success) | tee automake_configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee automake_make.log
rm build_cmd_success
make install

mv config.log $AUTOTOOLS_DIR/automake_config.log
mv automake_configure.log automake_make.log $AUTOTOOLS_DIR
cd ..

# Build Libtool
tar xzf $UBCESLAB_SWENV_PREFIX/sourcesdir/autotools/libtool-$LIBTOOL_VERSION.tar.gz
cd libtool-$LIBTOOL_VERSION
(./configure --prefix=$AUTOTOOLS_DIR 2>&1 && touch build_cmd_success) | tee libtool_configure.log
rm build_cmd_success
(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee libtool_make.log
rm build_cmd_success
make install
mv config.log $AUTOTOOLS_DIR/libtool_config.log
mv libtool_configure.log libtool_make.log $AUTOTOOLS_DIR
cd ..


# Done building everything
cd $UBCESLAB_SWENV_PREFIX 
rm -rf $BUILDDIR || true

cd $UBCESLAB_SWENV_PREFIX
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/autotools
mkdir -p $MODULEDIR

cd $CURRENT_DIR

echo "local version = \"$AUTOTOOLS_VERSION\"" > $MODULEDIR/$AUTOTOOLS_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$AUTOTOOLS_VERSION.lua
cat ../modulefiles/autotools.lua >> $MODULEDIR/$AUTOTOOLS_VERSION.lua
