ERROR() {
  local rc=$1
  local message=$2
  if [ "$rc" -ne "0" ]; then
    echo "$message" || exit "$rc"
  fi
}

SendMessage() {
  which curl > /dev/null || ERROR $? "curl is needed, please install it."

  if [ -z "${PARAM_WEBHOOK_URL}" ]; then
    echo "No Webhook url provided".
    echo "Please input your MS_TEAMS_WEBHOOK_URL value either in the settings for this project, or as a parameter for this orb."
    exit 1
  fi

  curl -H "Content-Type: application/json" \
          -X POST \
          -d "{ \"title\": \"${PARAM_TITLE}\", \
                \"summary\": \"${PARAM_SUMMARY}\", \
                \"text\": \"${PARAM_TEXT}\" }" \
          "${PARAM_WEBHOOK_URL}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    SendMessage
fi