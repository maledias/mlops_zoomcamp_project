from typing import Dict

import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import FunctionTransformer, OneHotEncoder, StandardScaler


def change_vehicle_age_labels(X: pd.DataFrame):
    transformed_df = X.copy()
    transformed_df["Vehicle_Age"] = transformed_df["Vehicle_Age"].map(
        {
            "1-2 Year": "1_to_2_years",
            "< 1 Year": "less_than_1_year",
            "> 2 Years": "more_than_2_years",
        }
    )
    return transformed_df


ready_to_use_features = ["Driving_License", "Previously_Insured"]

numerical_features = [
    "Age",
    "Annual_Premium",
    "Vintage",
]

categorical_features = [
    "Gender",
    "Region_Code",
    "Vehicle_Age",
    "Vehicle_Damage",
    "Policy_Sales_Channel",
]

column_transformer = ColumnTransformer(
    transformers=[
        (
            "one_hot_encode",
            OneHotEncoder(dtype=int, sparse_output=False),
            categorical_features,
        ),
        ("scaler", StandardScaler(), numerical_features),
        ("passthrough", "passthrough", ready_to_use_features),
    ],
    remainder="drop",
)

preprocessing_pipeline = Pipeline(
    steps=[
        ("rename_vehicle_age_labels", FunctionTransformer(change_vehicle_age_labels)),
        ("transform", column_transformer),
    ],
).set_output(transform="pandas")
