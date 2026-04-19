#!/bin/sh
# Разные обои на каждый монитор для awww

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Извлекаем имена мониторов.
# Формат вывода awww query: ": HDMI-A-1: 1920x1080, ..."
# 1. grep ":" - берем строки с данными (на всякий случай)
# 2. sed 's/^: //' - убираем первое двоеточие и пробел
# 3. cut -d':' -f1 - берем всё до следующего двоеточия (получаем имя монитора)
# 4. sed 's/ //g' - убираем лишние пробелы, если они остались
MONITORS=$(awww query | sed 's/^: //' | cut -d':' -f1 | sed 's/ //g')

echo "Найдено мониторов: $MONITORS"

if [ -z "$MONITORS" ]; then
    echo "Ошибка: Не удалось получить список мониторов."
    exit 1
fi

# Для каждого монитора — своя случайная картинка
for MONITOR in $MONITORS; do
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n 1)
    
    if [ -z "$WALLPAPER" ]; then
        echo "Ошибка: В папке $WALLPAPER_DIR не найдено изображений."
        exit 1
    fi
    
    echo "Applied $WALLPAPER to $MONITOR"
    
    awww img "$WALLPAPER" \
        --outputs "$MONITOR" \
        --transition-type random \
        --transition-duration 0.7 \
        --transition-fps 60
done
