
conflict( "texlive" )

local texlive_base = pathJoin(apps_dir,"texlive") 

local texlive_version = pathJoin(texlive_base,version)

if isDir(texlive_version) then
else LmodError("module reports "..texlive_version.." is not a directory! Module not loaded.")
end

help(
"Adds the TexLive "..version.." distribution to PATH.\n"..
"This contains the full TexLive install, including many TeX, LaTeX, etc. packages."
)

prepend_path( "PATH", pathJoin(texlive_version,"bin/x86_64-linux") )

