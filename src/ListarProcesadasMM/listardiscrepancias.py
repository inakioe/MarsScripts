#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 17 11:52:03 2023

@author: ioe

Este srcipt muestra las discrepancias entre las imágenes globales y las carpetas con las tiras de MeteoMars
"""
import os
import re

def listar_fechas_carpetas(directorio):
    fechas_carpetas = {}
    patron_fecha = r'MarciGlobe_(\d{4}-\d{2}-\d{2})'

    # Listar contenido del directorio
    contenido = os.listdir(directorio)

    # Buscar coincidencias de fechas en nombres de carpetas
    for elemento in contenido:
        ruta_elemento = os.path.join(directorio, elemento)
        if os.path.isdir(ruta_elemento):
            coincidencia = re.search(patron_fecha, elemento)
            if coincidencia:
                fechas_carpetas[coincidencia.group(1)] = elemento

    return fechas_carpetas

def listar_fechas_imagenes(directorio):
    fechas = []
    patron_fecha = r'(\d{4}-\d{2}-\d{2})\.jpg'

    # Listar contenido del directorio
    contenido = os.listdir(directorio)

    # Buscar coincidencias de fechas en nombres de imágenes
    for elemento in contenido:
        ruta_elemento = os.path.join(directorio, elemento)
        if os.path.isfile(ruta_elemento):
            coincidencia = re.search(patron_fecha, elemento)
            if coincidencia:
                fechas.append(coincidencia.group(1))

    return fechas

def crear_script_eliminar_carpetas(directorio, carpetas_no_coincidentes):
    with open("eliminar_carpetas_no_coincidentes.sh", "w") as script:
        script.write("#!/bin/bash\n\n")
        for fecha, nombre in carpetas_no_coincidentes.items():
            script.write(f'rm -r "{os.path.join(directorio, nombre)}"\n')

        print("Script 'eliminar_carpetas_no_coincidentes.sh' creado.")

directorio = "/home/ioe/OneDriveNicdo/SynologyDrive/Ciencia/Marte/MeteoMars/procesadasMWR"

fechas_carpetas = listar_fechas_carpetas(directorio)
fechas_imagenes = listar_fechas_imagenes(directorio)




carpetas_no_coincidentes = {fecha: nombre for fecha, nombre in fechas_carpetas.items() if fecha not in fechas_imagenes}
imagenes_no_coincidentes = [fecha for fecha in fechas_imagenes if fecha not in fechas_carpetas]
crear_script_eliminar_carpetas(directorio, carpetas_no_coincidentes)

print("Fechas de imágenes no coincidentes con carpetas:")
for fecha in imagenes_no_coincidentes:
    print(fecha)

print("Carpetas no coincidentes con imágenes:")
for fecha, nombre in carpetas_no_coincidentes.items():
    print(f"{fecha}: {nombre}")