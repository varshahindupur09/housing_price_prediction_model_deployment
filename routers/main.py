from flask import Flask, request, jsonify
import joblib
import numpy as np
import os
import pandas as pd

# Get the absolute path of the current file (main.py)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Load trained model and preprocessing objects
model = joblib.load(os.path.join(BASE_DIR, "model.pkl"))
scaler = joblib.load(os.path.join(BASE_DIR, "scaler.pkl"))
label_encoders = joblib.load(os.path.join(BASE_DIR, "label_encoders.pkl"))

# Load dataset structure to get feature names
dataset = pd.read_excel(os.path.join(BASE_DIR, "../training/HousePricePrediction.xlsx"))

# Identify categorical and numeric columns
categorical_cols = dataset.select_dtypes(include=['object']).columns.tolist()
numeric_cols = dataset.select_dtypes(include=['int64', 'float64']).columns.tolist()
# numeric_cols.remove("SalePrice")  # Exclude target variable
# Exclude 'Id' and 'SalePrice' from numeric columns
numeric_cols = [col for col in numeric_cols if col not in ['Id', 'SalePrice']]

feature_names = numeric_cols + categorical_cols  # Ensure correct feature order

print("Categorical variables:", categorical_cols)
print("Numeric variables:", numeric_cols)
print("Feature names (Final Order):", feature_names)

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get JSON request data
        data = request.get_json()
        features = np.array(data['features']).reshape(1, -1).tolist()[0]  # Convert to list

        # Debug: Print feature lengths
        print("Length of features:", len(features))
        print("Length of feature_names:", len(feature_names))

        print("Features before encoding:", features)
        # Encode categorical features properly
        for col in categorical_cols:
            col_index = feature_names.index(col)  # Get index of categorical feature
            le = label_encoders[col]
            print(f"Encoding {col}: {features[col_index]} -> {le.transform([features[col_index]])[0]}")

            if features[col_index] not in le.classes_:
                print(f"Unseen category '{features[col_index]}' in {col}, assigning default: {le.classes_[0]}")
                features[col_index] = le.classes_[0]  # Assign default category

            print("Features after encoding:", features)
            
            # Convert categorical values to numeric
            features[col_index] = le.transform([features[col_index]])[0]

        # Convert all values to float after encoding categorical features
        features = np.array(features, dtype=float).reshape(1, -1)

        # Scale numerical features
        features_scaled = scaler.transform(features)

        # Predict
        prediction = model.predict(features_scaled)[0]

        return jsonify({'prediction': float(prediction)})

    except Exception as e:
        import traceback
        error_message = traceback.format_exc()  # Get full error traceback
        print("Error occurred:", error_message)  # Print detailed error
        return jsonify({'error': str(e), 'traceback': error_message}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5001)
