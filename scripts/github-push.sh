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
  CADDY_ID=$(curl -s --unix-socket /var/run/docker.sock "http://localhost/containers/json" | python3 -c "import sys,json; cs=json.load(sys.stdin); c=next((x for x in cs if any('caddy' in n.lower() for n in x['Names'])),None); print(c['Id'] if c else '')")
  curl -s --unix-socket /var/run/docker.sock -X POST "http://localhost/containers/${CADDY_ID}/restart"
fi
