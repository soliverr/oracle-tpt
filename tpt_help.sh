#! /bin/bash
#
# Tanel Poder Troubleshooting scripts helper.
#
# List short description of scripts.
# Get usage help for given SQL-script.
#
# Copyright (c) 2013 Kryazhevskikh Sergey <soliverr@gmail.com>
#

SQLPATH=${SQLPATH:-`dirname $0`}

#
# Usage
#
usage() {
    cat << __EOFF__
$0: [--help] [--list] [script]

    --help   - get this help
    --list   - list all supplied SQL-scripts
    [script] - get help for this SQL-script

__EOFF__
}

#
# Short list SQL-scripts
#
short_list() {
    echo "Short description of scripts in $SQLPATH:" >&2
    find $SQLPATH/ -type f -name '*.sql' | sort | while read f ; do
        fn=`basename $f`
        if [ ${#fn} -lt 8 ] ; then
            r="\t\t\t"
            n="\t"
        elif [ ${#fn} -lt 16 ] ; then
            r="\t\t"
            n="\t\t"
        else
            r="\t"
            n="\t\t\t"
        fi
        if grep -q -s "^-- File name:[[:space:]]\+$fn" $f ; then
            sed -n -e "/^-- Purpose:[[:space:]]\+/,/^--[[:space:]]*$/ {
                        s/-- Purpose:[[:space:]]\+\(.*\)$/\t$fn$r - \1/p
                        s/^--[[:space:]]\+\(.*\)$/$n$r   \1/p
                       }" "$f" >&2
        fi
    done
}

#
# Get help for SQL-script
#  $1 - path to script
#
help_script() {
    f=`basename "$1"`
    if [[ "$f" =~ ".sql" ]] ; then
        fn=$f
    else
        fn=$f.sql
    fi
    f="$SQLPATH/$fn"
    if [ ! -r "$f" ] ; then
        echo "File $f not found" >&2
        exit 1
    fi
    echo -e "$fn - `sed -ne 's/-- Purpose:[[:space:]]\+\(.*\)$/\1/p' $f`" >&2
    sed -n -e "/^-- Usage:[[:space:]]\+/,/^--$/ s/^--\(.*\)/\1/p" "$f" >&2
}

# Check command line
if [ $# -eq 0 ] ; then
    usage
    exit 0
fi

case "$1" in
    --help) usage ;;
    --list) short_list ;;
    *) help_script "$1" ;;
esac


