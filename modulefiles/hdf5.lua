family("hdf5")                                                                                                                                                                                                                           

local hier = hierarchyA("hdf5", 5)

local compiler = hier[5]
local compiler_version = hier[4]

help(
"\n"..
"This module loads HDF5 and sets HDF5_BIN and HDF5-LIB"..
"\n"..
"Version: "..version
)

whatis( "Name: HDF5" )
whatis( "Version: "..version )

local hdf5_prefix  = libs_dir.."/hdf5/"..version.."/"..compiler.."/"..compiler_version

if isDir(hdf5_prefix) then
else LmodError("module reports "..hdf5_prefix.." is not a directory! Module not loaded.")
end

prepend_path( "PATH", pathJoin(hdf5_prefix, "bin" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(hdf5_prefix, "lib" ) )

setenv( "HDF5_DIR", hdf5_prefix )
setenv( "HDF5_BIN", pathJoin(hdf5_prefix, "bin" ) )
setenv( "HDF5_LIB", pathJoin(hdf5_prefix, "lib" ) )
setenv( "HDF5_VERSION", version )
