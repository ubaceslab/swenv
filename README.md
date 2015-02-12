UB CESLab Software Environment
==============================
Build scripts, module files, etc. for setting up the UBCESLab environment
on various systems we use. Each of the build scripts encodes the version
that is being built. If we need to update the version, then we need to rebuild
the library and its dependencies.

Local Setup Instructions
------------------------
Steps are as follows:
*   Put the .bashrc_ubceslab_<system>_init in your home directory
and source it on login. Currently <system> is sens.
*   Run the build_modules.sh script.
*   Put the .bashrc_ubceslab_modules_init in your home directory
and source it on login, *after* the .bashrc_ubceslab_<system>_init file.
*   Run build scripts for "core" level apps
  *   build_gcc_deps.sh, build_gcc.sh
  *   build_paraview.sh
  *   build_emacs.sh
  *   build_valgrind.sh
  *   build_gdb.sh
  *   ...
* Load the compiler, e.g.: module load gcc
* Run build scripts for "compiler" level apps
  *   build_mpich.sh
  *   build_openblas.sh
  *   ...

Library Setup Instructions
--------------------------
For libraries, on some systems we setup in a common place. On others, they sit
next to local installs. The scripts look similar but we have a different install
prefix in them. We separate the list here as a reminder.
*   build_gsl.sh
*   build_glpk.sh
*   build_boost.sh
*   build_hdf5.sh
*   build_tbb.sh
*   build_vtk.sh
*   ...

Library Dependencies
--------------------
For each of the libraries we build that have dependencies not explictly
expressed by the module hierarchy, i.e. beyond compiler+MPI, we put those
dependencies here.
* libMesh: boost, hdf5, tbb, vtk
* GRINS: libMesh, boost
* QUESO: boost, gsl, glpk, hdf5
