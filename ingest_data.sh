bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    --schema=schema.json \
    final_project.BenefitsCostSharing \
    BenefitsCostSharing.csv

bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    final_project.BusinessRules \
    BusinessRules.csv

bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    final_project.CleanAttributes \
    CleanAttributes.csv

bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    final_project.Crosswalk2015 \
    Crosswalk2015.csv

bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    final_project.Crosswalk2016 \
    Crosswalk2016.csv

bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    final_project.Network \
    Network.csv

bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    final_project.Rate \
    Rate.csv

bq load \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    final_project.ServiceArea \
    ServiceArea.csv
