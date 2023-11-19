from pathlib import Path
import pandas as pd

_g = globals()

# Create a Path object for the directory
dir_path = Path('C:/Users/Benito/Downloads/MaterialCursos-master/MaterialCursos-master/')

# Iterate over CSV files in the directory
for file in dir_path.glob('**/*.csv'):
    # print(file.stem.replace("public ", "") )
    # Read the CSV file into a DataFrame
    df = pd.read_csv(file, sep=None, engine='python')

    # Extract the file name without extension
    file_name = file.stem

    # Assign the DataFrame to the dictionary with the file name as key
    _g[file.stem.replace("public ", "")] = df
