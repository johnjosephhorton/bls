import pandas as pd

from os import walk
import os.path

path = "data/"

f = []
for (dirpath, dirnames, filenames) in walk(path):
    for file in filenames:
        (fname, ext) = os.path.splitext(file)
        if ext == ".dta":
            input_file = os.path.join(dirpath, file)
            data = pd.io.stata.read_stata(input_file)

            output_file = os.path.join(dirpath, '.'.join([fname, "csv"]))
            data.to_csv(output_file)
            print(fname, " - done.")
    break
