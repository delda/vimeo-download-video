#!/bin/bash

VIMEO_VIDEO_ID=$1
FILE_DOWNLOAD=$2

usage () {
    echo "
NAME
       download_vimeo.sh - download a vimeo video

SYNOPSIS
       ./download_vimeo.sh VIMEO_VIDEO_ID FILE_DOWNLOAD

DESCRIPTION
       With this script you can download a vimeo video. This script is for educational purposes only!

       There are two mandatory arguments.

       VIMEO_VIDEO_ID <string>
              ID of a vimeo video. For example: 253780421 is the VIMEO_VIDEO_ID for the video https://vimeo.com/253780421

       FILE_DOWNLOAD <file>
              The script writes the received data into a local file.
"
}

if [ -z "$VIMEO_VIDEO_ID" ]; then
    echo "VIMEO_VIDEO_ID not found!"
    usage
    exit 1
fi

if [ -z "$FILE_DOWNLOAD" ]; then
    echo "FILE_DOWNLOAD not found!"
    usage
    exit 1
fi

curl https://vimeo.com/$VIMEO_VIDEO_ID | grep -Eo '"config_url":"[^"]*"' | head -n 1 | grep -o 'https[^"]*' | sed 's/\\//g' | xargs curl | jq '.request.files.progressive[0].url' | xargs curl --output $FILE_DOWNLOAD

if [ ! -f $FILE_DOWNLOAD ]; then
    echo "Impossible to download the video!"
    echo "Please, check your VIDEO_VIMEO_ID and try again."
fi
