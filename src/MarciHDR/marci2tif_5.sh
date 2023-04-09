imgbasestring=$1
echo 'Procesando' $imgbasestring
echo ' '

. $ISISROOT/scripts/isis3Startup.sh
echo Paso 1 MARCI2ISIS
marci2isis from=$imgbasestring.IMG to=$imgbasestring.cub flip=no

echo Paso 2 SPICEINIT
spiceinit from=$imgbasestring.odd.cub
spiceinit from=$imgbasestring.even.cub

echo Paso 3 PHOTRIM
photrim from=$imgbasestring.odd.cub to=$imgbasestring.odd.pho.cub minemission=0 maxemission=80
photrim from=$imgbasestring.even.cub to=$imgbasestring.even.pho.cub minemission=0 maxemission=80

echo Paso 4 Borrado SPICEINIT
rm $imgbasestring.even.cub
rm $imgbasestring.odd.cub


echo Paso 5 MARCICAL
marcical from=$imgbasestring.odd.pho.cub  to=$imgbasestring.odd.cal.cub
marcical from=$imgbasestring.even.pho.cub  to=$imgbasestring.even.cal.cub

echo Paso 6 Borrado PHOTRIM
rm $imgbasestring.even.pho.cub
rm $imgbasestring.odd.pho.cub


echo Paso 7 CAM2MAP imagen principal
cam2map from=$imgbasestring.odd.cal.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.odd.map.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360
cam2map from=$imgbasestring.even.cal.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.even.map.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360

echo Paso 8 AUTOMOS imagen principal
ls $imgbasestring.even.map.cub > $imgbasestring.txt
ls $imgbasestring.odd.map.cub >> $imgbasestring.txt
automos fromlist=$imgbasestring.txt mosaic=$imgbasestring.cub 
rm $imgbasestring.txt

echo Paso 9 EXPLODE imagen principal
explode from=$imgbasestring.cub to=$imgbasestring

echo Paso 10 Borrado MAP imagen principal
rm $imgbasestring.odd.map.cub
rm $imgbasestring.even.map.cub

echo Paso 11 EXPLODE angulos
explode from=$imgbasestring.odd.cal.cub to=$imgbasestring.odd
explode from=$imgbasestring.even.cal.cub to=$imgbasestring.even

echo Paso 12 Borrado MARCICAL
rm $imgbasestring.even.cal.cub
rm $imgbasestring.odd.cal.cub

echo Paso 13 PHOCUBE
phocube from=$imgbasestring.odd.band0001.cub to=$imgbasestring.odd.phocube.cub phase=yes emission=yes incidence=yes
phocube from=$imgbasestring.even.band0001.cub to=$imgbasestring.even.phocube.cub phase=yes emission=yes incidence=yes

echo Paso 14 Borrado EXPLODE angulos
rm $imgbasestring.odd.band*.cub
rm $imgbasestring.even.band*.cub

echo Paso 15 EXPLODE Phocube
explode from=$imgbasestring.odd.phocube.cub to=$imgbasestring.odd.phocube
explode from=$imgbasestring.even.phocube.cub to=$imgbasestring.even.phocube

echo Paso 16 CAM2MAP Phase
cam2map from=$imgbasestring.odd.phocube.band0001.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.odd.phocube.phase.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360
cam2map from=$imgbasestring.even.phocube.band0001.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.even.phocube.phase.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360

echo Paso 17 CAM2MAP Emission
cam2map from=$imgbasestring.odd.phocube.band0002.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.odd.phocube.emission.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360
cam2map from=$imgbasestring.even.phocube.band0002.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.even.phocube.emission.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360

echo Paso 18 CAM2MAP Incidence
cam2map from=$imgbasestring.odd.phocube.band0003.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.odd.phocube.incidence.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360
cam2map from=$imgbasestring.even.phocube.band0003.cub map=$ISISROOT/../data/base/templates/maps/simplecylindrical.map to=$imgbasestring.even.phocube.incidence.cub pixres=mpp resolution=1000 defaultrange=map minlat=-90 maxlat=90 minlon=0 maxlon=360

echo Paso 19 Borrado PHOCUBE
rm $imgbasestring.odd.phocube.cub
rm $imgbasestring.even.phocube.cub

echo Paso 20 Borrado EXPLODE Phocube 
rm $imgbasestring.odd.phocube.band*.cub
rm $imgbasestring.even.phocube.band*.cub

echo Paso 21 Listado archivos phase
ls $imgbasestring.odd.phocube.phase.cub > $imgbasestring.phase
ls $imgbasestring.even.phocube.phase.cub >> $imgbasestring.phase

echo Paso 22 Listado archivos emission
ls $imgbasestring.odd.phocube.emission.cub > $imgbasestring.emission
ls $imgbasestring.even.phocube.emission.cub >> $imgbasestring.emission

echo Paso 23 Listado archivos incidence
ls $imgbasestring.odd.phocube.incidence.cub > $imgbasestring.incidence
ls $imgbasestring.even.phocube.incidence.cub >> $imgbasestring.incidence

echo Paso 24 AUTOMOS angulos
automos fromlist=$imgbasestring.phase mosaic=$imgbasestring.phase.cub 
automos fromlist=$imgbasestring.emission mosaic=$imgbasestring.emission.cub 
automos fromlist=$imgbasestring.incidence mosaic=$imgbasestring.incidence.cub 

echo Paso 25 Borrado listados
rm $imgbasestring.phase
rm $imgbasestring.emission
rm $imgbasestring.incidence

echo Paso 26 Borrado archivos temporales
rm $imgbasestring.odd.phocube.phase.cub
rm $imgbasestring.even.phocube.phase.cub
rm $imgbasestring.odd.phocube.emission.cub
rm $imgbasestring.even.phocube.emission.cub
rm $imgbasestring.odd.phocube.incidence.cub
rm $imgbasestring.even.phocube.incidence.cub
rm $imgbasestring.cub

echo 'Fin procesado' $imgbasestring






