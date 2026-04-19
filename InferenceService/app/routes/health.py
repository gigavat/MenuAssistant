import torch
from fastapi import APIRouter, Request

router = APIRouter(tags=["health"])


@router.get("/health")
async def health():
    return {"status": "ok"}


@router.get("/models")
async def list_models(request: Request):
    pipelines = request.app.state.pipelines
    available = []
    for model_id, pipeline in pipelines.items():
        available.append(
            {
                "id": model_id,
                "name": pipeline.name,
                "vram_gb": pipeline.vram_gb,
            }
        )

    loaded = request.app.state.loaded_model

    gpu_info = {}
    if torch.cuda.is_available():
        gpu_info = {
            "gpu": torch.cuda.get_device_name(0),
            "vram_total_gb": round(
                torch.cuda.get_device_properties(0).total_mem / 1e9, 1
            ),
            "vram_free_gb": round(
                (
                    torch.cuda.get_device_properties(0).total_mem
                    - torch.cuda.memory_allocated(0)
                )
                / 1e9,
                1,
            ),
        }

    return {"available": available, "loaded": loaded, **gpu_info}
