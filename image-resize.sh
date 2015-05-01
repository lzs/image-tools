#!/bin/sh

filename=$1
extension="${filename##*.}"
filename="${filename%.*}"

convert $1 -define jpeg:extent=256kb -resize 2048x1365\> $filename-256.$extension

