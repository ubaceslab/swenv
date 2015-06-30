                                                                                                                                                                                                                                             
conflict("cantera")

local hier = hierarchyA("cantera", 5)

local compiler = hier[5]
local compiler_version = hier[4]

help(
"The cantera module file defines the following environment variables:\n"..
"CANTERA_DIR, CANTERA_LIB, and CANTERA_INC for the location of the \n"..
"CANTERA distribution.\n\n"..
"To use the CANTERA library, compile the source code with the option:\n"..
"-I$CANTERA_INC \n"..
"and add the following options to the link step: \n"..
"-L$CANTERA_LIB -lcantera\n"..
"Version "..version..", compiled with "..compiler.." "..compiler_version.." compilers."
)

whatis( "Name: Cantera chemistry library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library" )

local cantera_base = libs_dir.."/cantera/"..version.."/"..compiler.."/"..compiler_version

if isDir(cantera_base) then
else LmodError("module reports "..cantera_base.." is not a directory! Module not loaded.")
end

prepend_path( "LD_LIBRARY_PATH", pathJoin(cantera_base, "lib") )
prepend_path( "PATH", pathJoin(cantera_base, "bin" ) )
prepend_path( "INCLUDE", pathJoin(cantera_base, "include" ) )

setenv( "CANTERA_DIR", cantera_base )
setenv( "CANTERA_BIN", pathJoin(cantera_base, "bin" ) )
setenv( "CANTERA_INC", pathJoin(cantera_base, "include" ) )
setenv( "CANTERA_LIB", pathJoin(cantera_base, "lib" ) )

setenv( "CANTERA_VERSION", version )

