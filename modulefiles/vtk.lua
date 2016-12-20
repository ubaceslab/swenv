
family("vtk")                                                                                                                                                                                                                           

local hier = hierarchyA("vtk", 6)

local compiler = hier[6]
local compiler_version = hier[5]

local mpi_implementation = hier[4]
local mpi_version = hier[3]

help(
"\n"..
"This module loads VTK and sets VTK_BIN and VTK_LIB"..
"\n"..
"Version: "..version
)

whatis( "Name: VTK" )
whatis( "Version: "..version )

local vtk_prefix  = libs_dir.."/vtk/"..version.."/"..compiler.."/"..compiler_version.."/"..mpi_implementation.."/"..mpi_version

if isDir(vtk_prefix) then
else LmodError("module reports "..vtk_prefix.." is not a directory! Module not loaded.")
end

prepend_path( "PATH", pathJoin(vtk_prefix, "bin" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(vtk_prefix, "lib" ) )

setenv( "VTK_BIN", pathJoin(vtk_prefix, "bin" ) )
setenv( "VTK_LIB", pathJoin(vtk_prefix, "lib" ) )
setenv( "VTK_DIR", vtk_prefix )
setenv( "VTK_INCLUDE", pathJoin(vtk_prefix, "include/vtk-"..version_major.."."..version_minor) )
setenv( "VTK_VERSION", version )
