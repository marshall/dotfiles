#!/bin/awk -f
{
    if ($1 == "IdentityFile") {
        split($0, path, "\"")
        if (path[2]) {
            files[path[2]] = ""
        } else {
            files[$2] = ""
        }
    }
    if ($1 == "Include") {
        # use zsh to expand the path(s)
        cmd = "zsh -c '(for path (" $2 ") echo $path) | xargs'"

        if ((cmd | getline paths) > 0) {
            split(paths, pathsArr, " ")
            for (i = 1; i <= length(pathsArr); i++) {
                 parseCmd = ENVIRON["DOTFILES"] "/ssh/identity_files.awk " pathsArr[i]
                 while ((parseCmd | getline) > 0)
                     files[$0] = ""
                 close(parseCmd)
            }
        }
        close(cmd)
    }
}
END { for ( f in files ) print f }
