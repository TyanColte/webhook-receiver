#!/bin/sh
# Notify ntfy of GitHub push
curl -s -o /dev/null \
  -H "Authorization: Bearer ${NTFY_TOKEN}" \
  -H "Title: GitHub Push: ${REPO_NAME}" \
  -d "${PUSHER_NAME}: ${COMMIT_MSG}" \
  "${NTFY_URL}/github-updates"

# If caddy files were modified, notify then restart caddy (notify first — restart takes caddy down)
if echo "${MODIFIED_FILES}" | grep -qi "caddy"; then
  curl -s -o /dev/null \
    -H "Authorization: Bearer ${NTFY_TOKEN}" \
    -H "Title: Caddy Reloading" \
    -d "Caddyfile updated — restarting Caddy" \
    "${NTFY_URL}/caddy-updates"
  curl -s --unix-socket /var/run/docker.sock -X POST "http://localhost/containers/caddy/restart"
fi
