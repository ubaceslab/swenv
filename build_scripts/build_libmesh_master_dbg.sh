#!/bin/sh                                                                                                                                                                                                                                    
set -e # Fail on first error

export LIBMESH_VERSION=master

CURRENT_DIR=$PWD

mkdir -p ${UBCESLAB_SWENV_PREFIX:?undefined}/sourcesdir/libmesh

(cd $UBCESLAB_SWENV_PREFIX/sourcesdir/libmesh
if [ ! -d libmesh-$LIBMESH_VERSION ]; then
   git clone git://github.com/libMesh/libmesh.git ./libmesh-$LIBMESH_VERSION
fi
   cd libmesh-$LIBMESH_VERSION
   git pull origin master
)


TOPDIR=${UBCESLAB_SWENV_PREFIX:?undefined}/libs/libmesh-dbg
export LIBMESH_DIR=$TOPDIR/$LIBMESH_VERSION/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION:?undefined}/petsc/${PETSC_VERSION:?undefined}/${BLAS_IMPLEMENTATION:?undefined}/${BLAS_VERSION:?undefined}/boost-dbg/${BOOST_VERSION:?undefined}/hdf5/${HDF5_VERSION:?undefined}/vtk-dbg/${VTK_VERSION:?undefined}

mkdir -p $UBCESLAB_SWENV_PREFIX/builddir
BUILDDIR=`mktemp -d $UBCESLAB_SWENV_PREFIX/builddir/libmesh-XXXXXX`
cd $BUILDDIR

($UBCESLAB_SWENV_PREFIX/sourcesdir/libmesh/libmesh-$LIBMESH_VERSION/configure METHODS='dbg' --prefix=$LIBMESH_DIR --enable-everything --with-metis=PETSc --with-cppunit-prefix=${CPPUNIT_DIR:?undefined} --with-vtk-lib=${VTK_LIB:?undefined} --with-vtk-include=${VTK_INCLUDE:?undefined} 2>&1 && touch build_cmd_success) | tee configure.log

# Let's make sure we actually *found* the stuff we're trying to
# configure with.  If we didn't, these grep commands will fail.
for target in MPI PETSC BOOST HDF5 VTK; do
grep LIBMESH_HAVE_$target include/libmesh_config.h ||
(echo Failed to find $target; false)
done

(make -j ${NPROC:-1} 2>&1 && touch build_cmd_success) | tee make.log
rm build_cmd_success

rm -rf $LIBMESH_DIR
make install
mv config.log configure.log $LIBMESH_DIR
mv make.log $LIBMESH_DIR

cd $UBCESLAB_SWENV_PREFIX
rm -rf $BUILDDIR || true

cd $CURRENT_DIR
MODULEDIR=$UBCESLAB_SWENV_PREFIX/apps/lmod/derived_modulefiles/${COMPILER:?undefined}/${COMPILER_VERSION:?undefined}/${MPI_IMPLEMENTATION:?undefined}/${MPI_VERSION}/libmesh-dbg
mkdir -p $MODULEDIR

echo "local name = \"libmesh-dbg\"" > $MODULEDIR/$LIBMESH_VERSION.lua
echo "local version = \"$LIBMESH_VERSION\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
echo "local libs_dir = \"$UBCESLAB_SWENV_PREFIX/libs\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
echo "local petsc_version = \"$PETSC_VERSION\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
echo "local blas_implementation = \"$BLAS_IMPLEMENTATION\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
echo "local blas_version = \"$BLAS_VERSION\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
echo "local boost_version = \"$BOOST_VERSION\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
echo "local hdf5_version = \"$HDF5_VERSION\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
echo "local vtk_version = \"$VTK_VERSION\"" >> $MODULEDIR/$LIBMESH_VERSION.lua
cat ../modulefiles/libmesh_dbg.lua >> $MODULEDIR/$LIBMESH_VERSION.lua
