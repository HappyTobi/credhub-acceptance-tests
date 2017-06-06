#!/bin/bash

set -eu

cat <<EOF > config.json
{
  "api_url": "https://${API_IP}:8844",
  "api_username":"${USERNAME}",
  "api_password":"${PASSWORD}",
  "bosh": {
    "host":"${API_IP}:22",
    "bosh_ssh_username":"${BOSH_SSH_USERNAME}",
    "bosh_ssh_private_key_path":"${BOSH_SSH_PRIVATE_KEY_PATH}"
  },
  "credential_root":"${CREDENTIAL_ROOT}",
  "uaa_ca":"${UAA_CA}"
}
EOF

ginkgo -r -p bbr_integration_test