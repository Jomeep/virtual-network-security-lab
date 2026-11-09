#!/usr/bin/env bash

#Disclaimer: Claude was used to aid with the generation of this script. It was manually reviewed before use.

# Firewall validation: runs the rows of tests.csv that belong to one segment.

# Usage: ./run_tests.sh <Users|Servers|Management|Guests> [tests.csv]

# Run it from a host that sits in that segment. Needs: bash, curl, ping, dig (optional).

# Exit code is non-zero if any test fails, so it can be re-run after every rule change.

  

set -u

SEGMENT="${1:?Usage: $0 <Users|Servers|Management|Guests> [tests.csv]}"

HERE="$(cd "$(dirname "$0")" && pwd)"

CSV="${2:-$HERE/tests.csv}"

OUTDIR="$HERE/results"; mkdir -p "$OUTDIR"

OUT="$OUTDIR/${SEGMENT}-$(date +%Y%m%d-%H%M%S).csv"

HOST="$(hostname)"

  

echo "timestamp,source_host,id,rule,type,target,port,expected,actual,status" > "$OUT"

  

if [[ -t 1 ]]; then G=$'\e[32m'; R=$'\e[31m'; Y=$'\e[33m'; N=$'\e[0m'; else G=; R=; Y=; N=; fi

  

# Each probe prints a single word: the observed result.

probe_tcp() { timeout 4 bash -c "exec 3<>/dev/tcp/$1/$2" 2>/dev/null && echo open || echo closed; }

probe_icmp() { ping -c 1 -W 2 "$1" >/dev/null 2>&1 && echo open || echo closed; }

probe_http() { curl -sk -o /dev/null -w '%{http_code}' --max-time 5 "$1" 2>/dev/null || true; }

probe_dns() {

command -v dig >/dev/null || { echo skip; return; }

local out ip

out=$(dig +short +time=2 +tries=1 @"$2" "$1" A 2>&1) # dig prints its errors on stdout

if grep -qE 'communications error|no servers could be reached|timed out' <<<"$out"; then

echo timeout; return

fi

ip=$(grep -E '^[0-9]+(\.[0-9]+){3}$' <<<"$out" | head -n1)

echo "${ip:-none}"

}

  

pass=0; fail=0; skip=0

  

while IFS=, read -r id seg rule type target port expected desc; do

[[ -z "$id" || "$id" == \#* ]] && continue

[[ "${seg,,}" == "${SEGMENT,,}" ]] || continue

  

case "$type" in

tcp) actual=$(probe_tcp "$target" "$port") ;;

icmp) actual=$(probe_icmp "$target") ;;

http) actual=$(probe_http "$target") ;;

dns) actual=$(probe_dns "$target" "$port") ;;

*) actual=skip ;;

esac

  

if [[ "$actual" == skip ]]; then status=SKIP

elif [[ "$expected" == ANY && "$actual" != none && "$actual" != timeout ]]; then status=PASS

elif [[ "$actual" == "$expected" ]]; then status=PASS

else status=FAIL; fi

  

case "$status" in

PASS) ((pass++)); col=$G ;;

FAIL) ((fail++)); col=$R ;;

SKIP) ((skip++)); col=$Y ;;

esac

  

printf '%s%-4s%s %-7s %-13s %-5s %-22s expected=%-11s actual=%-11s %s\n' \

"$col" "$status" "$N" "$id" "$rule" "$type" "$target" "$expected" "$actual" "$desc"

echo "$(date -Iseconds),$HOST,$id,$rule,$type,$target,$port,$expected,$actual,$status" >> "$OUT"

done < "$CSV"

  

echo

echo "Segment: $SEGMENT | host: $HOST | pass: $pass fail: $fail skip: $skip"

echo "Results saved to: $OUT"

echo "Cross-check blocked tests in OPNsense: Firewall > Log Files > Live View."

[[ $fail -eq 0 ]]

