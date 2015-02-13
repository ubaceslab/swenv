
conflict( "autotools" )

help(
"The autotools module file defines the environment variable\n"..
"AUTOTOOLS_DIR for the location of the GNU autotools\n"..
"package which provides a collection of common development utilties.\n"..
"Loading the autotools module will update your PATH to access\n"..
"recent version of m4, autoconf, automake, and libtool.\n"..
"Version "..version
)

whatis( "Name: GNU Autotools" )
whatis( "Version: "..version )
whatis( "Category: utility, developer support" )
whatis( "Description: Developer utilities" )

local autotools_base = pathJoin(apps_dir,"autotools")
local autotools_dir = pathJoin(autotools_base,version)

if isDir(autotools_dir) then
else LmodError("module reports "..autotools_dir.." is not a directory! Module not loaded.")
end

setenv( "AUTOTOOLS_DIR", autotools_dir )

prepend_path( "PATH", pathJoin( autotools_dir, "bin" ) )
prepend_path( "MANPATH", pathJoin( autotools_dir, "share/man" ) )
prepend_path( "INFOPATH", pathJoin( autotools_dir, "share/info" ) )

-- We want the m4 macros installed on the base system: /usr/share/aclocal.
-- These can be searched using ACLOCAL_PATH per
-- http://www.gnu.org/software/automake/manual/html_node/Macro-Search-Path.html
-- but adding only this entry causes the system-installed versions to take
-- precedence over share/aclocal from this module.  So we must add both to
-- ACLOCAL_PATH to obtain the correct search order.  The version-specific
-- details in (say) /usr/share/aclocal-1.11 are omitted as this module may be
-- of a different aclocal version.  Also this module's .../share/aclocal-1.12
-- is omitted from ACLOCAL_PATH as it is always given preference to
-- ACLOCAL_PATH.  In summary, this is awful but it permits using
-- system-installed macros.
if isDir("/usr/share/aclocal") then
prepend_path( "ACLOCAL_PATH", "/usr/share/aclocal" )
prepend_path( "ACLOCAL_PATH", pathJoin( autotools_dir, "share/aclocal" ) )
end

