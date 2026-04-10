## Build Stage
FROM python:3.11-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
COPY . .

FROM gcr.io/distroless/python3-debian12
WORKDIR /app

ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages
COPY --from=build /install /usr/local
COPY --from=build /app /app

EXPOSE 8080
CMD ["-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
