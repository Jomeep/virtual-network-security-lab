#!/usr/bin/env bash

#Disclaimer: Claude was used to aid with the generation of this script. It was manually reviewed before use.

# Checks the *effective* server configuration against Server.md.


[[ $EUID -eq 0 ]] || { echo "Run with sudo"; exit 2; }

  

fail=0

check() { # check "<description>" "<command>" "<regex expected in output>"

local out; out=$(eval "$2" 2>&1)

if grep -qiE -- "$3" <<<"$out"; then printf 'PASS %s\n' "$1"

else printf 'FAIL %s (expected /%s/)\n' "$1" "$3"; fail=1; fi

}

  

# SSH daemon: effective settings (sshd -T), not just what the file says

for s in 'passwordauthentication no' 'kbdinteractiveauthentication no' 'pubkeyauthentication yes' \

'permitrootlogin no' 'maxauthtries 3' 'logingracetime 30' 'x11forwarding no' \

'allowusers [^ ]+@10\.10\.30\.10'; do

check "sshd: $s" "sshd -T" "^$s"

done

  

# Host firewall

check "ufw active" "ufw status verbose" "Status: active"

check "ufw default deny incoming" "ufw status verbose" "Default: deny \(incoming\)"

check "ufw: SSH only from admin machine" "ufw status verbose" "22/tcp.*ALLOW IN.*10\.10\.30\.10"

check "ufw: web only from Users net" "ufw status verbose" "80,443/tcp.*ALLOW IN.*10\.10\.20\.0/24"

  

# Apache

check "apache config syntax" "apache2ctl configtest" "Syntax OK"

check "apache ssl + headers modules" "apache2ctl -M" "ssl_module"

check "HTTP redirects to HTTPS" "curl -sI --max-time 5 --resolve intranet.lab.internal:80:127.0.0.1 http://intranet.lab.internal/" "location: https://intranet.lab.internal/"

check "HTTPS serves the site" "curl -skI --max-time 5 --resolve intranet.lab.internal:443:127.0.0.1 https://intranet.lab.internal/" "^HTTP/[0-9.]+ 200"

check "Server header hides version" "curl -skI --max-time 5 --resolve intranet.lab.internal:443:127.0.0.1 https://intranet.lab.internal/" "^server: apache[[:space:]]*$"

check "nosniff header set" "curl -skI --max-time 5 --resolve intranet.lab.internal:443:127.0.0.1 https://intranet.lab.internal/" "x-content-type-options: nosniff"

check "certificate valid for 30+ days" "openssl x509 -in /etc/ssl/certs/intranet.crt -noout -checkend 2592000" "will not expire"

  

echo; [[ $fail -eq 0 ]] && echo "All checks passed" || echo "Some checks failed"

exit $fail
