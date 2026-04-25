import pandas as pd
import os
from wordcloud import WordCloud
import pandas as pd
from wordcloud import WordCloud, STOPWORDS
from collections import Counter
import matplotlib.pyplot as plt
import math
import random

chunk_size = 30000
file_name = 'BenefitsCostSharing.csv'
cleaned_file_name = 'CleanBenefitsCostSharing.csv'




if os.path.exists(cleaned_file_name):
    os.remove(cleaned_file_name)
    print("File deleted.")
else:
    print("The file does not exist.")

def clean_int_vals(val):
    if type(val) == int or type(val) == float:
        return val
    else:
        return 0
    
def clean_yes_and_no(val):
    if val == "Yes":
        return True 
    elif val == "No":
        return False
    else:
        return None
# Load your local CSV
def handle_child_or_adult(val : str):
    if "Child" in val and "Adult" in val:
        return "Both"
    elif "Child" in val:
        return "Child Only"
    elif "Adult" in val:
        return "Adult Only"
    else:
        return "Not Specified"

wc = WordCloud(background_color='white', stopwords=STOPWORDS , max_words = 10)
total_counts = Counter()


def settle_coins(value):
    # if int(random.random() * 3000) == 67:
    #     print("Coin input : " , value , type(value))
    

    if pd.isna(value):
        return None
    # Remove the strings.
    if type(value) == str and 'Coinsurance after deductible' in value:
        value = value.replace('Coinsurance after deductible' , '')

    if "Copay" in value:
        curr_val = 20 + random.randrange(-10 , 10)
        return f"{curr_val}%"

    if value == '$0':
        return "100%"
    elif value == 'No Charge after deductible':
        return "100%"
    elif value == 'Not Applicable':
        return "0%"
    elif value == 'No Charge':
        return "100%"
    else:
        return value

list_coins_process = {
    'CoinsInnTier1' : str,
    'CoinsInnTier2' : str,
    'CoinsOutofNet' : str,
    'CopayInnTier2' : str,
    'CopayInnTier1' : str,
}

curr_index = 0
for chunk in pd.read_csv(file_name, chunksize=chunk_size , dtype=list_coins_process):
    #print(chunk.head())
    text_chunk = " ".join(chunk['BenefitName'].astype(str))
    
    chunk['AgeGroupType'] = chunk['BenefitName'].apply(handle_child_or_adult)

    

    for coin_col , type_col in list_coins_process.items():
        chunk[coin_col] = chunk[coin_col].astype("string")

    for coin_col , type_col in list_coins_process.items():
        chunk[coin_col] = chunk[coin_col].apply(settle_coins)

    cols_to_clean_y_n = ['IsEHB' , 'IsExclFromInnMOOP','IsExclFromOonMOOP','IsStateMandate','IsSubjToDedTier1','IsSubjToDedTier2', 'IsCovered']

    for col in cols_to_clean_y_n:
        chunk[col] = chunk[col].apply(clean_yes_and_no)


    chunk = chunk.drop('ImportDate' , axis=1)
    chunk = chunk.drop('Explanation' , axis=1)

    chunk.to_csv(cleaned_file_name, mode='a', header=not os.path.exists( cleaned_file_name), index=False)


# 3. Generate the cloud from the combined frequencies
# wc.generate_from_frequencies(total_counts)

# # 4. Display the result
# plt.figure(figsize=(10, 5))
# plt.imshow(wc, interpolation='bilinear')
# plt.axis("off")
# plt.show()
