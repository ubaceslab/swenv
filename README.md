UB CESLab Software Environment
==============================
Build scripts, module files, etc. for setting up the UBCESLab environment
on various systems we use. Each of the build scripts encodes the version
that is being built. If we need to update the version, then we need to rebuild
the library and its dependencies.

The build scripts are based off work that was originally done with @roystgnr at the PECOS
Center in the Institute for Computational Engineering and Sciences.

When running the build scripts, you should run where they are located.

If you get an error about the source not being found, it means that I could not get a definite
URL to grab it from, so you need to download it yourself and put it in the directory it
tells you to, making sure the name matches with the name it is looking for. E.g. with
Paraview, you will encounter both of these scenarios.

I have tried to include "helper" scripts that include the version number so you just need to run,
e.g., build_paraview_version.sh.

Local Setup Instructions
------------------------
Steps are as follows:
*   Put the .bashrc_ubceslab_system_init in your home directory
and source it on login. Currently, the only "system" is sens, i.e. .bashrc_ubceslab_sens_init
*   Run the build_modules.sh script.
*   Put the .bashrc_ubceslab_modules in your home directory
and source it on login, *after* the .bashrc_ubceslab_system_init file.
*   Run build scripts for "core" level apps
  *   build_gcc_deps.sh, build_gcc_version.sh
  *   build_git_version.sh
  *   build_paraview_version.sh
  *   build_emacs_version.sh
  *   build_valgrind_version.sh
  *   build_gdb_version.sh
  *   build_autotools_version.sh
  *   build_doxygen_version.sh
  *   build_anaconda.sh
    * There is no version for Anaconda because you update it internally using the "conda" command
      (this is also how you install packages). The build will require
      you to agree to the license, set the prefix (the script will display the path for you in a
      message so you can copy it before the installer runs), and do not let it reset your bashrc
      since a modulefile will be created. After the installer runs, I have conda install numpy, scipy,
      h5py, sympy, and matplotlib. By module load anaconda, when you run python, you will be able to use
      those packages. Note I expect that each user will manage their own Anaconda install after this,
      but this should be enough for you to use matplotlib for data that we generate.
  *   build_texlive_version.sh
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
