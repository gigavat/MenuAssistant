FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV HF_HOME=/models

RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt requirements-optional.txt ./
RUN pip install --no-cache-dir torch==2.4.1 torchvision==0.19.1 --extra-index-url https://download.pytorch.org/whl/cu121 \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r requirements-optional.txt || echo "xformers skipped"

COPY app/ ./app/

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
