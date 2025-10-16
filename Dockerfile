FROM python:3.10-slim

WORKDIR /app

# Accept APP_VERSION as build argument
ARG APP_VERSION
ENV APP_VERSION=$APP_VERSION

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
