import logging

from fastapi import FastAPI

from app.config import settings
from app.models.flux_pipeline import FluxSchnellGgufPipeline
from app.models.sdxl_pipeline import SdxlPipeline
from app.routes import health, image

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="MenuAssistant InferenceService", version="0.1.0")
app.state.pipelines = {}
app.state.loaded_model = None


def _build_pipeline(model_id: str):
    if model_id == "sdxl":
        return SdxlPipeline()
    if model_id in ("flux-schnell", "flux-schnell-gguf"):
        return FluxSchnellGgufPipeline()
    raise ValueError(f"Unknown model id: {model_id}")


@app.on_event("startup")
async def load_default_model():
    model = settings.default_model
    logger.info("Loading default model: %s", model)

    try:
        pipeline = _build_pipeline(model)
        pipeline.load()
        app.state.pipelines[model] = pipeline
        app.state.loaded_model = model
        logger.info("%s loaded successfully", model)
    except Exception:
        logger.exception("Failed to load default model '%s'", model)
        logger.warning("Starting with no preloaded model — will lazy-load on first request")


app.include_router(health.router)
app.include_router(image.router)
