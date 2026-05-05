#!/bin/sh
# Notify ntfy of GitHub push
curl -s -o /dev/null \
  -H "Authorization: Bearer ${NTFY_TOKEN}" \
  -H "Title: GitHub Push: ${REPO_NAME}" \
  -d "${PUSHER_NAME}: ${COMMIT_MSG}" \
  "${NTFY_URL}/github-updates"

# If caddy files were modified, restart caddy and notify
if echo "${MODIFIED_FILES}" | grep -qi "caddy"; then
  curl -s --unix-socket /var/run/docker.sock -X POST "http://localhost/containers/caddy/restart"
  curl -s -o /dev/null \
    -H "Authorization: Bearer ${NTFY_TOKEN}" \
    -H "Title: Caddy Reloaded" \
    -d "Caddyfile updated — Caddy restarted" \
    "${NTFY_URL}/caddy-updates"
fi
