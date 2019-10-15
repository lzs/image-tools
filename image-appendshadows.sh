#!/bin/bash

maxsize=384
PID=$$

do_help() {
	command=`basename $0`
	cat <<EOM
Usage $basename [options] inputfiles... outputfile

    -s <size>  Limit outut file to maximum isze of <size> kb (default 384)

Adds a shadow to each inputfile, then appends them horizontally into the outputfile.
EOM
}

while getopts "h?s:" opt; do
	case "$opt" in
	h|\?)
		do_help
		exit 0
		;;
	s)
		maxsize=$OPTARG
		;;
	esac
done

shift $((OPTIND-1))

if [ "$#" -eq 0 ]; then
	do_help
	exit 0
fi

OUTPUT=${@:$#}
FILES=${*%${!#}}

if [ -e $OUTPUT ]; then
	echo Output $OUTPUT exists
	exit 1
fi

declare -a filelist
for i in $FILES; do

	extension="${i##*.}"
	filename="${i%.*}"
	newfile="$filename-shadow-$$.$extension"
	filelist+=($newfile)
	echo Adding shadow to $i
	convert $i \( +clone  -background gray  -shadow 90x20+20+20% \) +swap \
		-background white -layers merge +repage $newfile
done

convert +append ${filelist[*]} ${OUTPUT%.*}-$$.${OUTPUT##*.}
convert -define jpeg:extent=${maxsize}kb -resize 2048x2048\> ${OUTPUT%.*}-$$.${OUTPUT##*.} $OUTPUT

rm ${OUTPUT%.*}-$$.${OUTPUT##*.}

for i in ${filelist[*]}; do
	rm $i
done

