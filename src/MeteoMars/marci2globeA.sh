#!/bin/bash
date
echo ' '

. $ISISROOT/scripts/isis3Startup.sh
#listamos y guardamos el nombre de los ficheros IMG
ls *.IMG |cut -d'.' -f1 >file.lis
filename="file.lis"

while read -r line
do
img_to_process="$line"
imgbasestring=${img_to_process%%'.IMG'}
marci2globeB.sh $imgbasestring &
#fin de bucle 1 y fin de programa
done < "$filename"
wait
echo 'Fin procesado de la carpeta'
date


