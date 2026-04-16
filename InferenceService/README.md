# InferenceService

Self-hosted Python ML микросервис для MenuAssistant. Генерация food photos
через Stable Diffusion XL (позже Flux NF4) на удалённой GPU машине.

**Статус**: 📋 Spec. Реализация в Sprint 4.5.

---

## Quick facts

- **Stack**: Python 3.11 + FastAPI + diffusers + PyTorch CUDA 12.1
- **Модели**: SDXL 1.0 (default), Flux.1 Schnell NF4 (optional), NLLB-200 (Sprint 5 optional)
- **Deployment**: Docker + NVIDIA Container Toolkit на remote GPU машине
- **Target hardware**: Ryzen 5950x + RTX 3080 Ti 12GB + 64GB RAM
- **API**: HTTP Bearer auth, stateless, returns raw image bytes
- **Integration**: вызывается из Serverpod через `InferenceServiceClient`

Полный дизайн — [`DATASET_DESIGN.md`](../DATASET_DESIGN.md#inferenceservice--self-hosted-ml-микросервис) секция "InferenceService".

---

## Планируемая структура

```
InferenceService/
├── README.md                   # this file
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env.example                # template для INFERENCE_SERVICE_SECRET
├── .gitignore                  # models/, venv/, __pycache__/, .env
└── app/
    ├── __init__.py
    ├── main.py                 # FastAPI app entry point
    ├── config.py               # env vars, secrets
    ├── auth.py                 # shared-secret Bearer middleware
    ├── routes/
    │   ├── __init__.py
    │   ├── health.py           # GET /health, GET /models
    │   └── image.py            # POST /generate/image
    └── models/
        ├── __init__.py
        ├── base.py             # abstract ImagePipeline
        ├── sdxl_pipeline.py    # diffusers SDXL wrapper
        └── flux_pipeline.py    # Flux NF4 wrapper (optional)
```

---

## Основные компоненты

### `app/main.py`

FastAPI app entry, startup hook загружает default model в VRAM,
регистрирует routes:

```python
from fastapi import FastAPI
from app.config import settings
from app.routes import health, image
from app.models.sdxl_pipeline import SdxlPipeline

app = FastAPI(title="MenuAssistant InferenceService", version="0.1.0")
app.state.pipelines = {}

@app.on_event("startup")
async def load_default_model():
    if settings.default_model == "sdxl":
        app.state.pipelines["sdxl"] = SdxlPipeline()
        app.state.pipelines["sdxl"].load()
    # flux-schnell-nf4 loaded on-demand

app.include_router(health.router)
app.include_router(image.router)
```

### `app/auth.py`

Bearer token middleware:

```python
from fastapi import HTTPException, Depends, Header
from app.config import settings

async def verify_token(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing bearer token")
    token = authorization[7:]
    if token != settings.inference_service_secret:
        raise HTTPException(status_code=401, detail="Invalid token")
```

### `app/routes/image.py`

```python
from fastapi import APIRouter, Depends, Request
from fastapi.responses import Response
from pydantic import BaseModel, Field
from app.auth import verify_token

router = APIRouter(prefix="/generate", tags=["image"])

class ImageRequest(BaseModel):
    prompt: str
    negative_prompt: str | None = None
    width: int = Field(default=1024, ge=256, le=2048)
    height: int = Field(default=1024, ge=256, le=2048)
    steps: int = Field(default=30, ge=1, le=100)
    guidance_scale: float = Field(default=7.5, ge=1.0, le=20.0)
    seed: int | None = None
    model: str = "sdxl"

@router.post("/image", dependencies=[Depends(verify_token)])
async def generate_image(req: ImageRequest, request: Request):
    pipelines = request.app.state.pipelines
    if req.model not in pipelines:
        # lazy load if not yet loaded
        ...
    pipeline = pipelines[req.model]

    image_bytes = pipeline.generate(
        prompt=req.prompt,
        negative_prompt=req.negative_prompt,
        width=req.width,
        height=req.height,
        steps=req.steps,
        guidance_scale=req.guidance_scale,
        seed=req.seed,
    )

    return Response(
        content=image_bytes,
        media_type="image/jpeg",
        headers={
            "X-Model": pipeline.name,
            "X-Inference-Time-Ms": str(pipeline.last_inference_ms),
        },
    )
```

### `app/models/sdxl_pipeline.py`

```python
from io import BytesIO
import time
import torch
from diffusers import StableDiffusionXLPipeline

class SdxlPipeline:
    def __init__(self):
        self.name = "stabilityai/stable-diffusion-xl-base-1.0"
        self.pipe = None
        self.last_inference_ms = 0

    def load(self):
        self.pipe = StableDiffusionXLPipeline.from_pretrained(
            self.name,
            torch_dtype=torch.float16,
            use_safetensors=True,
            variant="fp16",
        ).to("cuda")
        # Optional optimizations:
        self.pipe.enable_xformers_memory_efficient_attention()

    def generate(self, prompt, negative_prompt=None, width=1024, height=1024,
                 steps=30, guidance_scale=7.5, seed=None):
        generator = torch.Generator(device="cuda").manual_seed(seed) if seed else None
        start = time.time()

        image = self.pipe(
            prompt=prompt,
            negative_prompt=negative_prompt,
            width=width,
            height=height,
            num_inference_steps=steps,
            guidance_scale=guidance_scale,
            generator=generator,
        ).images[0]

        self.last_inference_ms = int((time.time() - start) * 1000)

        buffer = BytesIO()
        image.save(buffer, format="JPEG", quality=92)
        return buffer.getvalue()
```

### `requirements.txt`

```
fastapi==0.115.0
uvicorn[standard]==0.30.6
pydantic==2.9.2
pydantic-settings==2.5.2
python-multipart==0.0.9

torch==2.4.1
torchvision==0.19.1
diffusers==0.30.3
transformers==4.44.2
accelerate==0.33.0
safetensors==0.4.5
xformers==0.0.28

Pillow==10.4.0
```

**Note**: `torch` + `xformers` для CUDA 12.1 ставятся с дополнительным index-url,
docker file это делает автоматически:
```
pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/cu121
```

### `Dockerfile`

```dockerfile
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV HF_HOME=/models

RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir torch torchvision --extra-index-url https://download.pytorch.org/whl/cu121 \
    && pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### `docker-compose.yml`

```yaml
services:
  inference:
    build: .
    ports:
      - "8000:8000"
    environment:
      - INFERENCE_SERVICE_SECRET=${INFERENCE_SERVICE_SECRET}
      - DEFAULT_MODEL=sdxl
      - HF_HOME=/models
    volumes:
      - ./models_cache:/models
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 5s
      retries: 3
```

### `.env.example`

```
# Generate with: openssl rand -hex 32
INFERENCE_SERVICE_SECRET=replace_me_with_random_hex

# Default model loaded at startup
DEFAULT_MODEL=sdxl
```

### `.gitignore`

```
# Python
__pycache__/
*.pyc
*.pyo
venv/
.env
*.egg-info/

# Models cache (~10GB, never commit)
models_cache/
models/

# Docker volumes
*.tar

# IDE
.vscode/
.idea/
```

---

## Deployment workflow

### First-time setup на GPU машине

1. **Prerequisites**:
   ```bash
   # NVIDIA driver
   nvidia-smi    # должен показать GPU

   # Docker + NVIDIA Container Toolkit
   sudo apt install docker.io docker-compose-plugin
   # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
   sudo nvidia-ctk runtime configure --runtime=docker
   sudo systemctl restart docker

   # Verify GPU accessible в Docker
   docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi
   ```

2. **Clone repo + setup**:
   ```bash
   git clone <menuassistant-repo-url>
   cd MenuAssistant3/InferenceService

   # Generate secret
   echo "INFERENCE_SERVICE_SECRET=$(openssl rand -hex 32)" > .env
   echo "DEFAULT_MODEL=sdxl" >> .env
   cat .env    # save secret somewhere safe для Serverpod config
   ```

3. **Build + start**:
   ```bash
   docker compose up -d --build
   docker compose logs -f    # watch first startup (model download takes ~5 min)
   ```

4. **Test**:
   ```bash
   curl http://localhost:8000/health
   # → {"status": "ok"}

   SECRET=$(grep INFERENCE_SERVICE_SECRET .env | cut -d= -f2)
   curl -X POST http://localhost:8000/generate/image \
     -H "Authorization: Bearer $SECRET" \
     -H "Content-Type: application/json" \
     -d '{"prompt": "Professional food photography of spaghetti carbonara, plated on white ceramic"}' \
     --output test.jpg
   # → test.jpg (1024x1024 JPEG)
   ```

### Network access from Serverpod dev laptop

**Текущий вариант: Keenetic KeenDNS reverse proxy**

GPU машина за роутером Keenetic. Keenetic выдаёт HTTPS URL через KeenDNS
(`yourname.keenetic.pro`) с auto Let's Encrypt, делает TLS termination и
форвардит на `http://<gpu-lan-ip>:8000`.

Serverpod config:
```yaml
inferenceServiceBaseUrl: 'https://yourname.keenetic.pro'
```

**Настройка Keenetic**: KeenDNS (Сетевые правила → Доменное имя) +
port forwarding (443 → gpu-ip:8000). Подробности в
[DATASET_DESIGN.md](../DATASET_DESIGN.md#network-connectivity).

**NAT hairpin gotcha**: если Serverpod dev и GPU в одной LAN —
`yourname.keenetic.pro` может не резолвиться. Использовать
`http://192.168.x.x:8000` напрямую (менять `inferenceServiceBaseUrl` в
passwords.yaml в зависимости от сети).

**Альтернативы**: SSH tunnel, Tailscale, Cloudflare Tunnel — см. DATASET_DESIGN.md.

### Updates

```bash
git pull
docker compose up -d --build    # rebuild with new code
docker compose logs -f
```

Modely persist в `models_cache/` volume, не пере-скачиваются.

---

## Troubleshooting

**`CUDA out of memory` при startup**:
- Проверить что другие процессы не используют GPU: `nvidia-smi`
- Уменьшить `variant="fp16"` → `variant="fp32"` не помогает, только наоборот
- Переключиться на SD 1.5 как default (~4GB VRAM вместо 8GB)

**Cold start очень медленный (30+ сек)**:
- Нормально — модель грузится в VRAM
- После warmup все запросы ~5 сек

**`Model not found` или HF 401/403**:
- SDXL публичная, не требует HF token
- Если используешь gated модель (Flux Dev) — нужен HF token в env:
  `HUGGING_FACE_HUB_TOKEN=hf_xxx`

**Docker can't access GPU**:
- `docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi`
- Если не работает — NVIDIA Container Toolkit не установлен или не настроен
- Следуй [official guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

**Высокий VRAM usage после многих запросов**:
- PyTorch fragmentation — перезапустить контейнер: `docker compose restart`
- Opционально: добавить `torch.cuda.empty_cache()` после каждого generate

---

## Future roadmap

- [ ] **Sprint 4.5**: базовая реализация SDXL pipeline, Docker deploy, integration с Serverpod
- [ ] **Sprint 4.5+**: опционально Flux.1 Schnell NF4 для лучшего качества
- [ ] **Sprint 5**: добавить `/translate` endpoint с NLLB-200 600M для batch translations
- [ ] **Sprint 5+**: опционально `/generate/text` endpoint с Qwen 2.5 14B через Ollama subprocess (только если cloud Claude будет слишком дорогим)
- [ ] **Sprint 6 prod**: вместо SSH tunnel — internal VPC или Cloudflare Tunnel, health check метрики в CloudWatch/Grafana
- [ ] **Long-term**: batch inference optimization (combine 4-8 images в один forward pass для throughput)

---

## Related documents

- [DATASET_DESIGN.md](../DATASET_DESIGN.md) — полная архитектура + API spec + integration design
- [ROADMAP.md](../ROADMAP.md) — Sprint 4.5 pre-requisites и script plan
- [API_KEYS.md](../MenuAssistant/menu_assistant_server/API_KEYS.md) — секция "4. InferenceService"
