#!/bin/sh

if [ -f "/defaults/spyserver.config" -a -d "/config" -a ! -f "/config/spyserver.config" ]; then
    cp /defaults/spyserver.config /config/
fi

exec /app/spyserver "$@"