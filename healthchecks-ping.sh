#!/bin/sh

if [ -z "$H_PING_KEY" ] || [ -z "$H_SLUG" ] || [ -z "$H_SLUG_SUFFIX" ]; then
    # nothing to do if the key is not set
    exit 0
fi

echo "Pinging healthchecks.io..."
if command -v curl >/dev/null 2>&1; then
    curl -m 10 --retry 5 "https://hc-ping.com/${H_PING_KEY}/${H_SLUG}${H_SLUG_SUFFIX}?create=1"
else
    wget --timeout=10 --tries=5 -qO- "https://hc-ping.com/${H_PING_KEY}/${H_SLUG}${H_SLUG_SUFFIX}?create=1"
fi
echo "Done."
