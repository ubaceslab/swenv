
conflict("gsl")

local hier = hierarchyA("gsl", 5)

local compiler = hier[5]
local compiler_version = hier[4]

help(
"The gsl module file defines the following environment variables:\n"..
"GSL_DIR, GSL_LIB, and GSL_INC for the location of the \n"..
"GSL distribution.\n\n"..
"To use the GSL library, compile the source code with the option:\n"..
"-I$GSL_INC \n"..
"and add the following options to the link step: \n"..
"-L$GSL_LIB -lgsl\n"..
"Version "..version..", compiled with "..compiler.." "..compiler_version.." compilers."
)

whatis( "Name: GNU Scientific Library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library" )
whatis( "URL: http://www.gnu.org/software/gsl/" )

local gsl_base = libs_dir.."/gsl/"..version.."/"..compiler.."/"..compiler_version

if isDir(gsl_base) then
else LmodError("module reports "..gsl_base.." is not a directory! Module not loaded.")
end

prepend_path( "LD_LIBRARY_PATH", pathJoin(gsl_base, "lib") )
prepend_path( "PATH", pathJoin(gsl_base, "bin" ) )
prepend_path( "INCLUDE", pathJoin(gsl_base, "include" ) )

setenv( "GSL_DIR", gsl_base )
setenv( "GSL_BIN", pathJoin(gsl_base, "bin" ) )
setenv( "GSL_INC", pathJoin(gsl_base, "include" ) )
setenv( "GSL_LIB", pathJoin(gsl_base, "lib" ) )

setenv( "GSL_VERSION", version )
