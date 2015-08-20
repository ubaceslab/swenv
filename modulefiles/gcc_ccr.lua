
-- Load CCR's module
load("gcc/"..version)

help(
"\n"..
"The gcc module enables the GCC family of compilers (C/C++\n"..
"and Fortran) and updates the $PATH, $LD_LIBRARY_PATH, and\n"..
"$MANPATH environment variables to access the compiler binaries,\n"..
"libraries, and available man pages, respectively.\n"..
"\n"..
"The following additional environment variables are also defined:\n"..
"\n"..
"GCC_BIN (path to gcc/g++/gfortran compilers)\n"..
"GCC_LIB (path to C/C++/Fortran  libraries  )\n"..
"\n"..
"See the man pages for gcc, g++, and gfortran for detailed information\n"..
"on available compiler options and command-line syntax\n"..
"Version "..version
)

whatis( "Name: GCC Compiler" )
whatis( "Version: "..version )
whatis( "Category: compiler, runtime support" )
whatis( "Description: GCC Compiler Family (C/C++/Fortran for x86_64)" )
whatis( "URL: http://gcc.gnu.org/" )

prepend_path("MODULEPATH", pathJoin(derived_modules_dir,"gcc/"..version.."/modulefiles") )

setenv( "FC", "gfortran" )
setenv( "F90", "gfortran" )
setenv( "F77", "gfortran" )
setenv( "CC", "gcc" )
setenv( "CXX", "g++" )

setenv( "COMPILER", "gcc" )
setenv( "COMPILER_VERSION",  version )
