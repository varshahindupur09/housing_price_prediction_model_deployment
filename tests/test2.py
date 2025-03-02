# tests/test2.py
import requests

url = "http://127.0.0.1:5001/predict"

data = {
    "features": [
        60,         # MSSubClass (numeric)
        8450,       # LotArea (numeric)
        5,          # OverallCond (numeric)
        2003,       # YearBuilt (numeric)
        2003,       # YearRemodAdd (numeric)
        0.0,        # BsmtFinSF2 (numeric)
        856.0,      # TotalBsmtSF (numeric)
        "RL",       # MSZoning (categorical)
        "Inside",   # LotConfig (categorical)
        "1Fam",     # BldgType (categorical)
        "VinylSd"   # Exterior1st (categorical)
    ]
}

response = requests.post(url, json=data)
print(response.json())  # Should return a valid prediction or detailed error
