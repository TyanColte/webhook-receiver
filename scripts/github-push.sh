#!/bin/sh
# Notify ntfy of GitHub push
curl -s -o /dev/null \
  -H "Authorization: Bearer ${NTFY_TOKEN}" \
  -H "Title: GitHub Push: ${REPO_NAME}" \
  -d "${PUSHER_NAME}: ${COMMIT_MSG}" \
  "${NTFY_URL}/github-updates"

# If vikunja stack files were modified, trigger Portainer redeploy
if echo "${MODIFIED_FILES}" | grep -qi "vikunja"; then
  curl -s -o /dev/null -X POST "https://docker.tyan.omegaos.us/api/stacks/webhooks/e5e90834-1a42-4560-8591-e5690ef6fad2"
fi

# If caddy files were modified, notify then restart caddy (notify first — restart takes caddy down)
if echo "${MODIFIED_FILES}" | grep -qi "caddy"; then
  curl -s -o /dev/null \
    -H "Authorization: Bearer ${NTFY_TOKEN}" \
    -H "Title: Caddy Reloading" \
    -d "Caddyfile updated — restarting Caddy" \
    "${NTFY_URL}/caddy-updates"
  CADDY_ID=$(curl -s -G --unix-socket /var/run/docker.sock "http://localhost/containers/json" --data-urlencode 'filters={"name":["caddy"]}' | grep -o '"Id":"[^"]*"' | head -1 | cut -d'"' -f4)
  curl -s --unix-socket /var/run/docker.sock -X POST "http://localhost/containers/${CADDY_ID}/restart"
fi
