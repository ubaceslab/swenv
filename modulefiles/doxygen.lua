
conflict("doxygen")

help(
"Adds Doxygen "..version.." to your PATH environmental variable.\n"
)

local doxygen_base = pathJoin(apps_dir,"doxygen/")
local doxygen_dir = pathJoin(doxygen_base,version)

if isDir(doxygen_dir) then
else LmodError("module reports "..doxygen_dir.." is not a directory! Module not loaded." )
end

prepend_path( "PATH", pathJoin(doxygen_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin(doxygen_dir, "man" ) )

