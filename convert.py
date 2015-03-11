import pandas as pd

filename = "cepr_org_2013.dta"

data = pd.io.stata.read_stata(filename)
data.to_csv('cepr_org_2013.csv')