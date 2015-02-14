family("mpich")                                                                                                                                                                                                                           

local derived_modules_dir = apps_dir.."/lmod/derived_modulefiles"

local hier = hierarchyA("mpich", 5)

local compiler = hier[5]
local compiler_version = hier[4]
local mpi_implementation = hier[2]
local mpi_version = hier[1]

help(
"\n"..
"This module loads MPICH and sets:"..
"\n"..
"MPICH_BIN	MPICH_LIB	MPICH_MAN	MPI_IMPLEMENTATION	MPI_VERSION	MPI_DIR"..
"\n"..
"Version: "..version
)

whatis( "Name: MPICH" )
whatis( "Version: "..version )

local mpich_prefix  = libs_dir.."/mpich/"..version.."/"..compiler.."/"..compiler_version

if isDir(mpich_prefix) then
else LmodError("module reports "..mpich_prefix.." is not a directory! Module not loaded.")
end

prepend_path( "PATH", pathJoin(mpich_prefix, "bin" ) )
prepend_path( "MANPATH", pathJoin(mpich_prefix, "share/man" ) )

prepend_path("MODULEPATH", pathJoin( derived_modules_dir, compiler.."/"..compiler_version.."/"..mpi_implementation.."/"..mpi_version ) )


setenv( "MPI_IMPLEMENTATION", mpi_implementation )
setenv( "MPI_VERSION", version )

setenv( "MPICH_BIN", pathJoin(mpich_prefix, "bin" ) )
setenv( "MPICH_LIB", pathJoin(mpich_prefix, "lib" ) )
setenv( "MPICH_MAN", pathJoin(mpich_prefix, "share/man" ) )
setenv( "MPI_DIR",   mpich_prefix )
