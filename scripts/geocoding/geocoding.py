import pandas as pd
import requests

API_KEY = 'YOUR_API_KEY'  

input_file  = 'fig_ssr_data_sanzhar.xls'
output_file = 'geocoded_file.xlsx'

df = pd.read_excel(input_file, engine='xlrd')
df.columns = df.columns.str.strip()

address_column   = 'Address'
latitude_column  = 'Latitude'
longitude_column = 'Longitude'

if latitude_column not in df.columns:
    df[latitude_column] = None
if longitude_column not in df.columns:
    df[longitude_column] = None

def get_coordinates(address):
    url = f"https://maps.googleapis.com/maps/api/geocode/json?address={address}&key={API_KEY}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        if data['results']:
            loc = data['results'][0]['geometry']['location']
            return loc['lat'], loc['lng']
    return None, None

for idx, row in df.iterrows():
    addr = row[address_column]
    if pd.notna(addr):
        print(f"Geocoding address: {addr}")
        lat, lng = get_coordinates(addr)
        if lat and lng:
            df.at[idx, latitude_column]  = lat
            df.at[idx, longitude_column] = lng
            print(f"  → ({lat}, {lng})")
        else:
            print(f"  ✗ not found")

df.to_excel(output_file, index=False, engine='openpyxl')
print(f"Saved geocoded data to {output_file}")
