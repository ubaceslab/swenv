#!/bin/sh                                                                                                                                                                                                                                     
set -e

echo "Building Anaconda for ${UBCESLAB_SYSTEMTYPE:?undefined}"

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/anaconda

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/anaconda

if [ ! -f Miniconda-3.8.3-Linux-x86_64.sh ]; then
  wget http://repo.continuum.io/miniconda/Miniconda-3.8.3-Linux-x86_64.sh
fi
)

ANACONDA_DIR=${UBCESLAB_SWENV_PREFIX:?undefined}/apps/anaconda

# Clear out old installation. Anaconda's installer will error if directory is there.
rm -rf $ANACONDA_DIR


# For the anaconda, we run the bash script, then install the packages we want
# We'll try to remind the user what they'll need to do.
echo "ATTENTION: You will need to agree to the license."
echo "ATTENTION: Then, you need to set the install location to:"
echo "ATTENTION: $ANACONDA_DIR"
echo "ATTENTION: Then, this script will set packages to install."
echo "ATTENTION: You will need to agree that these packages get installed."
echo ""
echo "Press any key to continue with installation."
read -n 1 -s

# Run Anaconda installer
bash $UBCESLAB_SWENV_PREFIX/sourcesdir/anaconda/Miniconda-3.8.3-Linux-x86_64.sh

export PATH=$ANACONDA_DIR/bin:$PATH

# Now install desired packages
conda install numpy scipy h5py sympy matplotlib 

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/modulefiles/anaconda
mkdir -p $MODULEDIR

echo "local version = \"$ANACONDA_VERSION\"" > $MODULEDIR/anaconda.lua
echo "local apps_dir = \"$UBCESLAB_SWENV_PREFIX/apps\"" >> $MODULEDIR/anaconda.lua
cat ../modulefiles/anaconda.lua >> $MODULEDIR/anaconda.lua

