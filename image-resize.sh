#!/bin/sh

OPTIND=1
maxsize=300
no_clobber=0

do_help() {
	command=`basename $0`
	cat <<EOM
Usage: $basename [options] files...

    -n          No clobber existing files
    -s <size>   Resize to maximum output file output size of <size> kb (default 300)
EOM
}

while getopts "h?ns:" opt; do
	case "$opt" in
	h|\?)
		do_help
		exit 0
		;;
	n)
		no_clobber=1
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
	newname=$basename-$maxsize.$extension

	if [ ! -f $filename ]; then
		echo Skipping non-existant $filename
		continue
	fi
	if [ $no_clobber -eq 1 -a -f $newname ]; then
		echo Skipping $filename, $newname already exists
		continue
	fi
	echo "Resizing $filename to $basename-$maxsize.$extension"
	convert $filename -define jpeg:extent=${maxsize}kb -resize 2048x1365\> $basename-$maxsize.$extension
done

exit
