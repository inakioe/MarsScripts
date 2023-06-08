#!/bin/bash 
imgbasestring=$1
echo 'Procesando ' $imgbasestring
echo ' '
echo Paso 1 MARCI2ISIS
marci2isis from=$imgbasestring.IMG to=$imgbasestring.cub flip=no

echo Paso 2 SPICEINIT
spiceinit from=$imgbasestring.odd.cub
spiceinit from=$imgbasestring.even.cub

echo Paso 3 MARCICAL
marcical from=$imgbasestring.odd.cub  to=$imgbasestring.odd.cal.cub
marcical from=$imgbasestring.even.cub  to=$imgbasestring.even.cal.cub

echo Paso 4 Borrado SPICEINIT
rm $imgbasestring.even.cub
rm $imgbasestring.odd.cub

echo Paso 5 CAM2MAP imagen principal

matchmap=yes

cam2map from=$imgbasestring.odd.cal.cub map=$ISISROOT/data/base/templates/maps/simplecylindrical.map to=$imgbasestring.odd.map.cub pixres=mpp resolution=10000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360
cam2map from=$imgbasestring.even.cal.cub map=$ISISROOT/data/base/templates/maps/simplecylindrical.map to=$imgbasestring.even.map.cub pixres=mpp resolution=10000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360

echo Paso 6 PHOTRIM
photrim from=$imgbasestring.odd.map.cub to=$imgbasestring.odd.map2.cub minemission=0 maxemission=80
photrim from=$imgbasestring.even.map.cub to=$imgbasestring.even.map2.cub minemission=0 maxemission=80

echo Paso 7 AUTOMOS imagen principal
ls $imgbasestring.even.map2.cub > $imgbasestring.txt
ls $imgbasestring.odd.map2.cub >> $imgbasestring.txt
automos fromlist=$imgbasestring.txt mosaic=$imgbasestring.cub 
rm $imgbasestring.txt

echo Paso 8 EXPLODE imagen principal
explode from=$imgbasestring.cub to=$imgbasestring

echo Paso 9 Borrado MAP imagen principal
rm $imgbasestring.odd.map.cub
rm $imgbasestring.even.map.cub
rm $imgbasestring.odd.map2.cub
rm $imgbasestring.even.map2.cub

echo Paso 10 Borrado MARCICAL
rm $imgbasestring.even.cal.cub
rm $imgbasestring.odd.cal.cub

echo Paso 11 Borrado EXPLODE angulos
rm $imgbasestring.odd.band*.cub
rm $imgbasestring.even.band*.cub

echo Paso 12 Borrado archivos temporales
rm $imgbasestring.cub
rm *band0004.cub
rm *band0005.cub

echo Paso 13 convertir a RGB png transparente
isis2std red= $imgbasestring.band0003.cub green= $imgbasestring.band0002 blue= $imgbasestring.band0001 mode=rgb format=png to = $imgbasestring.RGB.png
/usr/bin/convert $imgbasestring.RGB.png -resize 2000x1000 -transparent black $imgbasestring.png




