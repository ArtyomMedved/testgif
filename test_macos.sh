#!/bin/bash
# Скрипт для проверки, создания директории testgif и загрузки GIF-файла на macOS

# Путь к директории и GIF-файлу
DIR="$PWD/testgif"
GIF_URL="https://mir-s3-cdn-cf.behance.net/project_modules/1400_opt_1/ec18fe47393655.5878dc40e26b6.gif"
GIF_FILE="$DIR/ec18fe47393655.5878dc40e26b6.gif"

# Проверка наличия директории testgif
if [ ! -d "$DIR" ]; then
    echo "Директория testgif не найдена. Создание..."
    mkdir "$DIR"
fi

# Загрузка GIF-файла, если он не существует
if [ ! -f "$GIF_FILE" ]; then
    echo "Загрузка GIF-файла..."
    curl -o "$GIF_FILE" "$GIF_URL"
else
    echo "GIF-файл уже существует."
fi

# Проверка наличия chafa и установка, если он не установлен
if ! command -v chafa &> /dev/null; then
    echo "chafa не найден. Установка через Homebrew..."
    brew install chafa
else
    echo "chafa уже установлен."
fi

# Запуск Terminal.app с нужными параметрами на macOS
osascript <<END
tell application "Terminal"
    do script "cd \"$DIR\" && chafa ec18fe47393655.5878dc40e26b6.gif"
    set bounds of front window to {100, 100, 700, 500}
    delay 5 -- Задержка на 5 секунд
    tell application "System Events"
        key down control -- Нажимаем и удерживаем Control
        keystroke "c" -- Имитируем нажатие C
        key up control -- Отпускаем Control
    end tell
    delay 2 -- Задержка на 2 секунд
    close front window -- Закрываем текущее окно терминала
end tell
END
