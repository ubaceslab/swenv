conflict("emacs")

help(
"Adds emacs "..version.." to your PATH environmental variable.\n"
)

local emacs_base = pathJoin(apps_dir,"emacs")
local emacs_dir = pathJoin(emacs_base,version)

if isDir(emacs_dir) then
else LmodError("module reports "..emacs_dir.." is not a directory! Module not loaded." )
end

prepend_path( "PATH", pathJoin(emacs_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin(emacs_dir, "share/man" ) )

