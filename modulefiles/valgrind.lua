
conflict ("valgrind")

whatis( "Name: valgrind" )
whatis( "Version: "..version )
whatis( "Category: Debugging" )
whatis( "Description: Memory Checking and Profiling Tool" )
whatis( "URL: http://www.valgrind.org/" )

local valgrind_base = pathJoin(apps_dir,"valgrind")
local valgrind_dir = pathJoin(valgrind_base,version)

if isDir(valgrind_dir) then
else LmodError("module reports "..valgrind_dir.." is not a directory! Module not loaded." )
end

help(
"Adds valgrind "..version.." to your PATH environmental variable.\n"..
"This installation of valgrind was built for AMD64 architectures."
)


prepend_path( "PATH", pathJoin(valgrind_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin(valgrind_dir,"share/man") )
