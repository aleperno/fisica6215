#!/bin/bash

for f in *.svg; do
	#echo "Archivo: $f"
	name=$(echo $f | cut -d '.' -f 1)
	inkscape $f -A "$name.pdf"
done