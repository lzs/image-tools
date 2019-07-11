#!/bin/sh

filename=$1
extension="${filename##*.}"
filename="${filename%.*}"

convert $1 -define jpeg:extent=384kb -resize 2048x1365\> $filename-384.$extension

