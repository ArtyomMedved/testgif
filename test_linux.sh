#!/bin/bash
# Скрипт для проверки, создания директории testgif, загрузки GIF-файла и его отображения на 5 секунд

# Функция для анимации загрузки
loading_animation() {
    local pid=$1
    local delay=0.1
    local spin='/-\|'
    local msg=$2

    while ps -p $pid > /dev/null; do
        for i in $(seq 0 3); do
            echo -ne "\r$msg ${spin:i:1}  "
            sleep $delay
        done
    done
    echo -ne "\r$msg завершено!    \n"
}

# Путь к директории и GIF-файлу
DIR="$PWD/testgif"
GIF_URL="https://mir-s3-cdn-cf.behance.net/project_modules/1400_opt_1/ec18fe47393655.5878dc40e26b6.gif"
GIF_FILE="$DIR/ec18fe47393655.5878dc40e26b6.gif"

# Проверка наличия директории testgif
if [ ! -d "$DIR" ]; then
    echo "Директория testgif не найдена. Создание..."
    mkdir "$DIR"
fi

# Загрузка GIF-файла, если он не существует, в фоновом режиме
if [ ! -f "$GIF_FILE" ]; then
    echo -n "Загрузка GIF-файла..."
    curl -o "$GIF_FILE" "$GIF_URL" > /dev/null 2>&1 &
    loading_animation $! "Загрузка GIF-файла"
else
    echo "GIF-файл уже существует."
fi

# Функция для установки пакетов с проверкой прав
install_package() {
    local package=$1
    if ! command -v "$package" &> /dev/null; then
        echo -n "$package не найден. Установка..."
        {
            sudo -k apt update > /dev/null 2>&1
            sudo -k apt install "$package" -y > /dev/null 2>&1
        } &
        loading_animation $! "Установка $package"
    else
        echo "$package уже установлен."
    fi
}

# Установка chafa
install_package "chafa"

# Установка xterm
install_package "xterm"

# Запуск нового окна терминала с использованием xterm для отображения GIF
xterm -e "cd \"$DIR\" && chafa \"$GIF_FILE\"" &

# Получение PID процесса xterm
XTERM_PID=$!

# Ожидание 3 секунд и закрытие терминала
sleep 3
kill $XTERM_PID

# Закрытие основного терминала
echo "Закрытие текущего терминала..."
kill -9 $PPID
