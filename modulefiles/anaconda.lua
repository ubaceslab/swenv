
conflict("anaconda")

help(
"Adds Anaconda "..version.." to your PATH environmental variable.\n"
)

local anaconda_base = pathJoin(apps_dir,"anaconda")
local anaconda_dir = pathJoin(anaconda_base,version)

if isDir(anaconda_dir) then
else LmodError("module reports "..anaconda_dir.." is not a directory! Module not loaded." )
end

prepend_path( "PATH", pathJoin(anaconda_dir, "bin" ) )

