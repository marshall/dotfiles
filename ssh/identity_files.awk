#!/bin/awk -f
{
    if ($1 == "IdentityFile") {
        split($0, path, "\"");
        if (path[2]) {
            print path[2];
        } else {
            print $2;
        }
    }
}
