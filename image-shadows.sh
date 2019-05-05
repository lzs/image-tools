#!/bin/bash

PID=$$
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
	convert $i \( +clone  -background gray  -shadow 90x20+20+20% \) +swap           -background white -layers merge +repage $newfile
done

convert +append ${filelist[*]} ${OUTPUT%.*}-$$.${OUTPUT##*.}
convert -define jpeg:extent=300kb -resize 2048x2048\> ${OUTPUT%.*}-$$.${OUTPUT##*.} $OUTPUT

rm ${OUTPUT%.*}-$$.${OUTPUT##*.}

for i in ${filelist[*]}; do
	rm $i
done

