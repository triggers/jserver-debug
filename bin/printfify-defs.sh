#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-bash-utils-jan2017.source" || exit

sourcefile="$1"

[ -f "$sourcefile" ] || iferr_exit "File ($sourcefile) not found"

for ((ccc=1 ; ccc<100 ; ccc++)); do
    if ! [ -f "$sourcefile-$ccc" ]; then
	cp "$sourcefile" "$sourcefile-$ccc"
	break
    fi
done

while IFS= read -r ln; do
    case "$ln" in
	*) printf -- "%s\n" "$ln"
    esac
done <"$sourcefile"  >"$sourcefile.tmp"
