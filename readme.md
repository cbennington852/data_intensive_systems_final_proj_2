## Steps to reproduce
1. **Download and extract** [this kaggle dataset](https://www.kaggle.com/datasets/hhs/health-insurance-marketplace?select=Rate.csv). 

2. **Create a project!** Create a project, and then switch to that project.
* To run the next step you will need the project id.

3. **Run the following shell script.** If your system does not support unix shell scripts, you can just copy and paste the commands into your terminal. This needs to be run in the same directory that you extracted the .csv to.

Make sure to replace the "final-project-492620" with whatever your project id was from step 2.
```
./ingest_data.sh
```

4. **Run the "CleanBenfitsCostSharing.sql".** The easiest way to do this is to copy and paste the .sql file into the bigquery query console.

5. **Run the "MillionDollarRates.sql".** Similar to the last script, the easiest way to do this is to copy and paste the .sql file into the bigquery query console.

6. **Run the AnalyticalQueries.sql**
This .sql file contains all of the SQL queries I used to make the three looker studio dashboards. the easiest way to run this is to copy and paste the .sql file into the bigquery query console.

## Looker Studio 
- https://datastudio.google.com/reporting/5bed9896-8a07-4dca-90b1-4553af40d391
- https://datastudio.google.com/u/0/reporting/7d812bfe-e208-43e5-86fa-acbfd7894d1a/page/KCduF
- https://datastudio.google.com/u/0/reporting/045af727-0615-4a2d-bb1b-51c02b933d6b/page/7dSvF

## Website with embedded views

[Link to website]()

## About the Author
Charles Bennington
https://www.charlesbennington.com/
*Website Updated Infrequently*