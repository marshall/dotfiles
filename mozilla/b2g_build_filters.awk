#!/usr/bin/awk -f

BEGIN {
  dotfiles=ENVIRON["DOTFILES"]
  build_info = 0
  b = 0

  i = 0
  while ((getline line < (dotfiles "/mozilla/b2g_build_ignore.txt")) > 0) {
    ignores[i] = line
    i++
  }
}

/^========/ {
  build_info++
  next
}

build_info == 3 { next }
/^(a|x) / { next }
/^\.\// { next }
/^sed\: 1/ { next }
/^Warning: package error/ { next }
/^  adding:/ { next }
/^Copy: / { next }
/^Install: / { next }
/^Symlink: / { next }
/^  (  )?\"[^\"]+\": / { next }
/^\tis a duplicate of/ { next }
/^cd [^ ]+\; make -j1 (private_)?export/ { next }
/^Notice file: / { next }
{
  for (i in ignores) {
    if (ignores[i] == $0) { next }
  }
}
{
  print
  fflush
}
