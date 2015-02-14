
family("tbb")                                                                                                                                                                                                                           

local hier = hierarchyA("tbb", 5)

local compiler = hier[5]
local compiler_version = hier[4]

help(
"\n"..
"This module loads the Intel TBB Library"..
"\n"..
"Version: "..version
)

whatis( "Name: TBB" )
whatis( "Version: "..version.." Release" )

local tbb_dir  = libs_dir.."/tbb/"..version.."/"..compiler.."/"..compiler_version

if isDir(tbb_dir) then
else LmodError("module reports "..tbb_dir.." is not a directory! Module not loaded.")
end

prepend_path( "PATH", tbb_dir )
prepend_path( "LD_LIBRARY_PATH", pathJoin(tbb_dir, "lib" ) )
setenv( "TBB_DIR", tbb_dir )
-- TBB_VERSION collides with a TBB internal variable
setenv( "TBB_VERSIONNUM", version )
