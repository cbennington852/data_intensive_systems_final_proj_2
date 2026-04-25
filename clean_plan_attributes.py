import pandas as pd
import os

chunk_size = 30000
file_name = 'PlanAttributes.csv'
cleaned_file_name = 'CleanPlanAttributes.csv'



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

final_cols = set()

curr_index = 0
for chunk in pd.read_csv(file_name, chunksize=chunk_size):
    print(chunk.head())
    # Apply cleaning steps to 'chunk'

    tmp = set(chunk.columns[chunk.eq('Yes').any()])
    final_cols = final_cols.union(tmp) 
    print(len(tmp))

    print("Type : " , chunk['PlanEffictiveDate'].dtype)
    print("Type : " , chunk['PlanExpirationDate'].dtype)

    chunk['PlanEffictiveDate'] = pd.to_datetime(chunk['PlanEffictiveDate'] , format='mixed')
    chunk['PlanExpirationDate'] = pd.to_datetime(chunk['PlanExpirationDate'] , format='mixed')

    chunk['PlanDuration_Days'] = (chunk['PlanExpirationDate'] - chunk['PlanExpirationDate']).dt.days

    cols_to_clean_y_n = ['NationalNetwork', 'SpecialistRequiringReferral', 'UniquePlanDesign', 'WellnessProgramOffered', 'IsHSAEligible', 'DentalOnlyPlan', 'MedicalDrugMaximumOutofPocketIntegrated', 'MultipleInNetworkTiers', 'CompositeRatingOffered', 'MedicalDrugDeductiblesIntegrated', 'HSAOrHRAEmployerContribution', 'IsReferralRequiredForSpecialist', 'OutOfServiceAreaCoverage', 'OutOfServiceAreaCoverageDescription', 'IsNoticeRequiredForPregnancy', 'OutOfCountryCoverage']

    for col in cols_to_clean_y_n:
        chunk[col] = chunk[col].apply(clean_yes_and_no)

    chunk = chunk.drop('ImportDate' , axis=1)
    for col in chunk.columns:
        if col.startswith("TEH") or col.startswith("SBC") or col.startswith("MEH") or col.startswith("DEH"):
            chunk[col] = chunk[col].apply(clean_int_vals)
    chunk.to_csv(cleaned_file_name, mode='a', header=not os.path.exists( cleaned_file_name), index=False)
    
print("Silly Invalid yes and no cols ")
print(final_cols)

#################################################
# Benfitis Cost Sharing
#################################################

