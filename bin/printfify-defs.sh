#!/bin/bash

set -e

source "$(dirname $(readlink -f "$0"))/bashsteps-bash-utils-jan2017.source" || exit

sourcefile="$1"

[ -f "$sourcefile" ] || iferr_exit "File ($sourcefile) not found"

for ((ccc=1 ; ccc<100 ; ccc++)); do
    if ! [ -f "$sourcefile-$ccc" ]; then
	cp "$sourcefile" "$sourcefile-$ccc"
	break
    fi
done

leading_whitespace()
{
    read nonwhite therest <<<"$1"
    printf -- "%s" "${1%%"$nonwhite"*}"
}

while IFS= read -r ln; do
    w_one="$(leading_whitespace "$ln")"
    therest_one="${ln#"$w_one"}"
    case "$therest_one" in
	*os.system*hhh*) : ;;
	def\ *:*)
	    printf -- "%s%s\n" "$w_one" "$therest_one"
	    while IFS= read -r lineafter; do
		[[ "$lineafter" == *os.system*hhh* ]] || break
	    done
	    w_two="$(leading_whitespace "$lineafter")"
	    therest_two="${lineafter#"$w_two"}"
	    printf -- "%sos.system(\"echo ,%s, >>~/hhh\")\n" "$w_two" "${therest_one%%(*}"
	    printf -- "%s%s\n" "$w_two" "$therest_two"
	    ;;
	*)
	    printf -- "%s\n" "$ln"
	    ;;
    esac
done <"$sourcefile"  >"$sourcefile.tmp"

mv -f "$sourcefile.tmp" "$sourcefile"
