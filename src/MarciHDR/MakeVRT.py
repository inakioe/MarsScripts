# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 10:10:05 2016

@author: inakiOE

Este script procesa los archivos .cub resultantes de marci2tif.sh y los organiza por carpetas, creando un archivo vrt en RGB para cada una de las tiras de MARCI. 

versión revisada el 4 de abr. 2023. Activar entorno gdal. 


"""
import os
from tqdm import tqdm



def marciRGB(codes):
    os.chdir(codes)
    os.system('isis2std red= ' + codes + '.band0003.cub green= ' + codes + '.band0002 blue= ' + codes + '.band0001 mode=rgb format=png to = ' + codes + '.png')
    os.system('convert ' + codes + '.png -resize 2000x1000 -transparent black ' + codes + '_resize.png')
    os.system('rm ' + codes +'.png')
    os.system('mv ' + codes +'_resize.png ..')
    os.chdir('..')
       
    
def listProduct(path, product): 
    import os
    lstFiles = []
    lstCodes = []
    lstDir = os.walk(path) 
    for root, dirs, files in lstDir:
        for fichero in files:
            (nombreFichero, extension) = os.path.splitext(fichero)          
            if extension == product:
                lstFiles.append(nombreFichero)
                lstCodes.append(nombreFichero.split('.')[0])
    return lstFiles, lstCodes
    
os.system('. $ISISROOT/scripts/isis3Startup.sh')    
    
[lstFiles, lstCodes] = listProduct('.', '.cub')
lstCodes = list(set(lstCodes))
for codes in lstCodes:
    os.system('mkdir ' + codes)
    
for images in lstFiles:
    code = images.split('.')[0]
    os.system('mv ' + images + '.* ' + code + '/')    
    
lstFiles2 = []
lstCodes2 = []

for codes in tqdm(lstCodes):
    [lstFiles2, lstCodes2] = listProduct('./' + codes, '.cub')
    files = ' ' 
    lstFiles2.sort(reverse=True)
    for fil in lstFiles2:
        if (fil[-8:] == 'band0001') or (fil[-8:] == 'band0002') or (fil[-8:] == 'band0003'):
            files = files + codes + '/' + fil + '.cub ' 
        
    os.system('gdalbuildvrt -separate -a_srs "+proj=eqc +lon_0=0 +x_0=0 +y_0=0 +a=3396190 +b=3396190 +units=m +no_defs" ' + codes + '.vrt' + files)
    marciRGB(codes)
    

