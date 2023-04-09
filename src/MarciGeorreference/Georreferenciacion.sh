#!/bin/bash

#convierte los archivos globales jpg de MARCI a geotiff. Activar entorno gdal
date
echo ' '

ls *.jpg |cut -d'.' -f1 >file.lis
filename="file.lis"

while read -r line
do
img_to_process="$line"
imgbasestring=${img_to_process%%'.jpg'}
echo $imgbasestring.jpg
gdal_translate -of GTiff -gcp 0 0 -180 90 -gcp 2814 0 180 90 -gcp 2814 1407 180 -90 -gcp 0 1407 -180 -90 $imgbasestring.jpg /tmp/$imgbasestring.jpg
gdalwarp -r near -order 1 -co COMPRESS=None  -t_srs EPSG:4326 /tmp/$imgbasestring.jpg $imgbasestring.tif
gdal_translate -projwin -180 90 0 -90 $imgbasestring.tif izda.tif
gdal_translate -projwin 0 90 180 -90 $imgbasestring.tif dcha.tif
gdal_translate -of GTiff -gcp 0 0 0 90 -gcp 1407 0 180 90 -gcp 1407 1407 180 -90 -gcp 0 1407 0 -90 izda.tif izda1.tif
gdal_translate -of GTiff -gcp 0 0 -180 90 -gcp 1407 0 0 90 -gcp 1407 1407 0 -90 -gcp 0 1407 -180 -90 dcha.tif dcha1.tif
gdalwarp dcha1.tif izda1.tif $imgbasestring.tif
rm izda*.tif
rm dcha*.tif

#fin de bucle 1 y fin de programa
done < "$filename"
wait
echo 'Fin procesado de la carpeta'
date



