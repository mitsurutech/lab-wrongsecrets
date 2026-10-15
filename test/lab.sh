#!/usr/bin/env bash
# What the README promises, checked from inside the lab's own network: run by check.sh.
set -euo pipefail
: "${NET:?run through test/check.sh}"
probe() { docker run --rm --network "$NET" wrongsecrets-check-probe bash -c "$1"; }
echo "- the application is up, with its challenges listed"
probe '
set -eu
B=http://wrongsecrets:8080
curl -fs $B/actuator/health | grep -q UP
for n in 0 16 42; do
  code=$(curl -s -o /dev/null -w "%{http_code}" $B/challenge/challenge-$n)
  [ "$code" = 200 ] || { echo "challenge $n answered $code" >&2; exit 1; }
done
echo "- challenge 16: the front-end script the README tells a student to read is served"
curl -fs $B/js/index.js | grep -q "function secret"
echo "- challenge 42: the actuator the README mentions lists its audit events"
curl -fs $B/actuator | grep -q "actuator/auditevents"
echo "- a wrong answer is refused and the right one for challenge 0 is accepted"
j=/tmp/j
tok=$(curl -fs -c $j -b $j $B/challenge/challenge-0 | sed -n "s/.*name=\"_csrf\" value=\"\([^\"]*\)\".*/\1/p")
[ -n "$tok" ] || { echo "no csrf token on challenge 0" >&2; exit 1; }
curl -s -c $j -b $j --data-urlencode "solution=nope" --data-urlencode "action=submit" --data-urlencode "_csrf=$tok" $B/challenge/challenge-0 | grep -q "Your answer is incorrect" || { echo "a wrong answer was not refused" >&2; exit 1; }
curl -s -c $j -b $j --data-urlencode "solution=The first answer" --data-urlencode "action=submit" --data-urlencode "_csrf=$tok" $B/challenge/challenge-0 | grep -q "Your answer is correct" || { echo "challenge 0 refused its own answer" >&2; exit 1; }
'
echo "  ok"
