
family("compiler")                                                                                                                                                                                                                           

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

local gcc_prefix  = apps_dir.."/gcc/"..version

if isDir(gcc_prefix) then
else LmodError("module reports "..gcc_prefix.." is not a directory! Module not loaded.")
end

local mpfr_prefix = libs_dir.."/mpfr/"..mpfr_version
local gmp_prefix = libs_dir.."/gmp/"..gmp_version
local mpc_prefix = libs_dir.."/mpc/"..mpc_version

prepend_path( "PATH", pathJoin(gcc_prefix, "bin" ) )
prepend_path( "MANPATH", pathJoin(gcc_prefix, "share/man" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(gcc_prefix, "lib64" ) )

prepend_path( "LD_LIBRARY_PATH", pathJoin(gmp_prefix, "lib" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(mpfr_prefix, "lib" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(mpc_prefix, "lib" ) )

prepend_path("MODULEPATH", pathJoin(derived_modules_dir,"gcc/"..version.."/modulefiles") )

setenv( "GCC_BIN", pathJoin(gcc_prefix, "bin" ) )
setenv( "GCC_LIB", pathJoin(gcc_prefix, "lib64" ) )
setenv( "GCC_MAN",  pathJoin(gcc_prefix, "share/man" ) )

setenv( "FC", "gfortran" )
setenv( "F90", "gfortran" )
setenv( "F77", "gfortran" )
setenv( "CC", "gcc" )
setenv( "CXX", "g++" )

setenv( "COMPILER", "gcc" )
setenv( "COMPILER_VERSION",  version )
