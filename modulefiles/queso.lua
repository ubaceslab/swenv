
prereq( "gsl" )
prereq( "glpk" )
prereq( "boost" )

conflict( "queso" )

local hier = hierarchyA("queso", 6)

local compiler = hier[6]
local compiler_version = hier[5]

local mpi_implementation = hier[4]
local mpi_version = hier[3]

help(
"This module loads QUESO "..version.." master branch, compiled with "..compiler.." "..compiler_version.." and "..mpi_implementation.." "..mpi_version
)

local queso_arch = "queso/"..version.."/"..compiler.."/"..compiler_version.."/"..mpi_implementation.."/"..mpi_version.."/gsl/"..gsl_version.."/glpk/"..glpk_version.."/boost/"..boost_version

local queso_dir = pathJoin( libs_dir, queso_arch )

if isDir(queso_dir) then
else LmodError("module reports "..queso_dir.." is not a directory! Module not loaded.")
end

setenv( "QUESO_DIR", queso_dir )
setenv( "QUESO_VERSION", version )

prepend_path( "PATH", pathJoin( queso_dir, "bin" ) )
prepend_path( "LD_LIBRARY_PATH",  pathJoin( queso_dir, "lib" ) )
