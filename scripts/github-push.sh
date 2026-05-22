#!/bin/sh
# Notify ntfy of GitHub push
curl -s -o /dev/null \
  -H "Authorization: Bearer ${NTFY_TOKEN}" \
  -H "Title: GitHub Push: ${REPO_NAME}" \
  -d "${PUSHER_NAME}: ${COMMIT_MSG}" \
  "${NTFY_URL}/github-updates"

# Helper: trigger Portainer stack redeploy by webhook UUID
portainer_deploy() {
  curl -s -o /dev/null -X POST "https://docker.tyan.omegaos.us/api/stacks/webhooks/$1"
}

# Redeploy only the stack whose files were modified
if echo "${MODIFIED_FILES}" | grep -qi "broadcast-box";  then portainer_deploy "2ee75032-7dff-4b29-a739-1be7c6a95e47"; fi
if echo "${MODIFIED_FILES}" | grep -qi "fluidd";         then portainer_deploy "3cf98082-f543-4e74-b378-d3d6b272c839"; fi
if echo "${MODIFIED_FILES}" | grep -qi "homeassistant";  then portainer_deploy "821623aa-b61a-4dc2-93c2-dcd21bb5930b"; fi
if echo "${MODIFIED_FILES}" | grep -qi "homepage";       then portainer_deploy "7543edb8-df22-4dbd-ad7a-671910094ce6"; fi
if echo "${MODIFIED_FILES}" | grep -qi "mainsail";       then portainer_deploy "16e07e19-d2ad-419c-949f-c9382138ebad"; fi
if echo "${MODIFIED_FILES}" | grep -qi "mcserver";       then portainer_deploy "78cf4308-193c-4352-a40a-7cf407319b2d"; fi
if echo "${MODIFIED_FILES}" | grep -qi "moonraker-mcp";  then portainer_deploy "0e1d1d4b-6445-40ed-8931-5c1bcb9d15b1"; fi
if echo "${MODIFIED_FILES}" | grep -qi "ntfy";           then portainer_deploy "e038919f-1a6d-4d50-9250-c04ebb1ae1fc"; fi
if echo "${MODIFIED_FILES}" | grep -qi "orb-docker";     then portainer_deploy "c022728e-4996-4ad8-b419-2001af9ba7e9"; fi
if echo "${MODIFIED_FILES}" | grep -qi "plex";           then portainer_deploy "94c0d902-927b-4c13-ba2f-4d6b5280e76b"; fi
if echo "${MODIFIED_FILES}" | grep -qi "romm";           then portainer_deploy "5cb3eeca-0e48-4b6d-a4d8-140129bd8f9f"; fi
if echo "${MODIFIED_FILES}" | grep -qi "rustdesk";       then portainer_deploy "814e36b2-14cd-45ba-bcda-d007f9bfcc9d"; fi
if echo "${MODIFIED_FILES}" | grep -qi "spoolman";       then portainer_deploy "b77b5554-7f65-41d6-8038-45539bc285ba"; fi
if echo "${MODIFIED_FILES}" | grep -qi "testtop";        then portainer_deploy "ecbfa1be-3ab8-48bb-afd3-d5fab34ddba4"; fi
if echo "${MODIFIED_FILES}" | grep -qi "vikunja";        then portainer_deploy "e5e90834-1a42-4560-8591-e5690ef6fad2"; fi
if echo "${MODIFIED_FILES}" | grep -qi "watchtower";     then portainer_deploy "3369e08f-a8a6-4f9a-9988-601bd889e3c7"; fi
if echo "${MODIFIED_FILES}" | grep -qi "webhook-receiver"; then portainer_deploy "26a8793b-2a6f-46d6-80a0-b45b7f1bd502"; fi
if echo "${MODIFIED_FILES}" | grep -qi "webtop";         then portainer_deploy "5fbdec16-2510-4c2c-b39b-318f5d0bcf19"; fi

# Caddy: notify ntfy BEFORE restarting (Caddy proxies ntfy — order matters)
if echo "${MODIFIED_FILES}" | grep -qi "caddy"; then
  curl -s -o /dev/null \
    -H "Authorization: Bearer ${NTFY_TOKEN}" \
    -H "Title: Caddy Reloading" \
    -d "Caddyfile updated — restarting Caddy" \
    "${NTFY_URL}/caddy-updates"
  CADDY_ID=$(curl -s -G --unix-socket /var/run/docker.sock "http://localhost/containers/json" --data-urlencode 'filters={"name":["caddy"]}' | grep -o '"Id":"[^"]*"' | head -1 | cut -d'"' -f4)
  curl -s --unix-socket /var/run/docker.sock -X POST "http://localhost/containers/${CADDY_ID}/restart"
fi
