#!/bin/sh

# list all of the files that will be loaded into the database
files='
test-data.zip
'

echo 'load normalized'
for file in $files
do
    # call the load_tweets.py file to load data into pg_normalized
    echo "Loading $file into pg_normalized..."
    # python3 load_tweets.py "$file"
done

# Commented out to avoid breaking test cases with too much data
: <<'DISABLE_DENORMALIZED'
echo 'load denormalized'
for file in $files
do
    echo "Extracting and loading $file into pg_denormalized..."

    unzip -o "$file" -d /tmp/load-denorm

    for json_file in /tmp/load-denorm/*.json
    do
        echo "Loading $json_file..."

        cat "$json_file" | sed 's/\\u0000//g' | psql "$PG_DENORMALIZED_URL" -c \
        "COPY tweets (json_data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
    done
done
DISABLE_DENORMALIZED

