from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    inference_service_secret: str = "changeme"
    default_model: str = "sdxl"
    model_cache_dir: str = "/models"

    # protected_namespaces=() silences pydantic warning about "model_" prefix
    # conflicting with its internal namespace — our fields genuinely start
    # with "model_" (default_model, model_cache_dir) and are not pydantic
    # special fields.
    model_config = {
        "env_prefix": "",
        "case_sensitive": False,
        "protected_namespaces": (),
    }


settings = Settings()
