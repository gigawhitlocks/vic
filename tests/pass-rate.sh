#!/bin/bash
failures=$(drone build list vmware/vic --limit "50" --event push --branch master | grep -i 'Status: failure' | wc -l)
echo "Number of failed merges to master in the last 50 builds: $failures"
successes=$(drone build list vmware/vic --limit "50" --event push --branch master | grep -i 'Status: success' | wc -l)
echo "Number of successful merges to master in the last 50 builds: $successes"

let total=$successes+$failures
passrate=$(bc -l <<< "scale=2;100 * ($successes / $total)")

echo "Current CI passrate: $passrate"
curl --max-time 10 --retry 3 -s -d "payload={'channel': '#vic-bots', 'text': 'Current CI passrate: $passrate%'}" "$SLACK_URL"
