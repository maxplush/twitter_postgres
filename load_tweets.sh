#!/bin/sh

# list all of the files that will be loaded into the database
# for the first part of this assignment, we will only load a small test zip file with ~10000 tweets
# but we will write are code so that we can easily load an arbitrary number of files
files='
test-data.zip
'

echo 'load normalized'
for file in $files; do
    # call the load_tweets.py file to load data into pg_normalized
done

echo 'load denormalized'
for file in $files; do
    echo "Extracting and loading $file into pg_denormalized..."

    # Unzip the file to a temp location (assumes it's a .json file inside)
    unzip -o "$file" -d /tmp/load-denorm

    # Find all JSON files inside the zip
    for json_file in /tmp/load-denorm/*.json; do
        echo "Loading $json_file..."

        # Use COPY command to insert JSON directly
        cat "$json_file" | sed 's/\\u0000//g' | psql "$PG_DENORMALIZED_URL" -c \
        "COPY tweets (json_data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
    done
done
