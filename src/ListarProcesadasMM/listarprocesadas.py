#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 17 11:30:05 2023

@author: ioe

Este script lista los huecos entre fechas de las imágenes procesadas para MeteoMars

"""
import os
import re
from datetime import datetime

def is_valid_date(date_string):
    try:
        datetime.strptime(date_string, '%Y-%m-%d')
        return True
    except ValueError:
        return False

def list_jpg_files_with_date(directory):
    jpg_files = []
    date_pattern = re.compile(r"(\d{4}-\d{2}-\d{2})\.jpg")

    for file in os.listdir(directory):
        if file.endswith(".jpg"):
            match = date_pattern.search(file)
            if match and is_valid_date(match.group(1)):
                jpg_files.append(file)

    return jpg_files

def get_date_ranges(jpg_files):
    dates = sorted([datetime.strptime(file.split('.')[0], '%Y-%m-%d') for file in jpg_files])
    date_ranges = []
    start_date = dates[0]
    end_date = dates[0]

    for i in range(1, len(dates)):
        if (dates[i] - end_date).days > 1:
            date_ranges.append((start_date, end_date))
            start_date = dates[i]
        end_date = dates[i]

    date_ranges.append((start_date, end_date))
    return date_ranges

directory = '/home/ioe/OneDriveNicdo/SynologyDrive/Ciencia/Marte/MeteoMars/Data en el server/meteomars/gcp/'
directory = '/home/ioe/OneDriveNicdo/SynologyDrive/Ciencia/Marte/MeteoMars/procesadasMWR'
jpg_files = list_jpg_files_with_date(directory)
date_ranges = get_date_ranges(jpg_files)

for start_date, end_date in date_ranges:
    print(f"{start_date.strftime('%Y-%m-%d')} - {end_date.strftime('%Y-%m-%d')}")
