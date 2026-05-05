#!/bin/sh
curl -s -o /dev/null \
  -H "Authorization: Bearer ${NTFY_TOKEN}" \
  -H "Title: Watchtower Update" \
  -d "${UPDATE_MESSAGE}" \
  "${NTFY_URL}/watchtower-updates"
