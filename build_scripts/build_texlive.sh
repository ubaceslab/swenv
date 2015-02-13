#!/bin/sh                                                                                                                                                                                                                                     
set -e

TEXLIVE_VERSION=$1

echo "Building TeXLive for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/texlive

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/texlive

if [ ! -f install-tl-unx.tar.gz  ]; then
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz 
fi
)

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/texlive-XXXXXX`
mkdir -p $BUILDDIR
cd $BUILDDIR

# Prepare to run installer
tar -xzf ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/texlive/install-tl-unx.tar.gz
cd install-tl-[0-9]*

#Wipe out previous installation
rm -rf ${UBCESLAB_SWENV_PREFIX:?undefined}/apps/texlive/$TEXLIVE_VERSION

# Bring over profile file, substituting environment variables
while read line
do
   eval echo "$line"
done < $CURRENT_DIR/texlive.profile > ./texlive.profile

# Run TeXLive installer
./install-tl --profile=./texlive.profile

cd $CURRENT_DIR

rm -rf $BUILDDIR

MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/texlive
mkdir -p $MODULEDIR

echo "local version = \"$TEXLIVE_VERSION\"" > $MODULEDIR/$TEXLIVE_VERSION.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/$TEXLIVE_VERSION.lua
cat ../modulefiles/texlive.lua >> $MODULEDIR/$TEXLIVE_VERSION.lua

