#!/bin/sh
curl -s -o /dev/null \
  -H "Authorization: Bearer ${NTFY_TOKEN}" \
  -H "Title: Portainer: Stack Deployed" \
  -d "Stack '${STACK_NAME}' was deployed successfully" \
  "${NTFY_URL}/portainer-updates"
