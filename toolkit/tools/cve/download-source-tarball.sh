#!/bin/bash

# Download a source tarball

PROG="download-source-tarball.sh"

# Programs
CURL="/usr/bin/curl -s"
RM="/usr/bin/rm"

# Script input arguments
TARBALL_URL=""
OUT_FILE=""

usage()
{
    cat << __EOF__
Usage: ${PROG} [OPTION] ...
    -t Tarball URL
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

download_tarball()
{
    local TARBALL="${1}"
    local OUT="${2}"

    ${CURL} ${TARBALL} --output ${OUT}
}

# Begin script execution
while getopts "t:o:h" opt
do
    case ${opt} in
        t )
            TARBALL_URL="$OPTARG"
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

if [ -z ${TARBALL_URL} ] || [ -z ${OUT_FILE} ]; then
    echo "Invalid arguments"
    usage
    exit 1
fi

check_file ${OUT_FILE}
download_tarball ${TARBALL_URL} ${OUT_FILE}

echo "Finish ${PROG}"