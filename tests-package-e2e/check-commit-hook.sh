#!/bin/bash

# Create target test file
cp -f "tests-e2e/target-find-and-replace.txt.template" "tests-e2e/target-find-and-replace.txt"

# Store the original content of the file
original_content=$(cat tests-e2e/precommit-e2e.test)
echo "Original content: $original_content"

# Run the hook
python find_and_replace_strings/main.py --config tests-e2e/.find-and-replace.json tests-e2e/precommit-e2e.test

# Check if the expected changes have been made
content=$(cat tests-e2e/precommit-e2e.test)
echo "Content after running the hook: $content"

if [[ "$content" != "# exampleproject" ]]; then
    # If the changes are not as expected, print the exit code and exit with a status code of 1
    echo "Exit code: 1"
    exit 1
fi

# Restore the original content of the file
echo "$original_content" > tests-e2e/precommit-e2e.test

# If the changes are as expected, print the exit code and exit with a status code of 0
echo "Exit code: 0"
exit 0
