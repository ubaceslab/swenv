
conflict("git")

help(
"Adds git "..version.." to your PATH environmental variable.\n"
)

local git_base = pathJoin(apps_dir,"git")
local git_dir = pathJoin(git_base,version)

if isDir(git_dir) then
else LmodError("module reports "..git_dir.." is not a directory! Module not loaded." )
end

prepend_path( "PATH", pathJoin(git_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin(git_dir, "share/man" ) )

