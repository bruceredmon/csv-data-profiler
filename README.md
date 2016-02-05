# csv-data-profiler
Quick awk script to run against delimited data to take a "best guess" at data types based on the input data

Example:
cat my.csv | awk -F, -v quote_enclosed=true -f data_profile.awk > my.profile.txt
