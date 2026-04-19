from fastapi import HTTPException, Header

from app.config import settings


async def verify_token(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing bearer token")
    token = authorization[7:]
    if token != settings.inference_service_secret:
        raise HTTPException(status_code=401, detail="Invalid token")
