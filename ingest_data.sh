bq mk --dataset --location=US final-project-492620:verify_final_project_pipeline


bq load \
    --replace \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    --schema=schema.json \
    verify_final_project_pipeline.BenefitsCostSharing \
    BenefitsCostSharing.csv

bq load \
    --autodetect \
    --replace \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    verify_final_project_pipeline.BusinessRules \
    BusinessRules.csv


bq load \
    --autodetect \
    --replace \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    verify_final_project_pipeline.Network \
    Network.csv

bq load \
    --autodetect \
    --replace \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    verify_final_project_pipeline.Rate \
    Rate.csv

bq load \
    --autodetect \
    --replace \
    --max_bad_records=1000 \
    --allow_quoted_newlines \
    verify_final_project_pipeline.ServiceArea \
    ServiceArea.csv
