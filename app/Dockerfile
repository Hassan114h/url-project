### Example Dockerfile - i don't want to see copy and paste of this pls. Make your own and make sure it works. Make sure it's light, secure and instructions to run are there. 

FROM python:3.11-slim AS build
WORKDIR /w
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt
COPY src/ ./src

FROM gcr.io/distroless/python3-debian12
WORKDIR /app
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages
COPY --from=build /install /usr/local
COPY --from=build /w/src /app
USER 65532:65532
EXPOSE 8080
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]





## MY OWN DOCKERFILE I WILL SWITCH LATER
# ---- Build Stage ----
#FROM python:3.11-slim AS build
#WORKDIR /app

# Copy and install Python dependencies
#COPY requirements.txt .
#RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
#COPY src/ ./src

# ---- Runtime Stage (Distroless) ----
#FROM gcr.io/distroless/python3-debian12:latest
#WORKDIR /app

# Environment variables
#ENV PYTHONPATH=/app \
#    TABLE_NAME=urltable

# Copy Python packages and console scripts from build stage
#COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/dist-packages
#COPY --from=build /usr/local/bin /usr/local/bin

# Copy application source code
#COPY --from=build /app/src /app

# Use non-root user
#USER 65532:65532

# Expose the application port
#EXPOSE 8080

# Run the application
#CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]
#