
-- Load CCR's module
load("intel-mpi/"..mpi_version)

local mpi_implementation = "intel-mpi"

prepend_path("MODULEPATH", pathJoin( derived_modules_dir, compiler.."/"..compiler_version.."/"..mpi_implementation.."/"..mpi_version ) )

setenv( "MPI_IMPLEMENTATION", mpi_implementation )
setenv( "MPI_VERSION", mpi_version )

-- We need to do this so we don't get an error on unload
local mpi_dir = os.getenv("INTEL_MPI") or ""
setenv( "MPI_DIR", mpi_dir ) 
