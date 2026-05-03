# final/Django/django/Dockerfile

FROM python:3.10-slim

WORKDIR /app

# Копіюємо requirements.txt з підкаталогу Django/django
COPY Django/django/requirements.txt .

# Встановлюємо залежності
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо увесь код з каталогу lesson-db-module/Django/django
COPY Django/django/ .

# Налаштовуємо змінні середовища для Postgres
ENV POSTGRES_HOST=${POSTGRES_HOST}
ENV POSTGRES_PORT=${POSTGRES_PORT}
ENV POSTGRES_DB=${POSTGRES_DB}
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

EXPOSE 8081

CMD ["python", "manage.py", "runserver", "0.0.0.0:8081"]
