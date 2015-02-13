
family("glpk")                                                                                                                                                                                                                           

local hier = hierarchyA("glpk", 5)

local compiler = hier[5]
local compiler_version = hier[4]

help(
"\n"..
"This module loads the GLPK Library and sets GLPK_BIN and GLPK_LIB"..
"\n"..
"Version: "..version
)

whatis( "Name: GLPK" )
whatis( "Version: "..version )

local glpk_prefix  = libs_dir.."/glpk/"..version.."/"..compiler.."/"..compiler_version

if isDir(glpk_prefix) then
else LmodError("module reports "..glpk_prefix.." is not a directory! Module not loaded.")
end

prepend_path( "PATH", pathJoin(glpk_prefix, "bin" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(glpk_prefix, "lib" ) )

setenv( "GLPK_DIR", glpk_prefix )
setenv( "GLPK_BIN", pathJoin(glpk_prefix, "bin" ) )
setenv( "GLPK_LIB", pathJoin(glpk_prefix, "lib" ) )
setenv( "GLPK_VERSION", version )

