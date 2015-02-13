
conflict("paraview")

help(
"Adds ParaView "..version.." to your PATH environmental variable.\n"
)

local paraview_base = pathJoin(apps_dir,"paraview")
local paraview_dir = pathJoin(paraview_base,version)

if isDir(paraview_dir) then
else LmodError("module reports "..paraview_dir.." is not a directory! Module not loaded." )
end

prepend_path( "PATH", pathJoin(paraview_dir, "bin" ) )

