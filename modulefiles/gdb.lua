
conflict("gdb")

whatis( "Name: gdb" )
whatis( "Version: "..version )
whatis( "Category: Debugging" )
whatis( "Description: The GNU Project Debugger" )
whatis( "URL: http://www.gdb.org/" )

local gdb_base = pathJoin(apps_dir,"gdb")
local gdb_dir = pathJoin(gdb_base,version)

if isDir(gdb_dir) then
else LmodError("module reports "..gdb_dir.." is not a directory! Module not loaded." )
end

help(
"Adds gdb "..version.." to your PATH and other related environmental variables.\n"
)

prepend_path( "PATH", pathJoin(gdb_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin(gdb_dir,"share/man") )
prepend_path( "INFOPATH", pathJoin(gdb_dir,"share/info") )
