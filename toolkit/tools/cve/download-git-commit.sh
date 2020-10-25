#!/bin/bash

# Download a git commit as a patch
# Adapted from: https://chem-bla-ics.blogspot.com/2011/01/github-tip-download-commits-as-patches.html

PROG="download-git-commit.sh"

# Programs
CURL="/usr/bin/curl"
RM="/usr/bin/rm"

# Script input arguments
COMMIT_URL=""
OUT_FILE=""

usage()
{
    cat << __EOF__
Usage: ${PROG} [OPTION] ...
    -c Github commit URL
    -o Output file
__EOF__
}

check_file()
{
    local FILE="${1}"

    if [ -f "$FILE" ]; then
        echo "Output file exists - will delete"
        ${RM} -f ${FILE}
        if [ -f "$FILE" ]; then
            echo "Unable to delete ${FILE} !!!"
            exit 1
        fi
    fi 
}

download_commit()
{
    local PATCH="${1}.patch"
    local OUT="${2}"

    ${CURL} ${PATCH} --output ${OUT}
}

# Begin script execution
while getopts "c:o:h" opt
do
    case ${opt} in
        c )
            COMMIT_URL="$OPTARG"
            ;;
        o )
            OUT_FILE="$OPTARG"
            ;;
        h )
            usage
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" 1>&2
            usage
            exit 1
            ;;
    esac
done

if [ -z ${COMMIT_URL} ] || [ -z ${OUT_FILE} ]; then
    echo "Invalid arguments"
    usage
    exit 1
fi

check_file ${OUT_FILE}
download_commit ${COMMIT_URL} ${OUT_FILE}

echo "Finish ${PROG}"