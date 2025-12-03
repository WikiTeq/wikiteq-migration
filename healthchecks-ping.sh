#!/bin/sh

if [ -z "$H_PING_KEY" ] || [ -z "$H_SLUG" ] || [ -z "$H_SLUG_SUFFIX" ]; then
    # nothing to do if the key is not set
    exit 0
fi

echo "Pinging healthchecks.io..."
wget --timeout=10 --tries=5 -qO- "https://hc-ping.com/${H_PING_KEY}/${H_SLUG}${H_SLUG_SUFFIX}?create=1"
echo "Done."
