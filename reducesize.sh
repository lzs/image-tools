#!/bin/sh

filename=$1
extension="${filename##*.}"
filename="${filename%.*}"

convert -define jpeg:extent=220kb $1 $filename-220.$extension

