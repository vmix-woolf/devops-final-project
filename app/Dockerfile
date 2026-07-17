FROM python:3.11-slim

# Вимикаємо створення .pyc файлів і буферизацію логів
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Встановлюємо системні залежності для PostgreSQL
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Збираємо статичні файли під час створення image
RUN DJANGO_SECRET_KEY=build-secret \
    POSTGRES_PASSWORD=build-password \
    POSTGRES_HOST=localhost \
    python manage.py collectstatic --noinput

EXPOSE 8000

CMD [
    "gunicorn",
    "config.wsgi:application",
    "--bind",
    "0.0.0.0:8000",
    "--workers",
    "3",
    "--timeout",
    "60"
]
