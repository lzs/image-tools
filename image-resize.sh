#!/bin/sh

OPTIND=1
maxsize=300

do_help() {
	command=`basename $0`
	cat <<EOM
Usage: $basename [options] files...

    -s <size>   Resize to maximum output file output size of <size> kb (default 300)
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

for filename in "$@"
do
	extension="${filename##*.}"
	basename="${filename%.*}"
	echo "Resizing $filename to $basename-$maxsize.$extension"
	convert $filename -define jpeg:extent=${maxsize}kb -resize 2048x1365\> $basename-$maxsize.$extension
done

exit
