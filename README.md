# MarsScripts
Some scripts to work with martian data and images

- MarciHDR

Los archivos marci2tif.sh y marci2tif_5.sh deben estar en la carpeta en la que se encuentren las imágenes IMG de MARCI.  

0.- Activamos el entorno de ISIS:
. $ISISROOT/scripts/isis3Startup.sh

1.- Ejecutamos marci2tif.sh 
Lista todos los archivos IMG de la carpeta y ejecuta la orden marci2tif_5.sh para cada uno de esos archivos

2.- marci2tif_5.sh ejecuta todos los pasos de ISIS para cada uno de los archivos IMG que envía el script marci2tif.sh

3.- Ejecutar en un entorno con isis activado y gdal el script MakeVRT.py
Este script procesa los archivos .cub resultantes de marci2tif.sh y los organiza por carpetas, creando un archivo vrt en RGB para cada una de las tiras de MARCI. 


- MarciGeorreference

· el script Georreferenciacion.sh convierte los archivos globales jpg de MARCI a geotiff. 

