
conflict("cmake")

help(
"Adds CMake "..version.." to your PATH environmental variable.\n"
)

local cmake_base = pathJoin(apps_dir,"cmake")
local cmake_dir = pathJoin(cmake_base,version) 

if isDir(cmake_dir) then
else LmodError("module reports "..cmake_dir.." is not a directory! Module not loaded." )
end

prepend_path( "PATH", pathJoin(cmake_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin(cmake_dir, "man" ) )
prepend_path( "ACLOCAL_PATH", pathJoin(cmake_dir, "share/aclocal" ) )
