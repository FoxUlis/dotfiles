#!/bin/sh
# Скрипт для таймера (демон awww уже запущен, не убиваем его!)

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Извлекаем имена мониторов.
# Формат вывода awww query: ": HDMI-A-1: 1920x1080, ..."
MONITORS=$(awww query | sed 's/^: //' | cut -d':' -f1 | sed 's/ //g')

# Если мониторы не найдены, тихо выходим (чтобы не спамить ошибками в логах крона)
if [ -z "$MONITORS" ]; then
    exit 1
fi

# Для каждого монитора — своя случайная картинка
for MONITOR in $MONITORS; do
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n 1)
    
    if [ -n "$WALLPAPER" ]; then
        awww img "$WALLPAPER" \
            --outputs "$MONITOR" \
            --transition-type random \
            --transition-duration 0.7 \
            --transition-fps 60
    fi
done
