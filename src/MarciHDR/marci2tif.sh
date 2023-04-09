#!/bin/bash

#Lista todos los archivos IMG de la carpeta y ejecuta la orden marci2tif_5.sh para cada uno de esos archivos

clear
date
echo ' '

cd /media/MARCI_DISK/marciHR/
. $ISISROOT/scripts/isis3Startup.sh
#listamos y guardamos el nombre de los ficheros IMG
ls *.IMG |cut -d'.' -f1 >file.lis
filename="file.lis"

while read -r line
do
img_to_process="$line"
imgbasestring=${img_to_process%%'.IMG'}
/media/MARCI_DISK/marciHR/marci2tif_5.sh $imgbasestring &
#fin de bucle 1 y fin de programa
done < "$filename"
wait
echo 'Fin procesado de la carpeta'
date


