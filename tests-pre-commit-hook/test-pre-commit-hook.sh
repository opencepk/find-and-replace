#!/usr/bin/env bash

TEST_DIR="tests-pre-commit-hook"
TEST_SCRIPT_FILENAME=$(basename -- "$0")
TEST_SCRIPT_NAME="${TEST_SCRIPT_FILENAME%.*}"
TEST_TARGET_FILE="README_TEST_PRE_COMMIT.md"

#-------------------------------
# Run the pre-commit hook test
#-------------------------------
echo "${TEST_SCRIPT_NAME}: Running pre-commit using ${TEST_DIR}/.pre-commit-config.yaml"
(cd .. && pre-commit run -a -c "${TEST_DIR}/.pre-commit-config.yaml")

#-------------------------------
# Evaluate results
#-------------------------------
echo "${TEST_SCRIPT_NAME}: Running (cd ${TEST_DIR} && diff ${TEST_TARGET_FILE} ${TEST_TARGET_FILE}.expected)"
echo "${TEST_SCRIPT_NAME}: Fetching return code of diff"
diff "./${TEST_TARGET_FILE}" "${TEST_TARGET_FILE}.expected"
evaluate_diff_status=$?

#-------------------------------
# Run the pre-commit hook reset
#-------------------------------
echo "${TEST_SCRIPT_NAME}: Resetting ${TEST_DIR}/${TEST_TARGET_FILE} file to original state"
cp -pf "${TEST_TARGET_FILE}.template" "${TEST_TARGET_FILE}"

#-------------------------------
# Exit with exit code of diff evaluation
#-------------------------------
echo "${TEST_SCRIPT_NAME}: Exit code = $evaluate_diff_status"
exit $evaluate_diff_status
