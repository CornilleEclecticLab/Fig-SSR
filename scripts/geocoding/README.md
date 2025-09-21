scripts/geocoding/README.md
# geocoding

Purpose:  
Convert site or locality names into geographic coordinates (latitude/longitude) using the Google Geocoding API. The script takes an Excel file with address information, queries the API, and appends new columns with coordinates.

---

Key files:
- `geocoding.py` — Python script for geocoding site metadata
- Input file: Excel (.xls) with site IDs and address/location text
- Output file: Excel (.xlsx) with original data plus latitude and longitude

---

How to run:
1. Open `geocoding.py` and replace the placeholder `API_KEY = 'ABC'` with your valid Google Geocoding API key.
2. Place your input `.xls` file in the working directory.
3. Activate the environment:
   ```bash
   mamba activate fig-ssr
4.	Run:
python geocoding.py

Inputs/outputs:
	Input:
	•	Excel file with at least one column containing address or location text
  Output:
	•	New Excel file with the original data plus two new columns: Latitude and Longitude
	•	Saved to the specified output path