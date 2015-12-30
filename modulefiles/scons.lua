
conflict("scons")

help(
"Adds scons "..version.." to your PATH environmental variable.\n"
)

local scons_base = pathJoin(apps_dir,"scons/")
local scons_dir = pathJoin(scons_base,version)

if isDir(scons_dir) then
else LmodError("module reports "..scons_dir.." is not a directory! Module not loaded." )
end

prepend_path( "PATH", pathJoin(scons_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin(scons_dir, "man" ) )

