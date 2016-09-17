#!/bin/bash

set -ex

# add root ca
cat >> /etc/ssl/certs/ca-certificates.crt <<EOF
-----BEGIN CERTIFICATE-----
MIIDyzCCArOgAwIBAgIUUH9NMMgv8OC6vdGN0ul9fTzIBpMwDQYJKoZIhvcNAQEL
BQAwgZQxHTAbBgNVBAoMFFBpdm90YWwgQ3JlZEh1YiBUZWFtMQswCQYDVQQIDAJD
QTELMAkGA1UEBhMCVVMxJzAlBgNVBAMMHlBpdm90YWwgQ3JlZEh1YiBEZXZlbG9w
bWVudCBDQTEYMBYGA1UECwwPQ3JlZEh1YiBSb290IENBMRYwFAYDVQQHDA1TYW4g
RnJhbmNpc2NvMB4XDTE2MDkwOTIzMTMyOVoXDTE3MDkwOTIzMTMyOVowgZQxHTAb
BgNVBAoMFFBpdm90YWwgQ3JlZEh1YiBUZWFtMQswCQYDVQQIDAJDQTELMAkGA1UE
BhMCVVMxJzAlBgNVBAMMHlBpdm90YWwgQ3JlZEh1YiBEZXZlbG9wbWVudCBDQTEY
MBYGA1UECwwPQ3JlZEh1YiBSb290IENBMRYwFAYDVQQHDA1TYW4gRnJhbmNpc2Nv
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhZN/2O6Yij0zb5RSHnBk
7xObY4yHPFWA0pUuYK8hUSLlbyPz7OsSw2zmIRAza7jQ6HO5RBjFkXo3RuHSnu+Y
W5+YP7GzLo13Hpq58kyoVbYxy5aaX5vIQnkacOo/PXAI18Cb/RVuCyvrSalYGNhc
hp/us1TyHHhiM84/mcxMuQWXDOLVI78p+iSQ5VvGBBPWe6wJ7dYPNR1rbLpyVhAG
J/5XfEln+s2JMy+9uT7EOyYuMGJ7f42g9ZkaXYSZjkr9jNA2QoyL2TESaldBM7nv
lVUy94WQUQwwddVZ9Zz0nMO0jrzvJefoDZhrgKA8aZ1HfyHbzofHzzAuuvx95S5Z
ywIDAQABoxMwETAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBV
IhijrH8Q/iQOSwfkctTQ/y1jjDKXJYhmAMRfWjpgVQErJmh26/b3W8Z79HRW81J6
DOvWXP5ipuaCln3/1TpZ+fbvhq4455NkCg3Sd5Jg8UJZgk8G4Ajacwr2Co4nEw+u
37NL8y/khme5FIGfBTaaillY7dILWVApUf9kAs/66Scn1WGH6eKoYbFc0Ihjgfqm
Z66j42ElaTHee2aW9D1MtmWrN2biKt5P2BDFZjgFdfKWVE5ZbBOXu5E0vyEnOA+1
PMkj8Mn80l+rLZmjltFdP+2OKzJLsDelB/TMGskWBOwdz125ICw31QldqPffygSD
9Y0zSr/HiQn6H6wMIifS
-----END CERTIFICATE-----
EOF

export GOPATH=$PWD/go
export PATH=$PATH:$GOPATH/bin

cd go/src/github.com/pivotal-cf/credhub-cli
make dependencies
cd ../cred-hub-acceptance-tests
go get github.com/onsi/gomega

cat > config.json <<EOF
{
  "api_url": "$API_URL"
}
EOF

ginkgo -r integration
