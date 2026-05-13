# Базовый образ с .NET 8 Runtime
FROM mcr.microsoft.com/dotnet/runtime:8.0

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    jq \
    sudo \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Определяем аргумент для ссылки
ARG UBS_URL
ENV UBS_URL=${UBS_URL}

# Скачиваем архив и распаковываем его в ./ubs
RUN curl -L -o ubs.zip "$UBS_URL" \
    && mkdir -p ./ubs \
    && unzip ubs.zip -d ./ubs \
    && rm ubs.zip

RUN useradd -m runner && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN sudo dotnet ./ubs/ubs.dll register

USER runner
WORKDIR /app
