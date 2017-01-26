conflict("boost")
conflict("boost-dbg")

local hier = hierarchyA("boost",5)
local compiler = hier[5]
local compiler_version = hier[4]

help(
"\n"..
"This module loads the Boost Library and sets BOOST_LIB and BOOST_DIR"..
"\n"..
"Version: "..version
)

whatis( "Name: Boost" )
whatis( "Version: "..version )

local boost_prefix  = libs_dir.."/"..name.."/"..version.."/"..compiler.."/"..compiler_version

if isDir(boost_prefix) then
else LmodError("module reports "..boost_prefix.." is not a directory! Module not loaded.")
end

prepend_path( "LD_LIBRARY_PATH", pathJoin(boost_prefix, "lib" ) )

setenv( "BOOST_LIB", pathJoin(boost_prefix, "lib" ) )
setenv( "BOOST_DIR", boost_prefix )
setenv( "BOOST_ROOT", boost_prefix )
setenv( "BOOST_VERSION", version )
