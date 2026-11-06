#!/bin/sh
# Keep the Travis job open until its own archived log contains the sbt test
# summary, so the build-log harvester (which reads the log as soon as the build
# finishes) sees the complete test output. Cannot change the build result.
URL="https://api.travis-ci.com/v3/job/${TRAVIS_JOB_ID}/log.txt"
PATTERN='(Passed|Failed|Error): Total [0-9]'
waited=0
while [ "$waited" -lt 1500 ]; do
  if curl -s "$URL" | grep -Eq "$PATTERN"; then
    echo "log archive contains the test summary (after ${waited}s)"
    exit 0
  fi
  echo "waiting for log archive... (${waited}s)"
  sleep 20
  waited=$((waited + 20))
done
echo "gave up waiting for log archive after ${waited}s"
exit 0
