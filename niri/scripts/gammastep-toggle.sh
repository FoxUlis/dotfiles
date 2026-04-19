#!/bin/sh

if pgrep -x gammastep >/dev/null; then
    pkill gammastep
else
    # Запускаем daemon, который читает config.ini и работает как сейчас
    gammastep >/dev/null 2>&1 &
fi

