import os
from argparse import ArgumentParser

import kaggle

from .constants import KAGGLE_DATASET_NAME

if __name__ == "__main__":
    arg_parser = ArgumentParser()
    arg_parser.add_argument(
        "-p",
        "--path",
        type=str,
        help="Path to save the downloaded data to.",
        required=True,
    )
    args = arg_parser.parse_args()
    # Create raw data directory if it doesn't exist
    os.makedirs(args.path, exist_ok=True)

    # Download the dataset
    kaggle.api.authenticate()
    kaggle.api.dataset_download_files(KAGGLE_DATASET_NAME, path=args.path, unzip=True)
