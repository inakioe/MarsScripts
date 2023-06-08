#!/usr/bin/env python3 
# -*- coding: utf-8 -*-
"""
Created on Fri Jun  4 17:17:22 2021

@author: ioe
"""

import sys
from datetime import datetime, timedelta
import FuncionesMarci as marci
import pandas as pd
import os


if __name__ == "__main__":    #Principal bucle
    Date0 = datetime.strptime(str(sys.argv[1]), "%Y-%m-%d").date()
    Date1 = datetime.strptime(str(sys.argv[2]), "%Y-%m-%d").date()
    
    #descarga por fechas
    df = pd.read_excel('/home/ioe/anaconda3/envs/marci/bin/MarciFileList.xlsx')
    print('MarciFileList.xlsx loaded')
    
    lista_fechas = [Date0 + timedelta(days=d) for d in range((Date1 - Date0).days + 1)] 
    for fecha in lista_fechas:
        os.system('mkdir MarciGlobe_' + fecha.strftime("%Y-%m-%d"))
        df3 = marci.LimitByDate(df, fecha, fecha + timedelta(days=1))
        df3.to_excel(fecha.strftime("%Y-%m-%d")+ '_MarciFileList.xlsx')
        marci.DownloadResults(df3)
        os.system('mv *.IMG MarciGlobe_' + fecha.strftime("%Y-%m-%d"))
        os.system ('mv ' + fecha.strftime("%Y-%m-%d") + '_MarciFileList.xlsx ' + 'MarciGlobe_' + fecha.strftime("%Y-%m-%d"))
        os.chdir('MarciGlobe_' + fecha.strftime("%Y-%m-%d"))
        os.system('marci2globeA.sh')
        os.system('rm *.cub')        
        os.system('rm *.IMG')        
        os.system('rm *.pgw')
        os.system('rm *.lis')
        os.system('rm *RGB.png')
        os.chdir('../')

        #Crear carpeta y copiar archivos
