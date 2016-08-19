family("petsc")

prereq("mpich","openblas")
local hier = hierarchyA("petsc", 6)

local compiler = hier[6]
local compiler_version = hier[5]

local mpi_implementation = hier[4]
local mpi_version = hier[3]

local petsc_prefix = libs_dir.."/petsc/"..version.."/"..compiler.."/"..compiler_version.."/"..mpi_implementation.."/"..mpi_version.."/"..blas_implementation.."/"..blas_version.."/"..petsc_type

help(
"\n"..
"This module loads the PETSc"..
"\n"..
"Version: "..version
)

whatis( "Name: PETSc" )
whatis( "Version: "..version )

if isDir(petsc_prefix) then
else LmodError("module reports "..petsc_prefix.." is not a directory! Module not loaded.")
end

prepend_path( "PATH", pathJoin(petsc_prefix, "bin" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(petsc_prefix, "lib" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(petsc_prefix, "lib64" ) )

setenv( "PETSC_BIN",  pathJoin(petsc_prefix, "bin" ) )
setenv( "PETSC_LIB",  pathJoin(petsc_prefix, "lib" ) )
setenv(	"PETSC_DIR",  petsc_prefix )
setenv( "PETSC_ARCH", "" )
setenv( "PETSC_VERSION", version )
