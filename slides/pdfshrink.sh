#!/bin/sh
#
# A simple script to reduce PDF file size with gs
# Initial idea and script: Alfred Klomp
# (http://www.alfredklomp.com/programming/shrinkpdf/)
# Enhancements by Juergen Spitzmueller <juergen@spitzmueller.org>
#
# Copyright 2010 Juergen Spitzmueller
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


#
# --help message
#
HELP () {
    echo "USAGE:"
    echo "pdfshrink filename.pdf [<ratio>]"
    echo "<ratio> is the image resolution. Valid values:"
    echo "* --drastical or -d (72dpi)"
    echo "* --small or -s (144dpi)"
    echo "* --medium or -m (200dpi)"
    echo "* --high or -h (300dpi)"
    echo "* <any digit>"
    echo "The default ratio is 144dpi."
}

#
# Say hello...
#
echo pdfshrink -- a simple PDF downsizing script. 

#
# Check if we have valid arguments
#
if [ $# -ne 1 -a $# -ne 2 ]; then
    HELP
    exit 1
fi

#
# --help requested
#
#if [ $1 == "--help" -o $1 == "-h" ]; then
#    HELP
#    exit
#fi

#
# Set resolution
#
if [ $# -ne 2 ]; then
    RES=15
    echo No image resolution specified. Using default \($RES\).
else
    if [ $2 = "--drastical" -o $2 = "-d" ]; then
        RES=72
    elif [ $2 = "--small" -o $2 = "-s" ]; then
        RES=144
    elif [ $2 = "--medium" -o $2 = "-m" ]; then
        RES=200
    elif [ $2 = "--high" -o $2 = "-h" ]; then
        RES=300
    elif echo $2 | egrep -v "[a-zA-Z,./:]+" ; then
        RES=$2
    else
         echo Invalid argument \"$2\"! Read --help.
         exit 1
    fi
    echo Specified image resolution: $RES.
fi


#
# The actual work
#

# input file
IFILE=$1
# output file (strip extension and append "-shrunk.pdf")
OFILE="${IFILE%.pdf}"_shrunk.pdf
# now call gs
gs	-q -dNOPAUSE -dBATCH -dSAFER -dVERBOSE\
	-sDEVICE=pdfwrite \
	-dCompatibilityLevel=1.4 \
	-dPDFSETTINGS=/screen \
	-dEmbedAllFonts=true \
	-dSubsetFonts=true \
	-dColorImageDownsampleType=/Average \
	-dColorImageResolution=$RES \
	-dGrayImageDownsampleType=/Average \
	-dGrayImageResolution=$RES \
	-dMonoImageDownsampleType=/Average \
	-dMonoImageResolution=$RES \
	-sOutputFile=$OFILE \
	 $IFILE

if [ $? -ne 0 ]; then
	echo Ghostscript returned an error. Exiting.
	exit 1
fi

echo pdfshrink: DONE!