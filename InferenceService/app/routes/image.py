import logging

from fastapi import APIRouter, Depends, Request
from fastapi.responses import Response
from pydantic import BaseModel, Field

from app.auth import verify_token
from app.models.flux_pipeline import FluxSchnellGgufPipeline
from app.models.sdxl_pipeline import SdxlPipeline

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/generate", tags=["image"])


class ImageRequest(BaseModel):
    prompt: str
    negative_prompt: str | None = None
    width: int = Field(default=1024, ge=256, le=2048)
    height: int = Field(default=1024, ge=256, le=2048)
    # Flux Schnell uses 4 steps; SDXL uses ~30. Low default lets either work;
    # callers that want SDXL should pass steps=30.
    steps: int = Field(default=4, ge=1, le=100)
    # Flux Schnell requires guidance_scale=0.0 (distilled); SDXL expects ~7.5.
    guidance_scale: float = Field(default=0.0, ge=0.0, le=20.0)
    seed: int | None = None
    model: str = "flux-schnell"


def _build_pipeline(model_id: str):
    if model_id == "sdxl":
        return SdxlPipeline()
    if model_id in ("flux-schnell", "flux-schnell-gguf"):
        return FluxSchnellGgufPipeline()
    return None


@router.post("/image", dependencies=[Depends(verify_token)])
async def generate_image(req: ImageRequest, request: Request):
    pipelines = request.app.state.pipelines

    if req.model not in pipelines:
        pipeline = _build_pipeline(req.model)
        if pipeline is None:
            return Response(
                content=f'{{"error": "Unknown model: {req.model}"}}',
                status_code=400,
                media_type="application/json",
            )
        logger.info("Lazy-loading %s pipeline...", req.model)
        pipeline.load()
        pipelines[req.model] = pipeline
        request.app.state.loaded_model = req.model

    pipeline = pipelines[req.model]

    try:
        image_bytes = pipeline.generate(
            prompt=req.prompt,
            negative_prompt=req.negative_prompt,
            width=req.width,
            height=req.height,
            steps=req.steps,
            guidance_scale=req.guidance_scale,
            seed=req.seed,
        )
    except Exception as e:
        logger.exception("Generation failed")
        return Response(
            content=f'{{"error": "{type(e).__name__}", "details": "{e}"}}',
            status_code=500,
            media_type="application/json",
        )

    return Response(
        content=image_bytes,
        media_type="image/jpeg",
        headers={
            "X-Model": pipeline.name,
            "X-Inference-Time-Ms": str(pipeline.last_inference_ms),
        },
    )
