#!/bin/bash

SHARED_JSON="_shared.json"
HUGO_FILE="../hugo.toml"

# Function to create backup files for each .toml file
create_bkp_files() {
    mkdir -p tmp
    cp *.toml tmp
    cp *.json tmp
    cd tmp
}

# Function to read shared information from SHARED_JSON and store in a file
read_shared_info() {
    jq -r 'to_entries[] | .key + "=" + .value' "$SHARED_JSON" > shared_info.txt
}

delete_shared_info() {
    rm -f shared_info.txt
    rm -rf tmp
}

# Function to replace values in each .toml file
replace_values() {
    local file="$1"
    local shared_info_file="shared_info.txt"
    while IFS="=" read -r key value; do
        sed -i.bak "s/\[$key\]/$value/g" "$file"
    done < "$shared_info_file"
}

merge_toml_files() {
    cd ..
    cat tmp/*.toml > lang.toml
}


# Main function
main() {
    cd languages
    create_bkp_files
    read_shared_info
    for file in *.toml; do
        replace_values "$file"
    done
    merge_toml_files
    delete_shared_info
    cd ..
    cat main.toml languages/lang.toml social.toml > $HUGO_FILE
    rm languages/lang.toml
}

main

echo "Combined .toml files into $HUGO_FILE"
