# training/train_model2.py trains a RandomForestRegressor model on the HousePricePrediction dataset.
import pandas as pd
import joblib
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split

# Load the dataset
dataset = pd.read_excel("HousePricePrediction.xlsx")

# Handling missing values
dataset['SalePrice'] = dataset['SalePrice'].fillna(dataset['SalePrice'].mean()) 
new_dataset = dataset.dropna()

# Identify categorical variables (excluding MSSubClass since it's numeric)
categorical_cols = new_dataset.select_dtypes(include=['object']).columns.tolist()
print("Categorical variables:", categorical_cols)

# Apply Label Encoding only to categorical variables
label_encoders = {}
for col in categorical_cols:
    le = LabelEncoder()
    new_dataset[col] = le.fit_transform(new_dataset[col])
    label_encoders[col] = le  # Save encoder for API use

# Save label encoders
joblib.dump(label_encoders, "label_encoders.pkl")

# Define features and target variable
X = new_dataset.drop(columns=["Id", "SalePrice"]) #features
Y = new_dataset["SalePrice"]

# Split into train and validation sets
X_train, X_valid, Y_train, Y_valid = train_test_split(X, Y, test_size=0.2, random_state=42)

# Scale only numerical features (excluding categorical ones)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_valid_scaled = scaler.transform(X_valid)

# Train the RandomForestRegressor
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train_scaled, Y_train)

# Save the trained model and scaler
joblib.dump(model, "model.pkl")
joblib.dump(scaler, "scaler.pkl")

print("Model trained and saved successfully!")
