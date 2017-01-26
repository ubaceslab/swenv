
conflict("cppunit")
conflict("cppunit-dbg")

local hier = hierarchyA("cppunit", 5)

local compiler = hier[5]
local compiler_version = hier[4]

help(
"The cppunit module file defines the following environment variables:\n"..
"CPPUNIT_DIR, CPPUNIT_LIB, and CPPUNIT_INC for the location of the \n"..
"CPPUNIT distribution.\n\n"..
"To use the CPPUNIT library, compile the source code with the option:\n"..
"-I$CPPUNIT_INC \n"..
"and add the following options to the link step: \n"..
"-L$CPPUNIT_LIB -lcppunit\n"..
"Version "..version..", compiled with "..compiler.." "..compiler_version.." compilers."
)

whatis( "Name: CppUnit Testing Framework" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library" )
whatis( "URL: http://freedesktop.org/wiki/Software/cppunit/" )

local cppunit_base = libs_dir.."/"..name.."/"..version.."/"..compiler.."/"..compiler_version

if isDir(cppunit_base) then
else LmodError("module reports "..cppunit_base.." is not a directory! Module not loaded.")
end

prepend_path( "LD_LIBRARY_PATH", pathJoin(cppunit_base, "lib") )
prepend_path( "PATH", pathJoin(cppunit_base, "bin" ) )
prepend_path( "INCLUDE", pathJoin(cppunit_base, "include" ) )

setenv( "CPPUNIT_DIR", cppunit_base )
setenv( "CPPUNIT_BIN", pathJoin(cppunit_base, "bin" ) )
setenv( "CPPUNIT_INC", pathJoin(cppunit_base, "include" ) )
setenv( "CPPUNIT_LIB", pathJoin(cppunit_base, "lib" ) )

setenv( "CPPUNIT_VERSION", version )
