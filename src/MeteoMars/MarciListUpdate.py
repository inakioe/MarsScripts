#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 14 11:27:56 2021

@author: ioe
"""
import requests
import pandas as pd
import ssl
from tqdm import tqdm

import warnings
warnings.filterwarnings("ignore")


def get_url_paths(url, ext='', params={}):
    import requests
    from bs4 import BeautifulSoup
    response = requests.get(url, verify=False)
    if response.ok:
        response_text = response.text
    else:
        return response.raise_for_status()
    soup = BeautifulSoup(response_text, 'html.parser')
    parent = [url + node.get('href') for node in soup.find_all('a') if node.get('href').endswith(ext)]
    return parent

ssl._create_default_https_context = ssl._create_unverified_context
#url_base = 'https://pdsimage2.wr.usgs.gov/Missions/Mars_Reconnaissance_Orbiter/MARCI/mrom_'
url_base = 'https://pds-imaging.jpl.nasa.gov/data/mro/mars_reconnaissance_orbiter/marci/mrom_'
c = ["VOLUME_ID", "FILE_SPECIFICATION_NAME", "ORIGINAL_PRODUCT_ID", "PRODUCT_ID", "IMAGE_TIME", "INSTRUMENT_ID", "FILTER_NAME", "LINE_SAMPLES", "LINES", "SPATIAL_SUMMING", "SCALED_PIXEL_WIDTH", "PIXEL_ASPECT_RATIO", "EMISSION_ANGLE", "INCIDENCE_ANGLE", "PHASE_ANGLE", "CENTER_LONGITUDE", "CENTER_LATITUDE", "UPPER_LEFT_LONGITUDE", "UPPER_LEFT_LATITUDE", "UPPER_RIGHT_LONGITUDE", "UPPER_RIGHT_LATITUDE", "LOWER_LEFT_LONGITUDE", "LOWER_LEFT_LATITUDE", "LOWER_RIGHT_LONGITUDE", "LOWER_RIGHT_LATITUDE", "MISSION_PHASE_NAME", "TARGET_NAME", "SPACECRAFT_CLOCK_START_COUNT", "FOCAL_PLANE_TEMPERATURE", "LINE_EXPOSURE_DURATION", "INTERFRAME_DELAY", "SAMPLE_FIRST_PIXEL", "SCALED_IMAGE_WIDTH", "SCALED_IMAGE_HEIGHT", "SPACECRAFT_ALTITUDE", "TARGET_CENTER_DISTANCE", "SLANT_DISTANCE", "USAGE_NOTE", "NORTH_AZIMUTH", "SUB_SOLAR_AZIMUTH", "SUB_SOLAR_LONGITUDE", "SUB_SOLAR_LATITUDE", "SUB_SPACECRAFT_LONGITUDE", "SUB_SPACECRAFT_LATITUDE", "SOLAR_DISTANCE", "SOLAR_LONGITUDE", "LOCAL_TIME", "IMAGE_SKEW_ANGLE", "RATIONALE_DESC", "DATA_QUALITY_DESC", "ORBIT_NUMBER"]
df00 = pd.DataFrame(columns = c)

#result = get_url_paths('https://pdsimage2.wr.usgs.gov/Missions/Mars_Reconnaissance_Orbiter/MARCI/', 'txt')
result = get_url_paths('https://pds-imaging.jpl.nasa.gov/data/mro/mars_reconnaissance_orbiter/marci/', 'txt')
LastFolder = int(result[-1].split('_md5.txt')[0][-4:])



for i in tqdm(range(611, LastFolder + 1)):
    if i != 611:
        url = url_base + str(i).zfill(4) + '/index/index.tab'
        response = requests.get(url, verify = False)
        data = response.text
        df01 = pd.read_csv(url, names=c, header=None)
        mask = (df01['FILTER_NAME'] != u'UV   ')
        df01 = df01.loc[mask]
        frames = [df00, df01]
        df00 =pd.concat(frames)
        df00 = df00.reset_index(drop=True)
        
df00.to_excel('/home/ioe/anaconda3/envs/marci/bin/MarciFileList.xlsx')
