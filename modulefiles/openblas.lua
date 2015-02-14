
family("openblas")                                                                                                                                                                                                                           

local hier = hierarchyA("openblas", 5)

local compiler = hier[5]
local compiler_version = hier[4]

help(
"\n"..
"This module loads OpenBLAS and sets:"..
"\n"..
"OPENBLAS_BIN	OPENBLAS_LIB	BLAS_IMPLEMENTATION	BLAS_VERSION"..
"\n"..
"Version: "..version
)

whatis( "Name: OPENBLAS" )
whatis( "Version: "..version )

local openblas_prefix  = libs_dir.."/openblas/"..version.."/"..compiler.."/"..compiler_version

if isDir(openblas_prefix) then
else LmodError("module reports "..openblas_prefix.." is not a directory! Module not loaded.")
end

prepend_path( "PATH", pathJoin(openblas_prefix, "bin" ) )

prepend_path( "LD_LIBRARY_PATH", pathJoin(openblas_prefix, "lib" ) )

setenv( "OPENBLAS_DIR", openblas_prefix )
setenv( "OPENBLAS_BIN", pathJoin(openblas_prefix, "bin" ) )
setenv( "OPENBLAS_LIB", pathJoin(openblas_prefix, "lib" ) )
setenv( "BLAS_IMPLEMENTATION", "openblas" )
setenv( "BLAS_VERSION", version )
setenv( "BLAS_DIR", openblas_prefix )
setenv( "BLAS_LIBS", pathJoin(openblas_prefix, "lib" ).."/libopenblas.so")
setenv( "LAPACK_LIBS", pathJoin(openblas_prefix, "lib" ).."/libopenblas.so")

-- Default to 1 thread
setenv( "OPENBLAS_NUM_THREADS", 1 )
